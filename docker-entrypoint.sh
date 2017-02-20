#!/usr/bin/env bash
set -eo pipefail

case $1 in
  web)
    # first migrate the database
    while ! umap migrate 2>&1; do
        sleep 5
    done
    # then collect static files
    umap collectstatic --noinput
    # create languagae files
    umap storagei18n
    # compress static files
    umap compress
    # run uWSGI
    exec uwsgi --ini uwsgi.ini
    ;;
  *)
    exec "$@"
    ;;
esac
