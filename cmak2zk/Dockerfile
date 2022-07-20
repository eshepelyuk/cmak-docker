FROM python:3.8-alpine3.13

COPY *.py /app/bin/

RUN set -x && pip install click~=7.0 kazoo~=2.8 ruamel.yaml~=0.16 jsonmerge~=1.8

ENTRYPOINT ["python3", "/app/bin/cmak2zk.py"]
CMD ["--help"]

WORKDIR /app/
