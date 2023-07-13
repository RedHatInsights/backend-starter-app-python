# backend-starter-app-python
The purpose of this is to provide a fully functional implementation of simple applications that are fully integrated with the console.redhat.com platform, to serve as an example for new teams onboarding into the platform to create their own applications.

## Prerequisites

This project uses Python 3 and Django REST Framework to run. We recommend python 3.10, but any version 3.6+ will work too. Once you have those all you will want to create and activate a virtual environment for the app and install Django. The project uses a Makefile to simplify getting started.

This project makes use of [Makefile](https://www.gnu.org/software/make/). There are several recipes included to ease the task of installing and running the application.

**Optional for deploying to ephemeral environments:** There are recipes provided to deploy the application using [bonfire](https://pypi.org/project/crc-bonfire)
so make sure the command is available in your PATH to run the deployment commands.

## Getting started

### Creating your project

The starter app is configured as a template. Because of this you can't clone the repo directly, you will need to create your own repo first using [cookiecutter](https://cookiecutter.readthedocs.io/en/stable/index.html):

1. Install cookiecutter
2. Generate your project

To install cookiecutter you can run:
```shell
python3 -m pip install --user cookiecutter
```

Once installed, you can generate your new project. This will create a new directory and initialize a git repo by default:
```shell
cookiecutter https://github.com/RedHatInsights/backend-starter-app-python.git
```

After that you will see your new repo in a directory with the same name as your project. `cd` to it and you will be ready run, test, build, and deploy your new project.

## Makefile recipes

**NOTE**: Most of the Makefile recipes enforce the use of [virtual environments](https://docs.python.org/3/library/venv.html), and by default they will
check if there is a virtual environemnt activated, refusing to run otherwise.

### Running the project

In order to be able to run the application locally the first time, after generating the repository you'll probably have to:

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

### Deploying to an ephemeral namespace

#### Pre-requisites

This part requires the user to be onboarded into Ephemeral namespaces. If you're not, please make sure
you follow [this guide](https://consoledot.pages.redhat.com/docs/dev/creating-a-new-app/using-ee/getting-started-with-ees.html)
Once onboarded, the user should be able to log into the Ephemeral cluster to reserve a namespace

#### Reserve a namespace

Reserve a target namespace in the Ephemeral namespace and save it for later:

```
make bonfire_reserve_namespace
bonfire namespace reserve
2023-07-02 21:08:56 [    INFO] [          MainThread] Checking for existing reservations for 'Victoremepunto'
2023-07-02 21:08:56 [    INFO] [          MainThread] checking for available namespaces to reserve...
2023-07-02 21:08:57 [    INFO] [          MainThread] pool size limit is defined as 0 in 'default' pool
2023-07-02 21:08:57 [    INFO] [          MainThread] processing namespace reservation
2023-07-02 21:08:57 [    INFO] [          MainThread] running (pid 1771071): oc apply -f -
2023-07-02 21:08:58 [    INFO] [         pid-1771071]  |stdout| namespacereservation.cloud.redhat.com/bonfire-reservation-12538be0 created
2023-07-02 21:08:58 [    INFO] [          MainThread] waiting for reservation 'bonfire-reservation-12538be0' to get picked up by operator
2023-07-02 21:08:58 [    INFO] [          MainThread] namespace 'ephemeral-cv17hi' is reserved by 'Victoremepunto' for '1h' from the default pool
2023-07-02 21:08:58 [    INFO] [          MainThread] running (pid 1771118): oc project ephemeral-cv17hi
2023-07-02 21:08:59 [    INFO] [         pid-1771118]  |stdout| Now using project "ephemeral-cv17hi" on server "https://api.c-rh-c-eph.8p0c.p1.openshiftapps.com:6443".
2023-07-02 21:08:59 [    INFO] [          MainThread] namespace console url: https://console-openshift-console.apps.c-rh-c-eph.8p0c.p1.openshiftapps.com/k8s/cluster/projects/ephemeral-cv17hi
ephemeral-cv17hi
```

#### Building and pushing the backend starter application image

In order to deploy the backend starter app to an Ephemeral namespace, the user requires to push an image to
an external registry accesible from the Ephemeral cluster.

Make sure you're logged in against Quay using the `login` command of either `podman` or `docker` with write
permissions against the target image repository.

```
podman login quay.io
```

The included Makefile has recipes to create and push an image to the user's personal organization in Quay.io

To build and push with `podman` the application's image simply run:

```
make build-image push-image
```

_there are similar recipes for `Docker` named `build-image-docker` and `push-image-docker`, respectively._

Once pushed, the image needs to be pulled by the Clowder operator. If the repository is `public` there should be no
further requirements, and you can simply skip the next section straight into "Deploy your application".

For the sake of simplicity of the example, we encourage you to use a public repository.

#### **OPTIONAL: ONLY FOR PRIVATE REPOSITORIES** Creating and adding a pull secret to the namespace for private registries in Quay.io.

Once the image is pushed to the user's org In Quay, you should create a pull secret and add it to the ClowderEnvironment's list of `PullSecrets`

To generate the secret:

- Head to Quay.io, log into your account, and click on your user's org.
- Click on the left side on "Robot accounts" and create a new robot account
- Provide a name for your robot account.
- Select the `backend-starter-app-python` repository, you should only require `read` permissions.
- Click on the recently created robot account, and select "Kubernetes secret".
- Click on the link to download the secret in YAML format under "Step 1: Download secret" section.

This secret must be added to the list of `PullSecrets` of the `ClowdEnvironment` of the target namespace in order
to be able to pull the application image from the private registry

You need to create this secret in the target namespace and configure it in the ClowdEnvironment. To do so:

- Create the secret in the target namespace using the YAML file you downloaded from Quay.io

```
oc create -f /path/to/your/secret.yaml -n "your-ephemeral-namespace"
secret/vmugicag-somesecretname-pull-secret created
```

Your secret's name is required, you can check it inside the YAML that contains the definition. It's probably in the format
"your user id"-"secret name"-pull-secret

You will require this name later to refer to the secret on the ClowdEnvironment

- Edit the ClowdEnvironment and add the PullSecret to the list:

```
oc get ClowdEnvironment -o name | grep "your-ephemeral-namespace" | xargs oc edit
```

This should open your system's default editor with the YAML definition of the ClowdEnvironment.
You should locate and add the secret to the PullSecrets list:

```YAML
     pullSecrets:
     # other secrets may be listed here ...
     - name: backend-starter-app-python    # <-- Add your secret's name
       namespace: your-target-namespace    # <-- Add the ephemeral namespace name here
```

#### Deploy your application

use the `bonfire_deploy` recipe to deploy your application into an ephemeral namespace.
use the NAMESPACE variable to pass the name of the target namespace

```
# make NAMESPACE=your-ephemeral-namespace bonfire_deploy
```

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
