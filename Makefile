.PHONY: init build run stop clean

# 变量定义
DISCOVERY_DIR := discovery
GOIM_DIR := goim
DIST_DIR := dist
TARGET_DIR := target

update-ip:
	@echo "Updating IP addresses in JavaScript files..."
	@chmod +x scripts/update_ip.sh
	@./scripts/update_ip.sh

init:
	git submodule sync --recursive
	git submodule update --init --recursive --force
	docker-compose up -d
	@$(MAKE) update-ip

build:
	@echo "Building discovery..."
	@sed -i 's/cp cmd\/discovery\/discovery-example.toml $(DIST_DIR)\/conf\/discovery.toml/cp cmd\/discovery\/discovery.toml $(DIST_DIR)\/conf\/discovery.toml/' $(DISCOVERY_DIR)/Makefile
	@$(MAKE) -C $(DISCOVERY_DIR) build
	@echo "Building goim..."
	@$(MAKE) -C $(GOIM_DIR) build

run: run-discovery run-comet run-logic run-job

run-discovery:
	@echo "Starting discovery..."
	@nohup $(DISCOVERY_DIR)/$(DIST_DIR)/bin/discovery -conf $(DISCOVERY_DIR)/$(DIST_DIR)/conf/ > $(DISCOVERY_DIR)/$(DIST_DIR)/nohup.log 2>&1 &

run-comet:
	@echo "Starting comet..."
	@nohup $(GOIM_DIR)/$(TARGET_DIR)/comet -conf=$(GOIM_DIR)/$(TARGET_DIR)/comet.toml -region=sh -zone=sh001 -deploy.env=dev -weight=10 -addrs=127.0.0.1 -debug=true 2>&1 > $(GOIM_DIR)/$(TARGET_DIR)/comet.log &

run-logic:
	@echo "Starting logic..."
	@nohup $(GOIM_DIR)/$(TARGET_DIR)/logic -conf=$(GOIM_DIR)/$(TARGET_DIR)/logic.toml -region=sh -zone=sh001 -deploy.env=dev -weight=10 2>&1 > $(GOIM_DIR)/$(TARGET_DIR)/logic.log &

run-job:
	@echo "Starting job..."
	@nohup $(GOIM_DIR)/$(TARGET_DIR)/job -conf=$(GOIM_DIR)/$(TARGET_DIR)/job.toml -region=sh -zone=sh001 -deploy.env=dev 2>&1 > $(GOIM_DIR)/$(TARGET_DIR)/job.log &

run-example:
	@echo "Starting example..."
	@(cd goim/examples/javascript && nohup go run main.go &)

status:
	@pgrep -f "^discovery/dist/bin/discovery" > /dev/null && echo "Discovery is running" || echo "Discovery is not running"
	@pgrep -f "^goim/target/comet " > /dev/null && echo "Comet is running" || echo "Comet is not running"
	@pgrep -f "^goim/target/logic " > /dev/null && echo "Logic is running" || echo "Logic is not running"
	@pgrep -f "^goim/target/job " > /dev/null && echo "Job is running" || echo "Job is not running"

stop:
	@echo "Stopping all services..."
	@-pkill -f $(DISCOVERY_DIR)/$(DIST_DIR)/bin/discovery
	@-pkill -f $(GOIM_DIR)/$(TARGET_DIR)/logic
	@-pkill -f $(GOIM_DIR)/$(TARGET_DIR)/job
	@-pkill -f $(GOIM_DIR)/$(TARGET_DIR)/comet

clean:
	@echo "Cleaning up..."
	@$(MAKE) -C $(DISCOVERY_DIR) clean
	@$(MAKE) -C $(GOIM_DIR) clean
	docker-compose down -v