FROM registry.access.redhat.com/ubi8/python-311:1-8.1687187517 AS builder

COPY --chown=1001:0 . /app-src
RUN pip install --no-cache-dir /app-src

FROM registry.access.redhat.com/ubi8/ubi-minimal:8.8-860

ENV VIRTUAL_ENV='/opt/app-root'
ENV APP_SRC='/app-src'

RUN microdnf install -y "python3.11-3.11.2-2.el8_8.1.x86_64" \
    && microdnf clean all

RUN mkdir $APP_SRC && chown 1001:0 $APP_SRC

USER 1001

COPY --from=builder  /opt/app-root $VIRTUAL_ENV
COPY --from=builder  /app-src $APP_SRC

ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR /app-src

ENTRYPOINT ["python", "manage.py"]
CMD ["runserver", "0.0.0.0:8000"]
