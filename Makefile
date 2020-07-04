## Copyright (C) 2020 Abhijit Bose
## SPDX-License-Identifier: GPL-2.0-only

# Makefile for testing

# Set the Port where DUT is attached
PORT=/dev/ttyUSB0
# The default baud-rate that would be used to test out the DUT
BAUD=9600
# If we are ready with the require loop back setup to run the Tests
LOOPBACK=YES

# Command
TEST_CMD=TEST_PORT=$(PORT) TEST_BAUD=$(BAUD) TEST_LOOPBACK=$(LOOPBACK) go test -race

# Get all Packages in current directory
PACKAGES = $(shell find ./ -type d -not -path '*/\.*')

## Tags

test: hwsetup
	$(TEST_CMD) -v .

cover-count-start:
	echo "mode: count" > coverage-all.out

cover-count: hwsetup
	$(TEST_CMD) -v -cover -coverprofile=coverage.out -covermode=count .
	tail -n +2 coverage.out >> coverage-all.out

cover: hwsetup
	$(TEST_CMD)	-v -cover -coverprofile=coverage.out .
	go tool cover -html=coverage.out

cover-all:
	go tool cover -html=coverage-all.out

hwsetup:
	@echo .
	@echo . Hardware Test Section 1
	@echo .
	export TEST_PORT=$(PORT)
	export TEST_BAUD=$(BAUD)
	export TEST_LOOPBACK=YES
	@echo .
	@echo . SERIAL PORT SETUP
	@echo .
	@echo ". TX  <=> RX  Short"
	@echo ". CTS <=> RTS Short"
	@echo ". DTR <=> DSR Short"
	@echo .
	@echo . Configure this setup and Press Enter to continue
	@echo .
	read
	@echo .

# Trick to Do a combined Coverage file
test-cover-html:
	echo "mode: count" > coverage-all.out
	$(foreach pkg,$(PACKAGES),\
		go test -coverprofile=coverage.out -covermode=count $(pkg);\
		tail -n +2 coverage.out >> coverage-all.out;)
	go tool cover -html=coverage-all.out


.PHONY: test cover-count-start cover cover-count cover-all test-cover-html
