.PHONY: help build deploy clean list-packages uninstall

HELP_FUN = \
	%help; while(<>){push@{$$help{$$2//'options'}},[$$1,$$3] \
	if/^([\w-_]+)\s*:.*\#\#(?:@(\w+))?\s(.*)$$/}; \
	print"\033[1m$$_:\033[0m\n", map"  \033[36m$$_->[0]\033[0m".(" "x(20-length($$_->[0])))."$$_->[1]\n",\
	@{$$help{$$_}},"\n" for keys %help; \

help: ##@General Show this help
	@echo -e "Usage: make \033[36m<target>\033[0m\n"
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

build: ##@Build Build LPK package
	@echo "Building LPK package..."
	@lzc-cli project build
	@echo "LPK package built successfully!"

deploy: build ##@Deploy Build and install LPK package
	@echo "Installing LPK package..."
	@LPK_FILE=$$(ls -t *.lpk 2>/dev/null | head -n 1); \
	if [ -z "$$LPK_FILE" ]; then \
		echo "Error: No LPK file found"; \
		exit 1; \
	fi; \
	echo "Installing $$LPK_FILE..."; \
	lzc-cli app install "$$LPK_FILE"
	@echo "Installation completed!"

list-packages: ##@General List all LPK packages in current directory
	@echo "Available LPK packages:"
	@ls -lht *.lpk 2>/dev/null || echo "No LPK packages found"

uninstall: ##@Deploy Uninstall the LPK package
	@echo "Uninstalling cloud.lazycat.app.liu.calcom..."
	@lzc-cli app uninstall cloud.lazycat.app.liu.calcom
	@echo "Uninstallation completed!"

clean: ##@General Clean up LPK packages
	@echo "Removing LPK packages..."
	@rm -f *.lpk
	@echo "Cleaned!"

all: deploy ##@General Default target: build and deploy
