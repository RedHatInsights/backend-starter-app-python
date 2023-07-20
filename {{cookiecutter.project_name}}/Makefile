TEMPDIR_INFOSECTOOLS = /tmp/infosec-dev-tools
VENV=.venv
COVERAGE_REPORT_FORMAT = 'html'
IMAGE=quay.io/${USER}/{{cookiecutter.project_name}}
IMAGE_TAG=latest
DOCKERFILE=Dockerfile
CONTAINER_WEBPORT=8000
HOST_WEBPORT=${CONTAINER_WEBPORT}
CONTEXT=.
CONTAINER_ENGINE=podman
BONFIRE_CONFIG=".bonfirecfg.yaml"
CLOWDAPP_TEMPLATE=clowdapp.yaml
CLOWDAPP_NAME={{cookiecutter.project_name | replace("_", "-")}}
NAMESPACE=''
PYTHON_CMD=python3

run: venv_check
	${PYTHON_CMD} manage.py runserver

install_pre_commit: venv_check
	# Remove any outdated tools
	rm -rf $(TEMPDIR_INFOSECTOOLS)
	# Clone up-to-date tools
	git clone https://gitlab.corp.redhat.com/infosec-public/developer-workbench/tools.git /tmp/infosec-dev-tools

	# Cleanup installed old tools
	$(TEMPDIR_INFOSECTOOLS)/scripts/uninstall-legacy-tools

	# install pre-commit and configure it on our repo
	make -C $(TEMPDIR_INFOSECTOOLS)/rh-pre-commit install
	${PYTHON_CMD} -m rh_pre_commit.multi configure --configure-git-template --force
	${PYTHON_CMD} -m rh_pre_commit.multi install --force --path ./

	rm -rf $(TEMPDIR_INFOSECTOOLS)

venv_check:
ifndef VIRTUAL_ENV
	$(error Not in a virtual environment)
endif

venv_create:
ifndef VIRTUAL_ENV
	${PYTHON_CMD} -m venv $(VENV)
	@echo "Virtual environment $(VENV) created, activate running: source $(VENV)/bin/activate"
else
	$(warning VIRTUAL_ENV variable present, already within a virtual environment?)
endif

install: venv_check
	${PYTHON_CMD} -m pip install -e .

install_dev: venv_check
	${PYTHON_CMD} -m pip install -e .[dev]

install_ci: venv_check
	${PYTHON_CMD} -m pip install cookiecutter

clean:
	rm -rf __pycache__
	find . -name "*.pyc" -exec rm -f {} \;

test: venv_check install_dev
	${PYTHON_CMD} manage.py test

smoke-test: venv_check install_dev
	@echo "Running smoke tests"

coverage: venv_check install_dev
	coverage run --source="." manage.py test
	coverage $(COVERAGE_REPORT_FORMAT)

coverage-ci: COVERAGE_REPORT_FORMAT=xml
coverage-ci: coverage

build-image:
	${CONTAINER_ENGINE} build -t ${IMAGE} -f ${DOCKERFILE} ${CONTEXT}

run-container:
	${CONTAINER_ENGINE} run -it --rm -p ${HOST_WEBPORT}:${CONTAINER_WEBPORT} ${IMAGE} runserver 0.0.0.0:8000

build-image-docker: CONTAINER_ENGINE=docker
build-image-docker: build-image

run-container-docker: CONTAINER_ENGINE=docker
run-container-docker: run-container

push-image:
	${CONTAINER_ENGINE} push ${IMAGE}

push-image-docker: CONTAINER_ENGINE=docker
push-image-docker: push-image

bonfire_process:
	@bonfire process -c $(BONFIRE_CONFIG) $(CLOWDAPP_NAME) \
		-p service/IMAGE=$(IMAGE) -p service/IMAGE_TAG=$(IMAGE_TAG) -n $(NAMESPACE)

bonfire_reserve_namespace:
	bonfire namespace reserve

bonfire_user_namespaces:
	bonfire namespace list --mine

bonfire_deploy:
	bonfire deploy -c $(BONFIRE_CONFIG) $(CLOWDAPP_NAME) \
		-p service/IMAGE=$(IMAGE) -p service/IMAGE_TAG=$(IMAGE_TAG) -n $(NAMESPACE)
