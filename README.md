# uMap on Dokku

This is a recipe for running uMap on Dokku.

## App

Create a Dokku app

```shell
dokku apps:create umap
```

## Database

Create a Postgis enabled database using the [core Postgres plugin](https://github.com/dokku/dokku-postgres):

```shell
export POSTGRES_IMAGE=mdillon/postgis
export POSTGRES_IMAGE_VERSION=9.6
dokku postgres:create umap
dokku config:set --no-restart umap POSTGRES_DATABASE_SCHEME=postgis
dokku postgres:link umap umap
```

## Redis

Create a Redis server

```shell
dokku redis:create umap
dokku redis:link umap umap
```

## Storage

Create a storage folder so file uploads are kept between deploys.
Run on the Dokku host:

```shell
mkdir /var/lib/dokku/data/storage/umap
chown -R 32767:32767 /var/lib/dokku/data/storage/umap
dokku storage:mount umap /var/lib/dokku/data/storage/umap:/srv/umap/uploads
```

## Settings

You must set the following environment variables:

Required settings:

- `DATABASE_URL` -- Automatically set by the Postgres plugin

- `REDIS_URL` -- Automatically set by the Redis plugin

- `SECRET_KEY` -- a long randomg string, e.g. call `pwgen -Bsv1 64`

- `ALLOWED_HOSTS` -- a comma separated list of hostnames to allow serving

- `SITE_URL` -- the site URL to use for map links and referer when loading tiles

- `LEAFLET_STORAGE_ALLOW_ANONYMOUS` -- `True` or `False`, defaults to `False`

Optional settings:

- `DEBUG` -- Enables the Django debug mode, defaults to `False`

- `ADMIN_EMAIL` -- A comma separated list of emails to receive error emails

- `SHORT_SITE_URL` -- an optional short version of `SITE_URL` to be offered for linking to maps

- `GITHUB_KEY`, `GITHUB_SECRET` -- GitHub API key and secret for allow GitHub login

- `BITBUCKET_KEY`, `BITBUCKET_SECRET` -- Bitbucket API key and secret for allow Bitbucket login

- `TWITTER_KEY`, `TWITTER_SECRET` -- Twitter API key and secret for allow Twitter login

- `OPENSTREETMAP_KEY`, `OPENSTREETMAP_SECRET` -- OpenStreetMap API key and secret for allow OpenStreetMap login
