# backend-starter-app-python
The purpose of this is to provide a fully functional implementation of simple applications that are fully integrated with the console.redhat.com platform, to serve as an example for new teams onboarding into the platform to create their own applications.

## Prerequisites

This project uses Python 3 and Django REST Framework to run. We recommend python 3.10, but any version 3.6+ will work too. Once you have those all you will want to create and activate a virtual environment for the app and install Django. The project uses a Makefile to simplify getting started.

## Makefile recipes

This project makes use of [Makefile](https://www.gnu.org/software/make/). There are several recipes included to ease the task of installing and running the pplication.

**NOTE**: Most of the Makefile recipes enforces the use of [virtual environments](https://docs.python.org/3/library/venv.html), and by default they will
check if there is a virtual environemnt activated, refusing to run otherwise.

### Running the project

In order to be able to run the application locally the first time, after cloning the repository you'll probably have to:

1. Create and activate a Python virtual environment
2. Install the project dependencies
3. Run the Django server

You can achieve the first one either manually or by running the `venv_create` recipe:

```shell
make venv_create && source .venv/bin/activate
```

which will create a virtual environment in the local directory with the `.venv` name

Then simply:

```shell
make install run
```
After running that command you should see this output:

```
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).
June 14, 2023 - 12:34:18
Django version 4.2.2, using settings 'backend_starter_app.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.
```

Navigate to http://127.0.0.1:8080 to access to the Django application's web console.

### Running tests

Tests are run using the `test` recipe:

```
make test
```

This would run the tests using the default configured test runner using Django `test` command from `manage.py` script.

### Generating code coverage

In case you want to generate an HTML report of your code coverage, you can do so by using the `coverage` recipe

```
make coverage
```

This will:
- Install the development depenencies (to install [coverage.py])
- Run the tests
- Generate a report (by default, the report format will be HTML).

you can override the report format to either XML, JSON or HTML format using the `COVERAGE_REPORT_FORMAT` variable:

```
make COVERAGE_REPORT_FORMAT=json coverage
```

To check the available supported coverage formats, check [Coverage.py docs](https://coverage.readthedocs.io/en/7.2.7/#capabilities)

### Installing rh-pre-commit
We've added a recipe to install the [rh-pre-commit](https://gitlab.corp.redhat.com/infosec-public/developer-workbench/tools/-/tree/main/rh-pre-commit) to this repo. This will prevent you from accidentally committing credentials, tokens, or other secrets to your repo. To install the pre-commit run:
```bash
$ make install_pre_commit
```
Follow the prompt to receive a token and complete the install.

Once complete you can test the precommit by running in the repo:
```bash
# Note: before testing remove the gitleaks:allow comment.
# It is there to prevent false positives when committing changes to the README
echo 'secret="EdnBsJW59yS6bGxhXa5+KkgCr1HKFv5g"' > secret # gitleaks:allow
git add secret
git commit
```

### Installing the rest of the pre-commits
We are using the python package [pre-commit](https://pre-commit.com/) to handle the setup and maintenance pre-commit hooks. We have pre-configured a few commit hooks but we encourage modifying the `.pre-commit-config.yaml` to fit your project as needed. If you don't already have a virtual environment setup, you can use the following commands to do that.
```bash
# Create the virtual environment
$ make venv_create
# Activate the virtual environment
$ source .venv/bin/activate
```
Once you have sourced your virtual environment you can install the pre-commit package and the hooks themselves with the following commands:
```bash
# Install pre-commit hooks by installing the project's dependencies and development dependencies
$ make install_dev
```
Note: none of the hooks we provide are required but are just our recommendations.
