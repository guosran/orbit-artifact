#include "llvm/Support/JSON.h"
#include "llvm/Support/raw_ostream.h"
int main() {
 auto parsed=llvm::json::parse(R"({"generic_air":{"capacity_bytes":1048576,"capabilities":{"tile_alignment":[1,1,1],"implementations":[{"kind":"scalar","lanes":1}]},"theoretical":{"launch_ms":0.1,"per_scalar_operation_ms":0.000001,"per_transfer_byte_ms":0.0000001}},"source_auto_candidates":{"function":"pointwise","rows":2,"cols":2,"max_fission_actions":8}})");
 if(!parsed)return 2;
 parsed->getAsObject()->erase("source_auto_candidates");
 llvm::json::Value copied=*parsed;
 llvm::outs()<<copied<<'\n';
}
