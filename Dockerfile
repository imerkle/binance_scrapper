# Elixir + Phoenix

FROM elixir:1.8-alpine

ENV LANG=C.UTF-8

# Install packages
RUN apk update && apk add --virtual build-dependencies wget git bash curl


# Install Phoenix packages
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

COPY . /app
WORKDIR /app

RUN mix deps.get

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.5.0/wait /wait
RUN chmod +x /wait

EXPOSE 4000