PROG ?= pwnedpasswords.sh

all:
	@echo "$(PROG) is a shell script and does not need compilation, it can be simply executed."

lint:
	@shellcheck -s bash $(PROG)

.PHONY: lint
