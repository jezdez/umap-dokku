#!/usr/bin/env bash
set -eo pipefail

# first migrate the database
while ! exec umap migrate 2>&1; do
    sleep 5
done
# then collect static files
exec umap collectstatic --noinput
# create languagae files
exec umap storagei18n
# compress static files
exec umap compress
# run uWSGI
exec uwsgi --ini uwsgi.ini
