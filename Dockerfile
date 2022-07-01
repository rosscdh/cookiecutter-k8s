FROM python:3.9.7-slim as builder

RUN apt-get update; apt-get install git gcc -y
RUN pip install pip virtualenv -U
WORKDIR /
RUN virtualenv venv -p $(which python)
COPY ./requirements.txt .
RUN ./venv/bin/pip install -r requirements.txt

FROM nikolaik/python-nodejs:python3.9-nodejs15-slim as npm-builder
WORKDIR /src
COPY ./src/package.json /src/package.json
RUN npm i package.json

FROM python:3.9.7-slim
WORKDIR /src
COPY --from=builder /venv /venv
COPY --from=npm-builder /src/node_modules /var/www/assets/dev.node_modules
COPY ./src /src
COPY ./.env.build /src/.env.build

RUN groupadd -r django && useradd -r -g django django
RUN mkdir -p /static /media;chown -R django:django /media;chown -R django:django /static;chown -R django:django /var/www/assets
RUN /venv/bin/dotenv -f .env.build run -- /venv/bin/python manage.py collectstatic --no-input

USER django
ENTRYPOINT ["/venv/bin/gunicorn"]
CMD ["mos.asgi:application", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8000"]
