FROM python:3.13.3-alpine3.20 AS builder

ADD . /work
WORKDIR /work

RUN set -eux \
  && apk update \
  && apk add musl-dev gcc \
  && pip install virtualenv \
  && virtualenv /opt/virtualenv \
  && /opt/virtualenv/bin/pip install .

FROM python:3.13.3-alpine3.20

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

RUN set -eux \
    && apk --no-cache upgrade

COPY --from=builder /opt/virtualenv /opt/virtualenv

EXPOSE 9105

ENTRYPOINT [ "/opt/virtualenv/bin/python", "/opt/virtualenv/bin/dump1090exporter" ]
CMD ["-h"]
