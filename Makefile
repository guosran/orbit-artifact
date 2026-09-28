.PHONY: doctor setup build smoke semantic status validate tables clean-results test
doctor setup build smoke status validate tables clean-results:
	./artifact.sh $@
semantic:
	./artifact.sh reproduce semantic
test:
	$(or $(ORBIT_PYTHON),python3) scripts/run_harness_tests.py
