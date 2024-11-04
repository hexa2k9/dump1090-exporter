FROM python:3.12-alpine3.20 AS builder

ADD . /work
WORKDIR /work

RUN set -eux \
  && apk update \
  && apk add musl-dev gcc \
  && pip install virtualenv \
  && virtualenv /opt/virtualenv \
  && /opt/virtualenv/bin/pip install -e . \
  && /opt/virtualenv/bin/python setup.py bdist_wheel \
  && /opt/virtualenv/bin/pip install dist/*.whl

#  && /opt/virtualenv/bin/pip install -r requirements.txt \

FROM python:3.12-alpine3.20

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

COPY --from=builder /opt/virtualenv /opt/virtualenv

EXPOSE 9105

ENTRYPOINT [ "/opt/virtualenv/bin/dump1090exporter" ]
CMD ["-h"]
