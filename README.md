# cookiecutter-backend-starter-app-python

Powered by [Cookiecutter](https://cookiecutter.readthedocs.io/en/stable/index.html), this template provides what's necessary to
jumpstart a new console.redhat.com platform application using [Django REST Framework](https://www.django-rest-framework.org), by
providing a minimal Django project that is fully integrated with the console.redhat.com platform, to serve as an example for new
teams onboarding into the platform to create their own applications.

## Prerequisites

The starter app is configured as a template. Because of this you can't clone the repo directly, you will need to create your project
using [cookiecutter](https://cookiecutter.readthedocs.io/en/stable/index.html) and the template provided by this project.

To install cookiecutter you can simply run:

```shell
python3 -m pip install --user cookiecutter
```

Once installed, you can generate your new project. You'll be asked the local project directory name and whether to initialize a git
repository or not.

```shell
$ cookiecutter gh:RedHatInsights/backend-starter-app-python
```

After that you'll see a new local directory has been created with the contents of a new project. We recommend you to move it to a new
location before starting to work on it. The project is fully functional, check the included README file for more information on what's
included.
