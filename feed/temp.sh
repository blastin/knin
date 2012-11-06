#!/bin/bash
#                                                     .__   __.  __  .__   __.  __  ___ 
#                                                     |  \ |  | |  | |  \ |  | |  |/  / 
#                                                     |   \|  | |  | |   \|  | |  '  /  
#                                                     |  . `  | |  | |  . `  | |    <   
#                                                     |  |\   | |  | |  |\   | |  .  \  
#                                                     |__| \__| |__| |__| \__| |__|\__\' powered debian.
#
#                               Feed<rtorrent 0.9.3/0.13.3>
# Project     : KNiN Feader
# Autor       : BLASTiN

# Versão  0.6.6 :> Versão em teste : CPU USAGE
#----- 22/FEV/12:> FIX  algoritmo para retirar excesso de tempo em feed_check
#---------------:> uso de sleep em feed_check pode ser usado normalmente
#------29/FEV/12:> inserido caracteres de controle
#---------------:> limpeza de código
#---------------:> $1 in feed_check is a debug mode
#---------------:> tempo diminuido para 7 minutos
#---------------:> TESTANDO USO DE PROCESSO
#------04/MAR/12:> Analisado problemas com TRACKER_UPDATE,TRACKER_TIME e SLEEP_TIME
#---------------:> BONUS_WHOLE inserido em automatic_bot
#---------------:> BUG diversos consertados
#---------------:> limpeza e melhorando da syntax
#---------------:> OMDA inserido 
#------05/MAR/12:> Duas novas variavéis em linha 350 ~354
#---------------:> Problemas está com horários em numeral 'OCT'
#---------------:> Resolvido
#------06/MAR/12:> Adicionado funções para retomada dos horários de TRACKER_TIME  e  COOKIE_TIME
#---------------:> Resolvido wget com save--cookie em tracker check
#---------------:> init_bot retirado, versão obsoleta ....
#------07/MAR/12:> Problema com condicional de fluxo  em linha 318
#test "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END"
#---------------:>Função function_ratio_update() criada ;
# Versão  1.0.0 :> Versão Beta 2
#------26/OUT/12:> Atualização,limpeza e novos códigos
#------31/OUT/12:> Adicionado SLOW_BOT_TIME_UPDATE à dias específicos.
#------04/NOV/12:> Adicionado função para torrent do one piece project.
#------05/NOV/12:> Inserido checagem de modificação em feed com diff
# INFO        :
# -- -- [ "$1" -eq 1 ] : debug  < mod  echo -> stdout [screen] 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -r ACCOUNT=$(grep '^ACCOUNT' conf/conf.script | cut -d = -f 2)
declare -r PASSWD=$(grep '^PASSWD'  conf/conf.script  | cut -d = -f 2)
declare -r TIME_UPDATE=$(grep '^TIME_UPDATE' conf/conf.script | cut -d = -f 2)
declare -r TIME_SYSTEM=$(grep '^TIME_SYSTEM' conf/conf.script | cut -d = -f 2)
declare -r TIME_NAME=$(grep '^TIME_NAME' conf/conf.script | cut -d = -f 2)
declare -r SLOW_BOT_TIME_UPDATE=$(grep '^SLOW_BOT_TIME_UPDATE' conf/conf.script | cut -d = -f 2)
declare -r date_time=$(date +%H:%M:%S)
declare -r headstatus_ok=200
declare -r feed_lenght_min=4 #valor minímo para checagem em diff
declare -A TRACKER_CONF_=() 
declare -r INDICE_TRACKER_CONF="$(grep "^INDICE" Database/database.db  | cut -d : -f 2)"
declare -r chaves=(["MODE"]=0 ["TRACKER"]=1 ["NAME"]=2 ["DATABASE"]=3 ["COOKIE"]=4 ["LINK"]=5)

UPDATE_FEED=0
SLOW_BOT=(-1)
SLOW_BOT_DAY=(-1)
LIST_TRACKER=(-1)


TRACKER_TIME_FLAG=1
TIME_UPDATE_NEXT_BEFORE_FEED_CHECK=0
TIME_UPDATE_NEXT_BEFORE_SLEEP=0
BUFF_TIME_EXCESS=0

