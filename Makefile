.PHONY: doctor setup build smoke semantic validate tables clean-results test
doctor setup build smoke validate tables clean-results:
	./artifact.sh $@
semantic:
	./artifact.sh reproduce semantic
test:
	$(or $(ORBIT_PYTHON),python3) -m unittest discover -s tests -v
