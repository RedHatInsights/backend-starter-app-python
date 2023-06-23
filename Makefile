TEMPDIR_INFOSECTOOLS = /tmp/infosec-dev-tools
VENV=.venv

run: venv_check
	python manage.py runserver

install_pre_commit: venv_check
	# Remove any outdated tools
	rm -rf $(TEMPDIR_INFOSECTOOLS)
	# Clone up-to-date tools
	git clone https://gitlab.corp.redhat.com/infosec-public/developer-workbench/tools.git /tmp/infosec-dev-tools

	# Cleanup installed old tools
	$(TEMPDIR_INFOSECTOOLS)/scripts/uninstall-legacy-tools

	# install pre-commit and configure it on our repo
	make -C $(TEMPDIR_INFOSECTOOLS)/rh-pre-commit install
	python -m rh_pre_commit.multi configure --configure-git-template --force
	python -m rh_pre_commit.multi install --force --path ./

	rm -rf $(TEMPDIR_INFOSECTOOLS)

venv_check:
ifndef VIRTUAL_ENV
	$(error Not in a virtual environment)
endif

venv_create:
ifndef VIRTUAL_ENV
	python -m venv $(VENV)
	@echo "Virtual environment $(VENV) created, activate running: source $(VENV)/bin/activate"
else
	$(warning VIRTUAL_ENV variable present, already within a virtual environment?)
endif

install: venv_check
	pip install -e .

clean:
	rm -rf __pycache__
	find . -name "*.pyc" -exec rm -f {} \;
