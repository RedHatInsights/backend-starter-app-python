from django.http import HttpResponse

def healthz(req):
    return HttpResponse('All good here')
