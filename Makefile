COVERAGE_REPORT := coverage.txt
COVERAGE_PROFILE := profile.out
COVERAGE_MODE := atomic

LINGUIST_PATH = .linguist

$(LINGUIST_PATH):
	git clone https://github.com/github/linguist.git $@

test: $(LINGUIST_PATH)
	go test -v ./...

test-coverage: $(LINGUIST_PATH)
	@echo "mode: $(COVERAGE_MODE)" > $(COVERAGE_REPORT); \
		for dir in `find . -name "*.go" | grep -o '.*/' | sort -u | grep -v './fixtures/' | grep -v './.linguist/'`; do \
			go test $$dir -coverprofile=$(COVERAGE_PROFILE) -covermode=$(COVERAGE_MODE); \
			if [ $$? != 0 ]; then \
				exit 2; \
			fi; \
			if [ -f $(COVERAGE_PROFILE) ]; then \
				tail -n +2 $(COVERAGE_PROFILE) >> $(COVERAGE_REPORT); \
				rm $(COVERAGE_PROFILE); \
			fi; \
	done;

code-generate: $(LINGUIST_PATH)
	mkdir -p data
	go run internal/code-generator/main.go

clean:
	rm -rf $(LINGUIST_PATH)
