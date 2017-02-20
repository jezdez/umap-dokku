#!/usr/bin/env bash
set -eo pipefail

function wait_for_database {(
  for try in {1..60} ; do
    python -c "from django.db import connection; connection.connect()" >/dev/null 2>&1
    [[ $? -eq 0 ]] && return
    echo "Waiting for database to respond..."
    sleep 1
  done
)}

# first wait for the database
wait_for_database
# then migrate the database
umap migrate
# then collect static files
umap collectstatic --noinput
# create languagae files
umap storagei18n
# compress static files
umap compress
# run uWSGI
exec uwsgi --ini uwsgi.ini
