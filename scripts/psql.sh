result ='PGPASSWORD=grafana psql -t -X -A  --host=127.0.0.1  --port=5432 --dbname=demo --username=grafana -c "select * from perf_poc;"'
echo " my result is " ${result[0]}
