# backend-starter-app-python
The purpose of this is to provide a fully functional implementation of simple applications that are fully integrated with the console.redhat.com platform, to serve as an example for new teams onboarding into the platform to create their own applications.

## Installing Django
To install Django you need to have python and pip installed on your machine. We recommend python 3.10, but any version 3.6+ will work too. Once you have those all you will want to create and activate a virtual environment for the app and install Django.
```bash
# Create the virtual environment
$ python -m venv path/to/venv
# Activate the virtual environment
$ source path/to/venv/bin/activate
# Install Django
$ python -m pip install Django
```
After all that, your development environment will be ready to go.

## Running the Django Server
Starting the Django server is as easy as running:
```bash
# Navigate to the root of the Django app.
# The same directory that manage.py lives.
$ cd backend_starter_app
$ python manage.py runserver
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

Navigate to that address, or control click the link in the console, and you should see that Django was installed correctly.

## Installing rh-pre-commit
We've added a script to install the [rh-pre-commit](https://gitlab.corp.redhat.com/infosec-public/developer-workbench/tools/-/tree/main/rh-pre-commit) to this repo. This will prevent you from accidentally committing credentials, tokens, or other secrets to your repo. To install the pre-commit run:
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
