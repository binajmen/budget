### Setup

> I didn't figure out how to use the .env file differently with `squirrel` and `cigogne`, yet.

Rename `.env.example` to `.env`, and export the env variables
```sh
cp .env.example .env
export $(cat .env | sed 's/#.*//g' | xargs)
```

Run the project:
```sh
docker compose up -d
gleam run -m cigogne last
gleam run -m squirrel
gleam run
```
