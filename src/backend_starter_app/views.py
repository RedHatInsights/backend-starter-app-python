from django.http import HttpResponse

def healthz(req):
    return HttpResponse('All good here')


def readyz(req):
    return HttpResponse('OK')


def livez(req):
    return HttpResponse('OK')
