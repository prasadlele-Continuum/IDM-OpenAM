# AutomationEngine
This is created for Automation Engine Performance Testing

loadtest.sh

read -p "Please Enter report file Name : " ReportfileName
read -p "Please Enter number of Users : " Users
Rampup=$Users
read -p "Please Enter number of Iteration/loop count : " loopcount
read -p "Please Enter URL : " URL

read -p "You want to continue [Y/N] : " yesno
ThinkTime=500

if [ $yesno == Y ]
then
        echo "Starting the run"
        dttime=`date +%d%b%Y_%H%M`
        projectpath=/root/PT/projects/AutomationEngine
        ThinkTime=500
        filename="$ReportfileName"_"$dttime".jtl

        JVM_ARGS="-Xms4G -Xmx4G -XX:NewSize=512m -XX:MaxNewSize=1024m -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -Xloggc:$projectpath/logs/GC_${dttime}.log"  && export JVM_ARGS && sh /root/PT/tools/apache-jmeter-5.1.1/bin/jmeter -Jusers=$Users -Jrampup=$Rampup -Jloopcount=$loopcount -JThinkTime=$ThinkTime -JHOST=$URL -Jdirpath=$projectpath -n -t $projectpath/Automation_Engine.jmx -l $projectpath/results/$filename

else
        echo "Execution is skipped :) .. Bye Bye"
fi


sanitytest.csv

read -p "Please Enter report file Name : " ReportfileName
Users=10
Rampup=$Users
loopcount=10
URL=internal-alerting-int-clb-1550876602.us-east-1.elb.amazonaws.com
dttime=`date +%d%b%Y_%H%M`
projectpath=/root/PT/projects/AutomationEngine
ThinkTime=500
filename="$ReportfileName"_"$dttime".jtl

 JVM_ARGS="-Xms4G -Xmx4G -XX:NewSize=512m -XX:MaxNewSize=1024m"  && export JVM_ARGS && sh /root/PT/tools/apache-jmeter-5.1.1/bin/jmeter -Jusers=$Users -Jrampup=$Rampup -Jloopcount=$loopcount -JThinkTime=$ThinkTime -JHOST=$URL -Jdirpath=$projectpath -n -t $projectpath/Automation_Engine.jmx -l /root/PT/projects/results/AutomationEngine/$filename