EP_ONEPIECE="$(grep '^EXPECT_EPI=' $(echo Database/database_one_piece.db | sed 's/ //') | cut -d = -f 2 | cut -d \# -f -1 | cut -d \; -f -1)"
ID_ONEPIECE="$(grep '^ID=' $(echo Database/database_one_piece.db | sed 's/ //') | cut -d = -f 2 | cut -d \# -f -1 | cut -d \; -f -1)"


init(){
	reset
	rm -rf null_temp conf/.backup/ cookie logs
	mkdir null_temp conf/.backup/  cookie logs
	local FLAG_VAR_TEMP=0
	local FLAG_VAR_TEMP_DAY=0
	local VAR_TEMP=" "
	local VAR_TEMP_DAY=" "
	local SLOW_BOT_CONF_SCRIPT="$(grep "^SLOW_BOT=" conf/conf.script | cut -d = -f 2 | cut -d \# -f 1)"
	local SLOW_BOT_DAY_CONF_SCRIPT="$(grep "^SLOW_BOT_DAY=" conf/conf.script | cut -d = -f 2 | cut -d \# -f 1)"
	local SLOW_BOT_COUNT=0
	local SLOW_BOT_COUNT_DAY=0
	local LIST_TRACKER_COUNT=0
	
	if test ! -d patch_feed
	then
		curl  --silent -o "null_temp/web_mdan_connect" --limit-rate 32k --cookie-jar "cookie/mdan.cookie" --data 'username=blastin&password=112256dnbonline' "http://bt.mdan.org/takelogin.php" 
		mkdir patch_feed
		curl --silent -o "patch_feed/feed_check.xml" --limit-rate 10k --cookie "cookie/mdan.cookie" "http://bt.mdan.org/rss.php?feedtype=download&timezone=-3&showrows=10&categories=1"
	fi
	

	while :
	do
		VAR_TEMP="$(grep '^LIST_OF_TRACKERS=' conf/conf.script | cut -d \= -f 2 | cut -d : -f "$(($LIST_TRACKER_COUNT+1))")"
		

		if test -n  "$VAR_TEMP"
		then		
			LIST_TRACKER["$LIST_TRACKER_COUNT"]="$VAR_TEMP"
			LIST_TRACKER=$(($LIST_TRACKER_COUNT+1))
		
		else
			break
		fi

	done
	while :
	do
		VAR_TEMP="$(echo $SLOW_BOT_CONF_SCRIPT | cut -d : -f "$(($SLOW_BOT_COUNT+1))")"
		

		if test -n  "$VAR_TEMP"
		then		
			SLOW_BOT["$SLOW_BOT_COUNT"]="$VAR_TEMP"
			SLOW_BOT_COUNT=$(($SLOW_BOT_COUNT+1))
		
		else
			break
		fi

	done

	while :
	do
		VAR_TEMP_DAY="$(echo $SLOW_BOT_DAY_CONF_SCRIPT | cut -d : -f "$(($SLOW_BOT_COUNT_DAY+1))")"

		if test -n "$VAR_TEMP_DAY"
		then
			SLOW_BOT_DAY["$SLOW_BOT_COUNT_DAY"]="$VAR_TEMP_DAY"
			SLOW_BOT_COUNT_DAY=$(($SLOW_BOT_COUNT_DAY+1))
			
		else
			break
		fi
	done
	#

}
conf_get(){

	local TRACKER_ADD=0

	cp conf/conf.script conf/.backup/conf.script.backup
	for LINE_ in $(seq $(grep '^[^#/]' Database/database.db | wc -l))
	do
		
		TRACKERS_CONF_["$(($TRACKER_ADD))"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 2 | cut -d : -f 2)"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#MODE FEED ou link

		TRACKERS_CONF_["$(($TRACKER_ADD))"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 3 | cut -d : -f 2)"
		#nome do tracker
		TRACKER_ADD=$(($TRACKER_ADD+1))

		TRACKERS_CONF_["$(($TRACKER_ADD))"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 4 | cut -d : -f 2)"
		#Nome do anime
		TRACKER_ADD=$(($TRACKER_ADD+1))

		TRACKERS_CONF_["$(($TRACKER_ADD))"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 5 | cut -d : -f 2)"
		TRACKER_ADD=$(($TRACKER_ADD+1))

		#Database do anime
		TRACKERS_CONF_["$(($TRACKER_ADD))"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 6 | cut -d : -f 2)"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#cookie

		TRACKERS_CONF_["$(($TRACKER_ADD))"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 7 | cut -d : -f 2-)"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#link

		TRACKERS_CONF_["$(($TRACKER_ADD))"]="$(grep '^EXPECT_EPI=' $(echo Database/$DB_RELEASE | sed 's/ //') | cut -d = -f 2 | cut -d \# -f -1 | cut -d \; -f -1)"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#RELEASE , Episodio esperado

		TRACKERS_CONF_["$(($TRACKER_ADD))"]="$(grep '^ID=' $(echo Database/$DB_RELEASE | sed 's/ //') | cut -d = -f 2 | cut -d \# -f -1 | cut -d \; -f -1)"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#ID a ser armazenado
	done

	if test "$1" = "--verbose"
	then	
		bot_print "CONF_GET Already"
		sleep 2
	fi
	
}
one_piece(){

	date_today="$(date '+%a')"
	
	case $date_today in

	"Dom" )

		if test "$(date '+%H')" -ge 09
		then
			while :
			do
				local TIME_FEED_CHECK=$(date +%H:%M:%S)
				local status=$(curl -s --head http://onepiece.xpg.com.br/torrent/piecePROJECT_-_Epi_"$EP_ONEPIECE"_HD.mkv.torrent | head -n 1 | cut -d ' ' -f 2)
	
				if test $status -eq $headstatus_ok
				then
					if test "$1" = "--verbose"
					then	
						bot_print "Feed encontrado : piecePROJECT-Epi."$EP_ONEPIECE".HD.mkv"
					fi

					curl --silent -o  "rtorrent_watch/piecePROJECT_-_Epi_"$EP_ONEPIECE"_HD.mkv.torrent" http://onepiece.xpg.com.br/torrent/piecePROJECT_-_Epi_"$EP_ONEPIECE"_HD.mkv.torrent

					cat Database/database_one_piece.db | sed "s/EXPECT_EPI=$EP_ONEPIECE/EXPECT_EPI=$(($EP_ONEPIECE+1))/g ; s/ID=$ID_ONEPIECE/ID=$(($ID_ONEPIECE+1))/g" > null_temp/TEMP_DB
					echo -ne "TOR>$(($ID_ONEPIECE)):DIA>$(date +%D):TIME>$TIME_FEED_CHECK:NAME>piecePROJECT_-_Epi_"$EP_ONEPIECE"_HD.mkv.torrent
	#-----------------------------------------------------\n" >> null_temp/TEMP_DB

					mv null_temp/TEMP_DB Database/database_one_piece.db

					UPDATE_FEED=$(($UPDATE_FEED +1))	
					EP_ONEPIECE=$(($EP_ONEPIECE +1))
					ID_ONEPIECE=$(($ID_ONEPIECE +1))

				else
					break
				fi
			done
		fi
		;;
	esac

}



