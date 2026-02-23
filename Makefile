CONFIG_FILE := ./.claude.json

ifeq ($(wildcard $(CONFIG_FILE)),)
    BUILD_CMD := docker run --rm claude-code-work cat /home/ubuntu/.claude.json > $(CONFIG_FILE) \
	&& echo "已提取配置"
else
    BUILD_CMD := echo "文件已存在: $(CONFIG_FILE)"
endif

.PHONY: build shell

build:
	docker-compose build
	@$(BUILD_CMD)

shell:
	docker-compose run --rm claude-code-work zsh
