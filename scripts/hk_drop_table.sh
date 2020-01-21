echo "-------------------------------------"
echo " deleting the Tables older than 5 hrs"
echo "-------------------------------------"

constring="psql -h localhost -p 5432 -t -U grafana -d demo"
#PGPASSWORD=grafana psql -h localhost -p 5432 -t -U grafana -d demo -c "select table_name from (WITH CTE AS
$constring -c "select table_name from (WITH CTE AS
(
    SELECT 
        table_name,
		(SELECT pg_relation_filepath(table_name)) path

    FROM information_schema.tables
    WHERE table_type = 'BASE TABLE'
    AND table_schema = 'public'
	and table_name ilike 'jenki%'
)

SELECT 
    table_name 
    ,(
        SELECT access 
        FROM pg_stat_file(path)
    ) as creation_time
FROM CTE) as temp
where creation_time <  NOW() - INTERVAL '4 hour'; 
" | while read  table_name 
 do
	if test -n "$table_name"
	then
	#	PGPASSWORD=grafana psql -h localhost -p 5432 -t -U grafana -d demo -c "DROP table $table_name;"
		$constring -c "DROP table $table_name;"
		echo "Table Deleted " $table_name
	fi
done

echo "-------------------------------------"
echo " Archieving the logs to backup folder"
echo "-------------------------------------"

find /home/engguser/PT/projects/IDM/results/ -maxdepth 1 -type f -name "Jenk*" -mtime +1 -exec mv {} /home/engguser/PT/projects/IDM/results/backup/ \;

echo "-------------------------------------"
echo " Archieving Done"
echo "-------------------------------------"

