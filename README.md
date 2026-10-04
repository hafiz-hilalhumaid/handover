\## Run it locally



Requirements: Docker Desktop and Node.js 18 or newer.



```

docker compose up -d

cd db

npm install

npm run migrate

cd ..

docker compose exec -T db psql -U handover -d handover < db\\seeds\\dev\_sample\_data.sql

```



Database changes live in `db/migrations` as numbered SQL files. Each one runs once, in order, and is recorded in the `schema\_migrations` table. A migration that has run is never edited; changes go in a new file.