torrent_file_get(){
#wget --limit-rate=25k --load-cookies "cookie/mdan.cookie" -O "rtorrent_watch/$(cat null_temp/LINK_TOR | cut -d = -f 3 | sed 's/torrent.*/torrent/')"   -o logs/logfile -i null_temp/LINK_TOR
	if test -n "$1"
	then
		case "$1" in 

		"MDAN" ) 
			MODE_="--cookie "cookie/mdan.cookie""			
			;;
		"Project" )

			
			fi

			MODE_=""

		esac

		curl --silent --limit-rate 32k "$MODE_" -o "rtorrent_watch/$(cat null_temp/LINK_TOR | cut -d = -f 3 | sed 's/torrent.*/torrent/')" "$(cat null_temp/LINK_TOR)"
	else
		echo "ERROR : argumento em função torrent_file_get não especificado"
		exit 1
	fi



}

slow_bot_check(){

	if test -n "${#SLOW_BOT_DAY[*]}"
	then
		for LINE_ in $(seq ${#SLOW_BOT_DAY[*]})
		do
			test "$(date '+%a')" = "${SLOW_BOT_DAY["$(($LINE_-1))"]}" -o "$(date '+%A')" = "${SLOW_BOT_DAY["$(($LINE_-1))"]}"  && return 0
		done
	fi

	if test -n "${#SLOW_BOT[*]}"
	then
		for LINE_ in $(seq ${#SLOW_BOT[*]})
		do
			test "$(date '+%H')" -eq "${SLOW_BOT["$(($LINE_-1))"]}" && return 0
		done
	fi
	
	return 1

}

bot_print(){

	if test -n "$1"
	then
		echo -ne '\033[G'
            	echo -ne "\033[11C"
            	echo -ne "\033[0K"

		slow_bot_check; if test $? -eq 1
		then
			echo -n "[NORM] UPDATE : [$UPDATE_FEED] | "$1"   "
		else
			echo -n "[SLOW] UPDATE : [$UPDATE_FEED] | "$1"   "
		fi
	fi


}

init_cookie(){ 

        if test "$1" = "--debug" 
        then
            echo -e "-----------------------------------------------\n\n"
            echo -e "Recebendo cookie .......\n"
            echo -e "-----------------------------------------------\n\n"
        
        elif test "$1" = "--verbose"
        then
	    bot_print "Salvando cookie:"
        fi
        

    	#wget  -qO  "null_temp/web_mdan_connect" --limit-rate=32k --save-cookies "cookie/mdan.cookie" --post-data 'username='$ACCOUNT'&password='$PASSWD'' "http://bt.mdan.org/takelogin.php" 

	curl  --silent -o "null_temp/web_mdan_connect" --limit-rate 32k --cookie-jar "cookie/mdan.cookie" --data 'username=blastin&password=112256dnbonline' "http://bt.mdan.org/takelogin.php" 

	#conecta-se ao web site , gerando o arquivo cookie
	test "$1" = "--verbose"  && echo -n " [OK]"
}

feed_check(){

	

	for LINE_ in $(seq $(grep '^[^#/]' Database/database.db | wc -l))
	do 
	   	#chaves=(["MODE"]=0 ["TRACKER"]=1 ["NAME"]=2 ["DATABASE"]=3 ["COOKIE"]=4 ["LINK"]=5)
		
		#feed.xml contém a última atualização do feed.
		TIME_FEED_CHECK=$(date +%H:%M:%S)
		case ${TRACKERS_CONF_[$(($INDICE_TRACKER_CONF*$LINE_+ ${test["MODE"]} ))]} in

			"_FEED_" )

				LINK="${TRACKERS_CONF_[$(($INDICE_TRACKER_CONF*$LINE_+ ${test['LINK']}))]}"
				FEED="${TRACKERS_CONF_[$(($INDICE_TRACKER_CONF*$LINE_+ ${test['MODE']}))]}"
				TRACKER="${TRACKERS_CONF_[$(($INDICE_TRACKER_CONF*$LINE_+ ${test['TRACKER']}))]}"

				case ${TRACKERS_CONF_[$(($INDICE_TRACKER_CONF*$LINE_+ ${test["COOKIE"]} ))]} in
				
					"YES" )
						COOKIE="${TRACKERS_CONF_[$(($INDICE_TRACKER_CONF*$LINE_+ ${test['COOKIE']}))]}"

						curl --silent -o "patch_feed/feed_check_"$FEED".xml" --limit-rate 10k --cookie "cookie/"$COOKIE".cookie" "$LINK"

						if test $(diff patch_feed/feed_check_"$TRACKER".xml patch_feed/feed_"$TRACKER".xml  | wc -l) -le $feed_lenght_min
						then
							continue
						else
							mv patch_feed/feed_check_"$TRACKER".xml  patch_feed/feed_"$TRACKER".xml
						fi
					;;	
					"NO"  )
						bot_print "WARNING : feed sem cookie não foi implementado"
						exit 0
						#NÃO IMPLEMENTADO
					;;
					
					* )
	    					bot_print "ERROR: in {TRACKERS_CONF_[((INDICE_TRACKER_CONF*LINE_+ {test[COOKIE]} ))]}"
					;;
				esac
			;;
			"_LINK_" )

				local status=$(curl -s --head "$(echo $LINK | sed 's/#EP_ONEPIECE_HD/'"$EP_ONEPIECE_"'/')" | head -n 1 | cut -d ' ' -f 2)
				if test $status -ne $headstatus_ok
				then
					continue
				else
					
				fi
			;;
		esac
		
		#----------------------------------------------------------------------------------------------------------------
		#wget -qO "patch_feed/feed.xml" --limit-rate=10k --load-cookies "cookie/mdan.cookie" "http://bt.mdan.org/rss.php?feedtype=download&timezone=-3&showrows=10&categories=1"

		#curl --silent -o "patch_feed/feed_check_"$TRACKER".xml" --limit-rate 10k --cookie "cookie/"$TRACKER".cookie" "http://bt.mdan.org/rss.php?feedtype=download&timezone=-3&showrows=10&categories=1"
		

		if test "$1" = "--debug"
		then
			echo -e "-----------------------------------------------\n\n"
			echo -e "Filtrando feed.xml .......\n"
			echo -e "-----------------------------------------------\n\n"
		fi
		

		grep '<link>.*</link>' patch_feed/feed.xml  | 
		sed '1,2 d ; s/<link>//g ; s/<\/link>//g ; s/amp;//g ; s/          //g' | 
		grep "$(grep '^Anime' conf/conf.script |cut -d = -f 2 | sed 's/:/\\|/g ; s/$/\\)/g ; s/^/\\(/g')" > null_temp/LINK_RELEASE



	#FIM
		while :
	    	do
			test $RELEASED -gt 0 -a $RELEASED -le 9 &&
			    RELEASED_OCT="0$RELEASED" ||
			    RELEASED_OCT="_KNIN_"
			#Episódio a procura

			grep "$NAME_.\($RELEASED\|$RELEASED_OCT\)" null_temp/LINK_RELEASE > null_temp/LINK_TOR

			test "$1" = "--debug"  && echo -ne "Verificando nova atualização ..."

			if test  "$(cat null_temp/LINK_TOR)"

			then

			    if test "$1" = "--verbose"
			    then
				bot_print "Feed encontrado : $(cat null_temp/LINK_TOR | cut -d = -f 3)"
			    fi
			    
			    if test "$1" = "--debug"
			    then
				 echo -ne "sucessed!\n"
				 echo -e "-----------------------------------------------\n"
				 echo -e "[UPDATE]----------------K-N-i-N----------------[NEW]"
				 echo -ne "Anime              : $(echo $NAME_ |sed 's/[._]/ /g')\n"
				 echo -ne "Episódio: $RELEASED\n"
				 echo -ne "Name File torrent : $(cat null_temp/LINK_TOR | cut -d = -f 3 | sed 's/torrent.*/torrent/')\n"
				 echo -ne "Time : $TIME_FEED_CHECK\n"
				 echo -ne "Iniciando Download .."
				 sleep 4
			    fi
		
			    torrent_file_get "$TRACKER"
			    
		
			    test "$1" = "--debug"  && { 
				echo -ne "completado!\n"
				echo -e "[UPDATE]----------------K-N-i-N----------------[NEW]" 
				}

			    sleep 2

			    cp $(echo Database/$DB_RELEASE | sed 's/ //') $(echo Database/$DB_RELEASE | sed 's/ //')~


			    cat $(echo Database/$DB_RELEASE | sed 's/ //') | sed "s/EXPECT_EPI=$RELEASED/EXPECT_EPI=$(($RELEASED+1))/g ; s/ID=$ID/ID=$(($ID+1))/g" > null_temp/TEMP_DB

			    echo -ne "TOR>$(($ID)):DIA>$(date +%D):TIME>$TIME_FEED_CHECK:NAME>$(cat null_temp/LINK_TOR | cut -d = -f 3 | sed 's/$//')
		#-----------------------------------------------------\n" >> null_temp/TEMP_DB

			    mv null_temp/TEMP_DB $(echo Database/$DB_RELEASE | sed 's/ //')
			    RELEASED=$(($RELEASED+1))
			    ID=$(($ID +1))
			    UPDATE_FEED=$(($UPDATE_FEED+1))

			else #[ "$(cat null_temp/LINK_TOR)" ] && 
		
			    if test "$1" = "--debug"
			    then 
				echo -ne "nada novo ..!\n"
				echo -e "-----------------------------------------------\n\n"
				echo -e "[UPDATE]----------------K-N-i-N----------------[NOTHING]"
				echo -ne "Anime              : $(echo $NAME_ |sed 's/[._]/ /g')\n"            
				echo -ne "Episódio esperado  : $RELEASED\n"
				echo -ne "Horário de checagem: $TIME_FEED_CHECK\n"
				echo -e "[UPDATE]----------------K-N-i-N----------------[NOTHING]\n\n"
				sleep 4
			    fi

		    break # While

		fi


		done #while :

	done #for LINE_ in $(seq $(cat Database/database.db | cut -d : -f 3 | wc -l))

}

