help: ## Show available targets and their descriptions
	@echo "\n\033[33mHelper Makefile for the untiree ROS 2 sim setup.\033[0m"
	@echo "\nUsage:\n\tmake [target]"
	@echo "\nAvailable [target]s:"
	@grep -E '^[a-zA-Z_-]+:.*?## ' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

justdo: brun bash

brun: build run

build: ## Build the Docker image for the unitree_ros2_sim
	COMPOSE_BAKE=true docker compose build

run: ## Run a container from the unitree_ros2_sim Docker image
	docker compose up -d
	
bash: ## Open a bash shell inside the running unitree_ros2_sim container
	docker exec -it unitree_sim /bin/bash

CACHE_DIR := ../ros2_cache
setup_cache: ## Setup ROS 2 build cache inside the running container
	@echo "\n\033[36mCreating ROS 2 build cache...\033[0m"
	mkdir -p $(CACHE_DIR)/build \
	         $(CACHE_DIR)/install \
	         $(CACHE_DIR)/log
	@echo "\n\033[32mROS 2 build cache directories created at '$(CACHE_DIR)'.\033[0m"

.DEFAULT: ## handle unknown targets
	@echo "\n\033[31mError: Unknown target: $@. Use 'make help' to see available targets.\033[0m"
	@exit 1
