#!/bin/sh
#export PGPASSWORD=grafana
#PGPASSWORD=grafana psql -U grafana demo
constring="psql --host=127.0.0.1 --port=5432 --dbname=demo --username=grafana"
# PGPASSWORD=grafana psql --host=127.0.0.1 --port=5432 --dbname=demo --username=grafana  << EOF
$constring << EOF

select * from demotable
EOF
