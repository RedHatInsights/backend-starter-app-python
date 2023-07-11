from django.http import JsonResponse


def healthz(req):
    health_data = {
        "app_name": "{{cookiecutter.project_name}}",
        "status": "running",
    }

    return JsonResponse(health_data)
