ReportfileName=$1
Users=$2
Rampup=$3
loopcount=1
duration=$4
dttime=`date +%d%b%Y_%H%M%S`

projectpath=/home/engguser/PT/projects/IDM
ThinkTime=2000
filename="$ReportfileName"_"$dttime"
jmxfilename="OpenAM.jmx"
JMETER_HOME=/home/engguser/PT/tools/apache-jmeter
echo
echo " ------------------------- Run Setting -------------------"
echo "Report file :  " $filename
echo "No of users : " $Users
echo "Rampup duration in seconds: " $Rampup
echo "Think Time : " $ThinkTime
echo "Test Duration in seconds : " $duration
echo "----------------------------------------------------------"
echo

#yesno=Y

#if [ $yesno == Y ]
#then
        echo "Starting the run"

        JVM_ARGS="-Xms4G -Xmx4G -XX:NewSize=1G -XX:MaxNewSize=1G -XX:+PrintGCDetails  -Xloggc:$projectpath/logs/GC/GC_${dttime}.log -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9005 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.remote.ssl=false -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$projectpath/logs/GC" && export JVM_ARGS &&  sh $JMETER_HOME/bin/jmeter -Jusers=$Users -Jrampup=$Rampup -Jloopcount=$loopcount -Jduration=$duration -JThinkTime=$ThinkTime -Jdirpath=$projectpath -n -t $projectpath/$jmxfilename -l $projectpath/results/$filename.jtl
	
	echo 
	echo "----------------------------------------------------------"
	echo "Execution is finished .... Preparing the Report"
	echo "----------------------------------------------------------"
	echo 

        $JMETER_HOME/bin/JMeterPluginsCMD.sh --tool Reporter --generate-csv $projectpath/results/$filename.csv --input-jtl $projectpath/results/$filename.jtl --plugin-type AggregateReport
	
	echo "----------------------------------------------------------"
        echo "Extracted report to table ... removing % sign"
        echo "----------------------------------------------------------"

	sed -i 's/%//g'  $projectpath/results/$filename.csv
	sed -i '/TOTAL/d' $projectpath/results/$filename.csv
	echo "Baseline,,1000,1000,1000,1000,1000,1000,1000,0.00,,," >> $projectpath/results/$filename.csv	
 	echo "----------------------------------------------------------"
        echo "Adding TimeStamp"
        echo "----------------------------------------------------------"
	
	TIMESTAMP=$(date -u +"%F %T")
	ORIG_FILE=$projectpath/results/$filename.csv
	NEW_FILE=$projectpath/results/$filename"_1".csv
	mydate=$TIMESTAMP
	echo "$mydate"
	awk -v d="$mydate" -F"," 'BEGIN { OFS = "," } {$14=d; print}' $ORIG_FILE > $NEW_FILE
	rm -rf $ORIG_FILE
	echo "----------------------------------------------------------"
        echo "Added Time Column .... Inserting report into database and creating new table for raw report"
	echo " Deleted file " $ORIG_FILE
 	echo "----------------------------------------------------------"
	
	line=$(head -n 1 $projectpath/results/$filename.jtl)
	line1=$line
	line="$(echo $line | sed -e "s/\,/ text , /g") text"

	DATABASE=demo
	USERNAME=postgres
	HOSTNAME=127.0.0.1
	#export PGPASSWORD=grafana
 	PGPASSWORD=grafana psql --host=127.0.0.1 --port=5432 --dbname=demo --username=grafana  << EOF
	COPY perf_poc(api_name,samples,average,median,p70tile,p80tile,p90tile,min,max,error,throughput,received_kbsec,send_kbsec,datetime) FROM '$NEW_FILE' DELIMITER ',' CSV HEADER;
	create table $filename ($line);
	copy $filename ($line1) from '$projectpath/results/$filename.jtl' delimiter ',' csv header;
EOF

#else	
	echo "----------------------------------------------------------"
        echo "Uploaded data in DB.. Check now in Grafana"
	echo "Created Table is" $filename
        echo "----------------------------------------------------------"

#        echo "Uploaded data in DB.. Check now in Grafana"
#fi
