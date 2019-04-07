include config.mk

JAVA_VERSION ?= 1.8
JMETER_VERSION := 3.3
DOCKER_IMAGE := marcelocorreia/jmeter
JMETER_DIR := ./apache-jmeter-$(JMETER_VERSION)
JMETER_CUSTOM_DOWNLOAD_URL := https://s3-ap-southeast-2.amazonaws.com/correia-artifacts/packages/custom-jmeter-$(JMETER_VERSION).tar.gz
OUTPUT_DIR=log
TIMESTAMP := $(shell date '+%Y-%m-%d-%H_%M_%S')
JMETER_BIN ?= $(JMETER_DIR)/bin/jmeter

run: _set-java-version
	$(call jmeter_run,$(TEST_FILE),\
    		-Jusers=$(USERS) \
    		-Jramp_up=$(RAMP_UP) \
    		-Jprotocol=$(PROTOCOL) \
    		-Jaddress=$(ADDRESS) \
    		-Jport=$(PORT) \
    		-Jloop=$(LOOP_COUNT))
.PHONY: run

_set-java-version:
	$(eval export JAVA_HOME=$(shell /usr/libexec/java_home -v $(JAVA_VERSION))

docker_build:
	docker build -t $(DOCKER_IMAGE) ./docker/
	docker build -t $(DOCKER_IMAGE):3.3 ./docker/

jmeter-ui:
	$(eval export JAVA_HOME=$(shell /usr/libexec/java_home -v $(JAVA_VERSION)))
	./$(JMETER_DIR)/bin/jmeter.sh

jmeter-postgres-up:
	docker-compose up -d

jmeter-postgres-down:
	docker-compose kill
	docker-compose down

jmeter-postgres-logs:
	docker-compose logs -f

jmeter-setup:
	@echo "Checking for $(JMETER_DIR)"
	if [ -d $(JMETER_DIR) ];then \
		echo "Jmeter seems to be already setup, please check your config";\
		exit 0;\
	fi
	curl $(JMETER_CUSTOM_DOWNLOAD_URL) -o jmeter.tar.gz
	tar -xvzf jmeter.tar.gz
	rm jmeter.tar.gz

jmeter-docker:
	$(call jmeter_docker,$(TEST_FILE),\
		-Jusers=$(USERS) \
        -Jramp_up=$(RAMP_UP) \
        -Jprotocol=$(PROTOCOL) \
        -Jaddress=$(ADDRESS) \
        -Jport=$(PORT))

define jmeter_docker
	docker run --rm \
		-v tests:/opt/tests \
		-v log:/opt/log \
		-v $(shell pwd):/app \
		-w /app \
		$(DOCKER_IMAGE) \
		/opt/jmeter/bin/jmeter.sh -n -t $1 \
    	-l $(OUTPUT_DIR)/results_$(TIMESTAMP) \
        -e \
        -o $(OUTPUT_DIR)/$(TIMESTAMP) \
        $2
endef

define jmeter_run
	@[ -f $(OUTPUT_DIR) ] && echo OUTPUT_DIR folder found, skipping creation || mkdir -p $(OUTPUT_DIR)
	$(JMETER_BIN) -n -t $1 \
		-l $(OUTPUT_DIR)/results_$(TIMESTAMP)-$(USERS)x$(LOOP_COUNT)x$(RAMP_UP) \
		-e \
		-o $(OUTPUT_DIR)/$(TIMESTAMP)-$(USERS)x$(LOOP_COUNT)x$(RAMP_UP) \
		$2
endef


_git-ci:
	@echo Commit Message:
	-@git add .
	-@read n && \
	git commit -m "$$n"
	-@git push