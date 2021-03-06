#read -p "Please Enter report file Prefix Name : " ReportfileName
#read -p "Please Enter number of Users : " Users
#read -p "Please Enter Rampup duration : " Rampup
ReportfileName=$1
Users=$2
Rampup=$3
loopcount=1
dttime=`date +%d%b%Y_%H%M%S`

projectpath=/home/engguser/PT/projects/IDM
ThinkTime=1000
filename="$ReportfileName"_"$dttime"
jmxfilename="OpenAM.jmx"
JMETER_HOME=/home/engguser/PT/tools/apache-jmeter
echo
echo " ------------------------- Run Setting -------------------"
echo "Report file :  " $filename
echo "No of users : " $Users
echo "Rampup duration : " $Rampup
echo "Think Time : " $ThinkTime
echo "----------------------------------------------------------"
echo

read -p "You want to continue [Y/N] : " yesno

#if [ $yesno == Y ]
#then
        echo "Starting the run"

        JVM_ARGS="-Xms4G -Xmx4G -XX:NewSize=1G -XX:MaxNewSize=1G -XX:+PrintGCDetails  -Xloggc:$projectpath/logs/GC/GC_${dttime}.log -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9005 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.remote.ssl=false -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$projectpath/logs/GC" && export JVM_ARGS &&  sh $JMETER_HOME/bin/jmeter -Jusers=$Users -Jrampup=$Rampup -Jloopcount=$loopcount -JThinkTime=$ThinkTime -Jdirpath=$projectpath -n -t $projectpath/$jmxfilename -l $projectpath/results/$filename.jtl
	
	echo 
	echo "----------------------------------------------------------"
	echo "Execution is finished .... Preparing the Report"
	echo "----------------------------------------------------------"
	echo 

        $JMETER_HOME/bin/JMeterPluginsCMD.sh --tool Reporter --generate-csv $projectpath/results/$filename.csv --input-jtl $projectpath/results/$filename.jtl --plugin-type AggregateReport

#else
        echo "Execution is skipped :) .. Bye Bye"
#fi

