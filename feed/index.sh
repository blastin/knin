#!/bin/bash
#oi.sh

echo Content-type: text/html
echo
echo "<html> <head> <title>Feed rtorrent</title> </head>"
echo "<body>"
echo "<h1><CENTER>KNIN-PROJECT</CENTER></h1><BR>"
echo "Feed : rtorrent (0.8.6)<BR><BR>"

SLOW_BOT_INIT=$(grep '^SLOW_BOT_INIT' conf/file_var.script | cut -d = -f 2)
SLOW_BOT_END=$(grep '^SLOW_BOT_END' conf/file_var.script | cut -d = -f 2)

TRACKER_TIME=$(grep '^TRACKER_TIME' conf/file_var.script | cut -d = -f 2)
TRACKER_UPDATE=$(grep '^TRACKER_UPDATE' conf/file_var.script | cut -d = -f 2)
COOKIE_TIME=$(grep '^COOKIE_TIME' conf/file_var.script | cut -d = -f 2)
COOKIE_UPDATE=$(grep '^COOKIE_UPDATE' conf/file_var.script | cut -d = -f 2)
SLEEP_UPDATE=$(grep '^SLEEP_TIME' conf/file_var.script | cut -d = -f 2)
TIME_UPDATE=$(grep '^TIME_UPDATE' conf/file_var.script | cut -d = -f 2)
LAST_BUILD=$(grep '^LAST_BUILD' conf/file_var.script | cut -d = -f 2)
BONUS_WHOLE=$(grep '^BONUS_WHOLE' conf/file_var.script | cut -d = -f 2)
SLEEP_FLAG=$(grep '^SLEEP_FLAG' conf/file_var.script | cut -d = -f 2)
LINE_database=$(seq $(grep '^TOR' conf/Database/database.db | wc -l))

VAR_FLAG="<font color=#FF0000>Next Update </font>"

if [ "$(date '+%H')" -gt "$SLOW_BOT_INIT" -a "$(date '+%H')" -ge  "$SLOW_BOT_END" ] 
then
	if test "$SLEEP_FLAG" = "OFF"
	then
		VAR_FLAG="<font color=#33CC66>Update</font>"
	else 
		VAR_FLAG="<font color=#FF0000>Next Update </font>"
	fi
else 
	VAR_FLAG="<font color=#FF0000>BOT SLOW</font>"
fi

echo '<TABLE BORDER="1" CELLSPACNG="0" CELLPADDING="5">'
	echo "<tr><td>INFO</td><td>Status</td><td>Time Update</td><td>Time Wait</td></tr>"
	if [ "$(date '+%H')" -ge "$SLOW_BOT_INIT" -a "$(date '+%H')" -lt  "$SLOW_BOT_END" ] 
		then
			echo "<tr><td>Feed</td><td>$VAR_FLAG</td><td><center>---</center></td><td><center>---</center></td></tr>"
	else
		if test "$SLEEP_FLAG" = "OFF"
		then
			echo "<tr><td>Feed</td><td>$VAR_FLAG</td><td><center>---</center></td><td><center>---</center></td></tr>"
		else
			echo "<tr><td>Feed</td><td>$VAR_FLAG</td><td><font color=#808080>$SLEEP_UPDATE</font><td>$TIME_UPDATE</td></tr>"
		fi
	fi
	#echo "<tr><td>Tracker</td><td>Status</td><td>Time Update</td><td>Time Wait</td></tr>"
	if [ "$(date '+%H')" -ge "$SLOW_BOT_INIT" -a "$(date '+%H')" -lt  "$SLOW_BOT_END" ] 
		then
		echo "<tr><td>Tracker</td><td><center>$VAR_FLAG</center></td><td><font color=#808080><center>---</center></font></td><td><center>---</center></td></tr>"
		echo "<tr><td>Cookie *</td><td><center>$VAR_FLAG</center></td><td><font color=#808080><center>---</center></font></td><td><center>---</center></td></tr>"
	else
		echo "<tr><td>Tracker</td><td><center>---</center></td><td><font color=#808080>$TRACKER_TIME</font></td><td>$TRACKER_UPDATE</td></tr>"
		echo "<tr><td>Cookie *</td><td><center>---</center></td><td><font color=#808080>$COOKIE_TIME</font></td><td>$COOKIE_UPDATE</td></tr>"
	fi
echo '</TABLE>'

echo "<br><br><HR>"


echo "<h3>OMDAN : $BONUS_WHOLE Bonus</h3>"
echo "$(cat conf/RATIO_TAG.K_f  | sed 's/:<\/font>/: <\/font>/g ; s/MB<\/font>/MB <\/font>/g ; s/GB<\/font>/GB <\/font>/g ; s/Upload/ Upload/g')"


for LINE_ in $(seq $(grep '^[^#/]' conf/Database/database.db | wc -l))
do 
	DB_RELEASE=$(grep "$LINE_" conf/Database/database.db | cut -d : -f 3)
	NAME_RELEASE=$(grep "$LINE_" conf/Database/database.db | cut -d : -f 2 | sed 's/[._]/ /g')

	echo '<TABLE BORDER="1" CELLSPACNG="0" CELLPADDING="5">'
	echo -ne "<tr><td>Release Update : $NAME_RELEASE </td><td>Time</td><td>Date</tr>"
	echo "<br><br>"
	for TOR_ in $(seq $(grep '^TOR' conf/$DB_RELEASE | wc -l))
	do
		
		DATE=$(grep '^TOR' conf/$DB_RELEASE | grep "^TOR>$TOR_" | cut -d \> -f 3 | sed 's/:TIME//')
		TIME=$(grep '^TOR' conf/$DB_RELEASE | grep "^TOR>$TOR_" | cut -d \> -f 4 | sed 's/:NAME//')
		NAME=$(grep '^TOR' conf/$DB_RELEASE | grep "^TOR>$TOR_" | cut -d \> -f 5)

		echo -ne "<tr><td><FONT COLOR='green'>$NAME</FONT></td><td>$TIME</td><td>$DATE</tr>"
	done
done 

echo "</TABLE>"
echo "<br><br>"
echo "<center>Last Build Feed : $LAST_BUILD</center><br>"
echo "<br><br><HR>"
echo "<h4>*cookie atualiza a cada $(echo $COOKIE_UPDATE | sed 's/hour/horas/') para evitar bug's </h4>"
echo "</body></html>"	
