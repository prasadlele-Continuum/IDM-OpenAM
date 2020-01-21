built_no=$(PGPASSWORD=grafana psql -h localhost -p 5432 -t -U grafana -d demo -c "select max(build_no) from perf_poc;")
echo $built_no
baseline_resp=$(PGPASSWORD=grafana psql -h localhost -p 5432 -t -U grafana -d demo -c "select p90tile from perf_poc where  build_no = $built_no and api_name='Baseline';")
k='false'
PGPASSWORD=grafana psql -h localhost -p 5432 -t -U grafana -d demo -c "select api_name, p90tile , build_no from perf_poc where p90tile > $baseline_resp  and build_no = $built_no;
" | while read  result
 do
	if test -n "$result"
	then
		echo $result
		k='true'
	elif [[ "$k" == false ]]
	then
		echo "Response time is in acceptable limit"
	else
		echo "Response times are high So Built is failing"
		exit 1
	fi
done


