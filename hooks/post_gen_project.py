import subprocess
from datetime import datetime

git_init = "{{cookiecutter.initialize_git}}"
git_init = git_init.lower()
git_init = git_init[0]


if git_init == "y":
    today = datetime.today()
    args = [
        ["git", "init"],
        ["git", "add", "."],
        ["git", "commit", "-m", "Initial Commit"],
    ]
    for arg_list in args:
        proc = subprocess.Popen(arg_list, stdout=subprocess.PIPE)
        proc.wait()
        assert proc.returncode == 0

elif git_init == "n":
    print(
        "Warning: Before this application can be deployed you are required to"
        "initialize a git repo and add/commit changes to it.",
    )
else:
    print("Invalid option deleting project")
    raise Exception("Invalid option given")
