install_pre_commit:
	# Remove any outdated tools
	rm -rf /tmp/infosec-dev-tools
	# Clone up-to-date tools
	git clone https://gitlab.corp.redhat.com/infosec-public/developer-workbench/tools.git /tmp/infosec-dev-tools

	# Cleanup installed old tools
	/tmp/infosec-dev-tools/scripts/uninstall-legacy-tools

	# install pre-commit and configure it on our repo
	make -C /tmp/infosec-dev-tools/rh-pre-commit install
	python3 -m rh_pre_commit.multi configure --configure-git-template --force
	python3 -m rh_pre_commit.multi install --force --path ./