automatic_bot(){

	
	
	init $1

	if test "$1" != "--quiet"
	then
	    echo -e ".... Project KNiN : Feed ....\n"
	    echo -e ".... Bem Vindo - Blastin ....\n"
	    echo -e "Horário de Início : $date_time"
	    echo -e "\n"
	    echo -e "Database's Quantidade: $(grep '^[^#/]' Database/database.db | wc -l)\n"
	    echo -e "\n-----------------------------------------------\n\n"
	    echo -e "TIME UPDATE NORMAL: $TIME_UPDATE $TIME_NAME\n"
	    echo -e "TIME UPDATE SLOW  : $SLOW_BOT_TIME_UPDATE $TIME_NAME\n"
	    echo -ne "SLOW CPU          : "
	    for LINE_ in $(seq ${#SLOW_BOT[*]})
	    do
	    	echo -ne "(${SLOW_BOT["$(($LINE_-1))"]}:00)" 
	    done
	    echo -e "\n"
	    echo -ne "SLOW CPU DAY      : "
	    for LINE_ in $(seq ${#SLOW_BOT_DAY[*]})
	    do
	    	echo -ne "(${SLOW_BOT_DAY["$(($LINE_-1))"]})" 
	    done
	    echo -e "\n-----------------------------------------------\n\n"
	fi

	
	init_cookie "$1"
	conf_get "$1"

	while :
	do

		one_piece "$1"
		feed_check "$1"

		TIME_UPDATE_NEXT_BEFORE_FEED_CHECK=$(date +%s)

		#--------------------------------------------------------------------------------------
		#TODO:BUFF_TIME : retira o excesso de segundos em feed_check
		if test $TIME_UPDATE_NEXT_BEFORE_FEED_CHECK -ne 0 -a $TIME_UPDATE_NEXT_BEFORE_SLEEP -ne 0
		then
		    BUFF_TIME_EXCESS=`expr $TIME_UPDATE_NEXT_BEFORE_FEED_CHECK \- $TIME_UPDATE_NEXT_BEFORE_SLEEP`
		fi
		#--------------------------------------------------------------------------------------


		slow_bot_check; if test $? -eq 1
		then 

		    if test "$1" = "--verbose"
		    then
			echo -ne '\033[G'
			echo -ne "\033[11C"
			echo -ne '\033[0K'
			echo -n "[NORM] UPDATE : [$UPDATE_FEED] | Next Update  : $(date -d "$TIME_UPDATE $TIME_NAME - $BUFF_TIME_EXCESS seconds" +%H:%M:%S)"
		    fi
		     
		    #------------------------------------
		    #Seguindo a regra de ser específicado  em conf/conf.script 
		    TIME_UPDATE_NEXT=$(($TIME_UPDATE * $TIME_SYSTEM))
		else

		    if test "$1" = "--verbose"
		    then
			echo -ne '\033[G'
			echo -ne "\033[11C"
			echo -ne '\033[0K'
			echo -n "[SLOW] UPDATE : [$UPDATE_FEED] | Next Update  : $(date -d "$SLOW_BOT_TIME_UPDATE $TIME_NAME - $BUFF_TIME_EXCESS seconds" +%H:%M:%S)"
		    fi
		    #------------------------------------
		    #Seguindo a regra de ser específicado  em conf/conf.script 
		    TIME_UPDATE_NEXT=$(($SLOW_BOT_TIME_UPDATE * $TIME_SYSTEM))    

		fi

		#-------- ------------Sleep--------- ------------#
		sleep $(($TIME_UPDATE_NEXT - $BUFF_TIME_EXCESS)) #
		TIME_UPDATE_NEXT_BEFORE_SLEEP=$(date +%s)        #
		#-------- ----------- KNiN --------- ------------#

		if test "$1" = "--verbose"
		then
			bot_print "Init Update ...."
		fi
	done

}

################### INICIALIZAÇÃO #################


if test "$2" = "-q" -o "$1" = "--quiet"
then
	automatic_bot "--quiet"
elif test "$2" = "-d" -o "$1" = "--debug"
then
	automatic_bot "--debug"
else
	automatic_bot "--verbose"
fi

exit 0
