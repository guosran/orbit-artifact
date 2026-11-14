// Source/target-generated choices use the public ORBIT beam. Python evaluates.
#include "Taskflow/ProgramBeamSearch.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/SHA256.h"
#include "llvm/Support/raw_ostream.h"
#include <cerrno>
#include <filesystem>
#include <fstream>
#include <limits>
#include <string>
#include <sys/wait.h>
#include <unistd.h>
using namespace orbit::taskflow;
namespace j = llvm::json;
static bool save(const std::string &path, const j::Value &value) {
  std::string text;
  llvm::raw_string_ostream stream(text);
  stream << value;
  stream.flush();
  std::ofstream output(path);
  output << text << '\n';
  output.flush();
  return static_cast<bool>(output);
}
static std::optional<j::Value> load(const std::string &path) {
  auto buffer = llvm::MemoryBuffer::getFile(path);
  if (!buffer)
    return std::nullopt;
  auto value = j::parse((*buffer)->getBuffer());
  if (!value) {
    llvm::consumeError(value.takeError());
    return std::nullopt;
  }
  return std::move(*value);
}
static std::optional<j::Value> fileIdentity(const std::string &path) {
  auto buffer = llvm::MemoryBuffer::getFile(path);
  if (!buffer)
    return std::nullopt;
  auto digest =
      llvm::SHA256::hash(llvm::arrayRefFromStringRef((*buffer)->getBuffer()));
  return j::Object{{"path", path}, {"sha256", llvm::toHex(digest, true)}};
}
int main(int argc, char **argv) {
  if (argc != 6) {
    llvm::errs() << "usage: gemm-operator-search domain.json evaluator.py "
                    "python output-dir max-evaluations\n";
    return 2;
  }
  std::string output = argv[4];
  std::error_code filesystemError;
  if (std::filesystem::exists(output, filesystemError) || filesystemError) {
    llvm::errs() << "refusing to overwrite search evidence\n";
    return 2;
  }
  auto domain = load(argv[1]);
  auto *root = domain ? domain->getAsObject() : nullptr;
  auto *choices = root ? root->getArray("choices") : nullptr;
  auto *base = root ? root->getObject("request_base") : nullptr;
  int64_t budget = 0;
  if (!choices || !base || llvm::StringRef(argv[5]).getAsInteger(10, budget) ||
      budget <= 0) {
    llvm::errs() << "invalid generated domain or evaluation budget\n";
    return 2;
  }
  ProgramSearchSpace space;
  ProgramSearchDimension dimension;
  dimension.id = "prefill.L0.qkv.implementation";
  dimension.scope = "source-operator";
  dimension.status =
      "source-target-domain; lowering and hardware checked on demand";
  for (const auto &value : *choices) {
    auto *choice = value.getAsObject();
    auto id = choice ? choice->getString("id") : std::nullopt;
    if (!id) {
      llvm::errs() << "choice has no stable identity\n";
      return 2;
    }
    dimension.choices.push_back({id->str(), value});
  }
  space.dimensions.push_back(std::move(dimension));
  if (!std::filesystem::create_directory(output, filesystemError) ||
      filesystemError || !save(output + "/input-domain.json", *domain)) {
    llvm::errs() << "cannot create exclusive search evidence directory\n";
    return 2;
  }
  auto binaryIdentity = fileIdentity(argv[0]);
  auto domainIdentity = fileIdentity(argv[1]);
  auto evaluatorIdentity = fileIdentity(argv[2]);
  if (!binaryIdentity || !domainIdentity || !evaluatorIdentity) {
    llvm::errs() << "cannot bind search/evaluator inputs\n";
    return 2;
  }
  int64_t sequence = 0;
  ProgramSearchEvaluator evaluate =
      [&](const std::vector<int64_t> &assignment) {
        ProgramSearchEvaluation result;
        result.feasibilityKnown = false;
        if (assignment.size() != 1 || assignment[0] < 0 ||
            static_cast<size_t>(assignment[0]) >= choices->size()) {
          result.message = "invalid beam assignment";
          return result;
        }
        auto request = *base;
        request["candidate"] = (*choices)[assignment[0]];
        std::string directory =
            output + "/evaluation-" + std::to_string(sequence++);
        std::filesystem::create_directory(directory);
        std::string path = directory + "/request.json";
        auto evaluatorNow = fileIdentity(argv[2]);
        if (!save(path, std::move(request)) || !evaluatorNow ||
            *evaluatorNow != *evaluatorIdentity) {
          result.message =
              "cannot write evaluation request or evaluator identity changed";
          return result;
        }
        pid_t child = fork();
        if (child == 0) {
          execl(argv[3], argv[3], argv[2], "--request", path.c_str(),
                "--output", directory.c_str(), static_cast<char *>(nullptr));
          _exit(127);
        }
        int status = -1;
        pid_t waited = -1;
        if (child > 0) {
          do {
            waited = waitpid(child, &status, 0);
          } while (waited < 0 && errno == EINTR);
        }
        auto measured = load(directory + "/result.json");
        auto *measurement = measured ? measured->getAsObject() : nullptr;
        if (!measurement || waited != child || status == -1 ||
            !WIFEXITED(status) || WEXITSTATUS(status) != 0) {
          result.message =
              "evaluation process failed; feasibility and cost unknown";
          return result;
        }
        result.feasibilityKnown =
            measurement->getBoolean("feasibility_known").value_or(false);
        result.feasible = measurement->getBoolean("feasible").value_or(false);
        result.costMs = measurement->getNumber("cost_ms");
        result.message = measurement->getString("message").value_or("").str();
        result.result = std::move(*measured);
        return result;
      };
  ProgramSearchOptions options;
  options.wallSeconds = std::numeric_limits<double>::infinity();
  options.maxEvaluations = budget;
  ProgramBeamTraceOptions trace;
  trace.retainInMemory = false;
  std::ofstream traceFile(output + "/trace.jsonl");
  if (!traceFile) {
    llvm::errs() << "cannot open search trace\n";
    return 2;
  }
  trace.sink = [&](const j::Value &value) {
    std::string text;
    llvm::raw_string_ostream stream(text);
    stream << value;
    stream.flush();
    traceFile << text << '\n';
    traceFile.flush();
  };
  auto result =
      searchProgramSpaceBeam(space, evaluate, options, 4, -1, 0, {}, trace);
  j::Object report;
  report["schema"] = "orbit.source-generated-gemm-beam.v1";
  report["adapter_executable"] = std::move(*binaryIdentity);
  report["domain_input"] = std::move(*domainIdentity);
  report["evaluator_script"] = std::move(*evaluatorIdentity);
  if (auto *provenance = root->getObject("provenance"))
    report["provenance"] = j::Object(*provenance);
  report["report"] = std::move(result.report);
  report["scope"] = "one real Qwen source GEMM; bounded evaluations, no "
                    "full-model or global-optimum claim";
  report["overall_wall_cap_seconds"] = nullptr;
  report["evaluation_quota"] = budget;
  report["domain_choices"] = static_cast<int64_t>(choices->size());
  report["has_best"] = result.hasBest;
  if (result.hasBest) {
    report["selected"] = (*choices)[result.bestAssignment[0]];
    report["selected_measurement"] = std::move(result.bestEvaluation.result);
  }
  if (!traceFile || !save(output + "/search.json", std::move(report))) {
    llvm::errs() << "failed to write complete search evidence\n";
    return 2;
  }
  return result.hasBest ? 0 : 1;
}
