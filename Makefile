VENV=.venv

venv_check:
ifndef VIRTUAL_ENV
	$(error Not in a virtual environment)
endif

install: venv_check
	python -m pip install cookiecutter
	git config --global user.email "you@example.com"
	git config --global user.name "Your Name"
	cookiecutter . --no-input

venv_create:
ifndef VIRTUAL_ENV
	python -m venv $(VENV)
	@echo "Virtual environment $(VENV) created, activate running: source $(VENV)/bin/activate"
else
	$(warning VIRTUAL_ENV variable present, already within a virtual environment?)
endif
