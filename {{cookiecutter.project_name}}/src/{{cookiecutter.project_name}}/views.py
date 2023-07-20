from django.http import JsonResponse, HttpResponse


def healthz(req):
    health_data = {
        "app_name": "{{cookiecutter.project_name}}",
        "status": "running",
    }

    return JsonResponse(health_data)


def readyz(req):
    return HttpResponse('OK')


def livez(req):
    return HttpResponse('OK')
