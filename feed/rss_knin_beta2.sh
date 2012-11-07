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
#------07/NOV/12:> Versão Beta 2 em teste
# INFO        :
# -- -- [ "$1" -eq 1 ] : debug  < mod  echo -> stdout [screen] 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -r ACCOUNT_MDAN=$(grep '^ACCOUNT' conf/conf.script | cut -d = -f 2)
declare -r PASSWORD_MDAN=$(grep '^PASSWD'  conf/conf.script  | cut -d = -f 2)
declare -r TIME_UPDATE=$(grep '^TIME_UPDATE' conf/conf.script | cut -d = -f 2)
declare -r TIME_SYSTEM=$(grep '^TIME_SYSTEM' conf/conf.script | cut -d = -f 2)
declare -r TIME_NAME=$(grep '^TIME_NAME' conf/conf.script | cut -d = -f 2)
declare -r SLOW_BOT_TIME_UPDATE=$(grep '^SLOW_BOT_TIME_UPDATE' conf/conf.script | cut -d = -f 2)
declare -r date_time=$(date +%H:%M:%S)
declare -r headstatus_ok=200
declare -r feed_lenght_min=4 #valor minímo para checagem em diff
declare -A TRACKER_CONF_=() 
declare -A LIST_FILTER_FEED=()
######################################################################
declare -rA INDICE_TRACKER_CHAVE=(["MODE"]=0 ["TRACKER"]=1 ["TYPE"]=2 ["NAME"]=3 ["DAY"]=4 ["HOUR"]=5 ["DATABASE"]=6 ["COOKIE"]=7 ["LINK"]=8)
declare -r  INDICE_TRACKER_CONF="${#INDICE_TRACKER_CHAVE[*]}"
######################################################################


declare UPDATE_FEED=0
declare SLOW_BOT
declare SLOW_BOT_DAY
declare LIST_TRACKER
declare LIST_TRACKER_COOKIE
declare TRACKER_TIME_FLAG=1
declare TIME_UPDATE_NEXT_BEFORE_FEED_CHECK=0
declare TIME_UPDATE_NEXT_BEFORE_SLEEP=0
declare BUFF_TIME_EXCESS=0

#EP_ONEPIECE="$(grep '^EXPECT_EPI=' $(echo Database/database_one_piece.db | sed 's/ //') | cut -d = -f 2 | cut -d \# -f -1 | cut -d \; -f -1)"
#ID_ONEPIECE="$(grep '^ID=' $(echo Database/database_one_piece.db | sed 's/ //') | cut -d = -f 2 | cut -d \# -f -1 | cut -d \; -f -1)"


init(){
	reset
	rm -rf null_temp conf/.backup/ cookie logs patch_feed
	mkdir null_temp conf/.backup/  cookie logs patch_feed
	local FLAG_VAR_TEMP=0
	local FLAG_VAR_TEMP_DAY=0
	local VAR_TEMP=" "
	local VAR_TEMP_DAY=" "
	local SLOW_BOT_CONF_SCRIPT="$(grep "^SLOW_BOT=" conf/conf.script | cut -d = -f 2 | cut -d \# -f 1)"
	local SLOW_BOT_DAY_CONF_SCRIPT="$(grep "^SLOW_BOT_DAY=" conf/conf.script | cut -d = -f 2 | cut -d \# -f 1)"
	local SLOW_BOT_COUNT=0
	local SLOW_BOT_COUNT_DAY=0
	#local LIST_TRACKER_COUNT=0

	
	#for LINE_ in $(seq $(grep '^[^#/]' conf/feed.filters | wc -l))
	#do
		#local TRACKER="$(grep "^$LINE_" conf/feed.filters | cut -d \; -f 2 | cut -d : -f 2)"
		#LIST_FILTER_FEED["$TRACKER"]="$(grep "^$LINE_" conf/feed.filters | cut -d \; -f 3- | cut -d : -f 2-)"
	#done
	

	#while :
	#do
	#	VAR_TEMP="$(grep '^LIST_OF_TRACKERS=' conf/conf.script | cut -d \= -f 2 | cut -d : -f "$(($LIST_TRACKER_COUNT+1))")"
		

	#	if test -n  "$VAR_TEMP"
		#then		
		#	LIST_TRACKER["$LIST_TRACKER_COUNT"]="$VAR_TEMP"
		#	LIST_TRACKER=$(($LIST_TRACKER_COUNT+1))
		
		#else
		#	break
		#fi

	#done
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

bot_print(){

	if test -n "$1"
	then
		if test -n "$2" -a "$1" = "--verbose"
		then
			echo -ne '\033[G'
		    	echo -ne "\033[11C"
		    	echo -ne "\033[0K"

			slow_bot_check; if test $? -eq 1
			then
				echo -n "[NORM] UPDATE : [$UPDATE_FEED] | "$2"   "
			else
				echo -n "[SLOW] UPDATE : [$UPDATE_FEED] | "$2"   "
			fi
		else
			echo "$2"
		fi
	fi


}

filters_feed(){ #todos filters ficaram aqui até resolver conf/feed.filters

	if test -n "$2"
	then
	
		case "$2" in
	
		"MDAN" )
			#'patch_feed/feed_'"$TRACKER"'.xml'
			grep '<link>.*</link>' 'patch_feed/feed_'"$2"'.xml' | \
			sed '1,2 d ; s/<link>//g ; s/<\/link>//g ; s/amp;//g ; s/          //g' > null_temp/LINK_RELEASE
		
		;;
	
		esac
	else
		bot_print "$1" "ERROR: argumento não especificado para filters_ function"
		exit 1
	fi




}


filters_episodio(){

	#$2 = Tracker
	#$3 = Número do Episódio
	#$4 = Nome da mídia

	if test -n "$2" -a -n "$3" -a -n "$4"
	then
	
		case "$2" in
	
		"MDAN" )

			if test "$3" -gt 0 -a "$3" -le 9
			then 
			    local RELEASED_OCT="0$3"
			else
			    local RELEASED_OCT="_KNIN_"
			fi

			#Episódio a procura

			grep "$4.\("$3" \|"$RELEASED_OCT" \)" null_temp/LINK_RELEASE > null_temp/LINK_TOR
		;;
	
		esac
	else
		bot_print "$1" "ERROR: argumento não especificado para filters_episodio"
		exit 1
	fi


}


conf_get(){

	local TRACKER_ADD=0

	cp conf/conf.script conf/.backup/conf.script.backup
	for LINE_ in $(seq $(grep '^[^#/]' Database/database.db | wc -l))
	do
		if test "$LINE_" -gt "$INDICE_TRACKER_CONF"
		then
			bot_print "$1" "ERROR: TRACKER_CONF estou limite da variável INDICE_TRACKER_CONF em função conf_get"
			exit 1
		fi


		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 2 | cut -d : -f 2)"
		echo "TRACKERS_CONF_[$TRACKER_ADD] : ${TRACKERS_CONF_["$TRACKER_ADD"]} "
		TRACKER_ADD=$(($TRACKER_ADD+1))		
		#MODE FEED ou link

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 3 | cut -d : -f 2)"
		echo "TRACKERS_CONF_[$TRACKER_ADD] : ${TRACKERS_CONF_["$TRACKER_ADD"]} "
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#nome do tracker

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 4 | cut -d : -f 2)"
		echo "TRACKERS_CONF_[$TRACKER_ADD] : ${TRACKERS_CONF_["$TRACKER_ADD"]} "
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#Tipo do tracker ; Público ou Privado

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 5 | cut -d : -f 2)"
		echo "TRACKERS_CONF_[$TRACKER_ADD] : ${TRACKERS_CONF_["$TRACKER_ADD"]} "
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#Nome do anime

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 6 | cut -d : -f 2)"
		echo "TRACKERS_CONF_[$TRACKER_ADD] : ${TRACKERS_CONF_["$TRACKER_ADD"]} "
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#Dia específico

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 7 | cut -d : -f 2)"
		echo "TRACKERS_CONF_[$TRACKER_ADD] : ${TRACKERS_CONF_["$TRACKER_ADD"]} "
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#Horário de início específico

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 8 | cut -d : -f 2)"	
		echo "TRACKERS_CONF_[$TRACKER_ADD] : ${TRACKERS_CONF_["$TRACKER_ADD"]} "
		local DB_TEMP_INDICE="$TRACKER_ADD"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#Database do anime

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 9 | cut -d : -f 2)"
		echo "TRACKERS_CONF_[$TRACKER_ADD] : ${TRACKERS_CONF_["$TRACKER_ADD"]} "
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#cookie

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 10 | cut -d : -f 2-)"
		echo "TRACKERS_CONF_[$TRACKER_ADD] : ${TRACKERS_CONF_["$TRACKER_ADD"]} "
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#link

		#bot_print "$1" "${TRACKERS_CONF_[$(($(($LINE_-1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['COOKIE']}))]}"
		if test "${TRACKERS_CONF_[$(($(($LINE_-1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['COOKIE']}))]}" = "YES"
		then
			if test "$LINE_" -eq 1
			then
				#bot_print "$1" "entrei... $LINE_"
				#bot_print "$1" "${TRACKERS_CONF_[$(($(($LINE_ - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['TRACKER']}))]}"
				
				LIST_TRACKER_COOKIE["$(($LINE_-1))"]="${TRACKERS_CONF_[$(($(($LINE_ - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['TRACKER']}))]}"
				#bot_print "$1" "list : "${LIST_TRACKER_COOKIE[$(($LINE_-1))]}" "
			else
				TRACKER_FLAG=0
				REBACK_TEMP="${#LIST_TRACKER_COOKIE[*]}"

				while test $REBACK_TEMP -ne 0
				do
					if test "${TRACKERS_CONF_[$(($(($LINE_-1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['TRACKER']}))]}" = "${LIST_TRACKER_COOKIE[$(($REBACK_TEMP - 1))]}"
					then	
						#bot_print "$1" "encontrei tracker parecido"
						TRACKER_FLAG=1
						break
					#else
						#bot_print "$1" "diferente"					
					fi
					REBACK_TEMP="$(($REBACK_TEMP - 1))"
				done

				if test  "$TRACKER_FLAG" -eq 0
				then
					LIST_TRACKER_COOKIE["$(($LINE_-1))"]="${TRACKERS_CONF_[$(($(($LINE_ - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['TRACKER']}))]}"
				#else 
					#bot_print "$1" "value of tracker_flag is :$TRACKER_FLAG "
				fi
			fi
					
		fi
	done

	
	bot_print "$1" "CONF_GET Already"
	sleep 2
	
	
	
}




torrent_file_get(){
#
	if test -n "$1"
	then
		case "$1" in 

		"Privado")
			if test -n "$2"
			then
				case "$2" in

				"MDAN" ) 
					MODE_="--cookie "cookie/MDAN.cookie""
				;;			
				* )
					echo "ERROR : argumento 2 em função torrent_file_get é diferente das constantes"
					exit 1
				;;
				esac
			else
				echo "ERROR : argumento 2 em função torrent_file_get não especificado"
				exit 1
			fi
			;;

		"Publico")
			if test -n "$2"
			then
		
				case "$2" in

				"Project" )
					MODE_=""
				;;

				* )
					echo "ERROR : argumento 2 em função torrent_file_get é diferente das constantes"
					exit 1
				;;
				esac

			else
				echo "ERROR : argumento 2 em função torrent_file_get não especificado"
				exit 1
			fi
		;;	
		esac

		curl --silent --limit-rate 32k "$MODE_" -o "rtorrent_watch/$(cat null_temp/LINK_TOR | cut -d = -f 3 | sed 's/torrent.*/torrent/')" "$(cat null_temp/LINK_TOR)"
		test ! -f "rtorrent_watch/$(cat null_temp/LINK_TOR | cut -d = -f 3 | sed 's/torrent.*/torrent/')" "$(cat null_temp/LINK_TOR)" && \
		wget --limit-rate=25k "$MODE_" -O "rtorrent_watch/$(cat null_temp/LINK_TOR | cut -d = -f 3 | sed 's/torrent.*/torrent/')"   -o logs/logfile -i null_temp/LINK_TOR
			
	else
		echo "ERROR : argumento 1 em função torrent_file_get não especificado"
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




init_cookie(){ 

#$1 debug ou verbose


	bot_print "$1" "-----------------------------------------------\n\n"
	bot_print "$1" "Recebendo cookie .......\n"
	bot_print "$1" "-----------------------------------------------\n\n"
	bot_print "$1" "Salvando cookie:"
        
	if test -n "$2"
	then
		case "$2" in

		"MDAN" ) 
			
			wget  -qO  "null_temp/web_mdan_connect" --limit-rate=32k --save-cookies "cookie/MDAN.cookie" --post-data 'username='"$ACCOUNT_MDAN"'&password='"$PASSWORD_MDAN"'' "http://bt.mdan.org/takelogin.php"
		;;			

		* )
			bot_print "$1" "ERROR : argumento 1 em função init_cookie é diferente das constantes"
			exit 1
		;;

		esac


	fi

	test "$1" = "--verbose"  && echo -n " [OK]"

    	#wget  -qO  "null_temp/web_mdan_connect" --limit-rate=32k --save-cookies "cookie/mdan.cookie" --post-data 'username='$ACCOUNT'&password='$PASSWD'' "http://bt.mdan.org/takelogin.php" 


	
}



feed_check(){


	for LINE_ in $(seq $(grep '^[^#/]' Database/database.db | wc -l))
	do 
		#chaves=(["MODE"]=0 ["TRACKER"]=1 ["TYPE"]=2 ["NAME"]=3 ["DAY"]=4 ["HOUR"]=5 ["DATABASE"]=6 ["COOKIE"]=7 ["LINK"]=8  ["EPISODIO"]=9 ["ID"]=10)
		#bot_print "$1" "LINHA:$LINE_;INDICE:$INDICE_TRACKER_CONF;INDICE_TRACKER_CHAVE:${INDICE_TRACKER_CHAVE['DAY']}"
		#sleep 2
		#exit 0

		local DAY="${TRACKERS_CONF_[$(($(($LINE_        - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['DAY']}))]}"
		test "$DAY" != "NO" && test "$(date '+%a')" != "$DAY" -a "$(date '+%A')" != "$DAY" && continue

		local HOUR="${TRACKERS_CONF_[$(($(($LINE_       - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['HOUR']}))]}"

		test "$HOUR" != "NO" && test "$(date '+%H')" -lt "$HOUR" && continue

		#bot_print "$1" " LINE is :$LINE_  ||  hnn : ${TRACKERS_CONF_[$(($(($LINE_ - 1))*$INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['LINK']}))]}"
		#sleep 2
		#bot_print "$1" "LINE_ is:$LINE_ || INDICE_TRACKER_CHAVE is : ${INDICE_TRACKER_CHAVE['LINK']} || INDICE_TRACKER_CONF : $INDICE_TRACKER_CONF || SOMA : $(($LINE_*$INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['LINK']})) "
		#sleep 3
		#bot_print "$1" "${TRACKERS_CONF_["$(($LINE_*$INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['LINK']}))"]}"
		#sleep 4
		
		local LINK="${TRACKERS_CONF_[$(($(($LINE_       - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['LINK']}))]}"
	      	local TRACKER="${TRACKERS_CONF_[$(($(($LINE_    - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['TRACKER']}))]}"	
	       	local COOKIE="${TRACKERS_CONF_[$(($(($LINE_     - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['COOKIE']}))]}"
		local MODE="${TRACKERS_CONF_[$(($(($LINE_       - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['MODE']}))]}"
		local TYPE="${TRACKERS_CONF_[$(($(($LINE_       - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['TYPE']}))]}"
		local NAME="${TRACKERS_CONF_[$(($(($LINE_      - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['NAME']}))]}"
		local DB_RELEASE="${TRACKERS_CONF_[$(($(($LINE_ - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['DATABASE']}))]}"
		local ID="$(grep '^ID=' $(echo Database/$DB_RELEASE | sed 's/ //') | cut -d = -f 2 | cut -d \# -f -1 | cut -d \; -f -1)"
		local EPISODIO="$(grep '^EXPECT_EPI=' $(echo Database/$DB_RELEASE | sed 's/ //') | cut -d = -f 2 | cut -d \# -f -1 | cut -d \; -f -1)"
		#bot_print "$1" "LINE_ is:$LINE_ || INDICE_TRACKER_CHAVE is : ${INDICE_TRACKER_CHAVE['LINK']} ||  INDICE_TRACKER_CONF : $INDICE_TRACKER_CONF  || TOT : $((${INDICE_TRACKER_CHAVE['LINK']} + $(($LINE_ -1 ))*$INDICE_TRACKER_CONF)) || PRINT : ${TRACKERS_CONF_[$(($(($LINE_       - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['LINK']}))]}"
		#bot_print "$1" "MODE:$MODE TRACKER:$TRACKER TYPE:$TYPE NAME:$NAME; DAY:$DAY HOUR:$HOUR DATABASE:$DB_RELEASE COOKIE:$COOKIE LINK:$LINK EPI:$EPISODIO ID:$ID"
		#read b
		#continue
		
		#continue

		#feed.xml contém a última atualização do feed.
		TIME_FEED_CHECK=$(date +%H:%M:%S)
		case  "$MODE" in

			"_FEED_" )
				

				case "$COOKIE" in
				
					"YES" )
						curl --silent -o 'patch_feed/feed_check_'"$TRACKER"'.xml' --limit-rate 10k --cookie 'cookie/'"$TRACKER"'.cookie' "$LINK"
						test ! -f 'patch_feed/feed_check_'"$TRACKER"'.xml' && \
						wget -qO 'patch_feed/feed_check_'"$TRACKER"'.xml' --limit-rate=10k --load-cookies 'cookie/'"$TRACKER"'.cookie' "$LINK"

						if test -f 'patch_feed/feed_'"$TRACKER"'.xml'
						then
							if test $(diff 'patch_feed/feed_check_'"$TRACKER"'.xml' 'patch_feed/feed_'"$TRACKER"'.xml'  | wc -l) -le $feed_lenght_min
							then
								continue
							else

								if test "$1" = "--debug"
								then
									echo -e "-----------------------------------------------\n\n"
									echo -e "Filtrando feed.xml .......\n"
									echo -e "-----------------------------------------------\n\n"
								fi
								mv 'patch_feed/feed_check_'"$TRACKER"'.xml'  'patch_feed/feed_'"$TRACKER"'.xml'
								###############################
								# FILTER
								filters_feed "$1" "$TRACKER"
								###############################
							
							fi
						else
							 bot_print "$1" "arquivo "$TRACKER".xml não encontrado, irei mover check para a origem"
							mv 'patch_feed/feed_check_'"$TRACKER"'.xml'  'patch_feed/feed_'"$TRACKER"'.xml'
							###############################
							# FILTER
							filters_feed "$1" "$TRACKER"
							###############################
							
						fi
						
					;;	
					"NO"  )
						bot_print "$1" "WARNING : feed sem cookie não foi implementado"
						exit 1
						#NÃO IMPLEMENTADO
					;;
					
					* )
	    					bot_print "$1" "ERROR: in COOKIE : cookie diferente de NO ou Yes"
						exit 1
					;;
				esac
				;;
			"_LINK_" )

				local status=$(curl -s --head "$(echo $LINK | sed 's/#EPKNIN/'"$EPISODIO"'/')" | head -n 1 | cut -d ' ' -f 2)
				test $status -ne $headstatus_ok && continue

			;;
		esac
		
		#----------------------------------------------------------------------------------------------------------------
		#wget -qO "patch_feed/feed.xml" --limit-rate=10k --load-cookies "cookie/mdan.cookie" "http://bt.mdan.org/rss.php?feedtype=download&timezone=-3&showrows=10&categories=1"

		#curl --silent -o "patch_feed/feed_check_"$TRACKER".xml" --limit-rate 10k --cookie "cookie/"$TRACKER".cookie" "http://bt.mdan.org/rss.php?feedtype=download&timezone=-3&showrows=10&categories=1"
	
	
	#FIM
		#Início do código antigo e obsoleto
		while :
	    	do
			#$1 = Tracker
			#$2 = Número do Episódio
			#$3 = Nome da mídia

			
			test "$TYPE" = "Private" -o "$TYPE" = "private" && filters_episodio "$1" "$TRACKER" "$EPISODIO" "$NAME"


			#test $RELEASED -gt 0 -a $RELEASED -le 9 &&
			    #RELEASED_OCT="0$RELEASED" ||
			   # RELEASED_OCT="_KNIN_"
			#Episódio a procura

			#grep "$NAME_.\($RELEASED\|$RELEASED_OCT\)" null_temp/LINK_RELEASE > null_temp/LINK_TOR

			test "$1" = "--debug"  && echo -ne "Verificando nova atualização ..."

			if test  "$(cat null_temp/LINK_TOR)"

			then

			  
				bot_print "$1" "Feed encontrado : $(cat null_temp/LINK_TOR | cut -d = -f 3)"
			   
			    
			    if test "$1" = "--debug"
			    then
				 echo -ne "sucessed!\n"
				 echo -e "-----------------------------------------------\n"
				 echo -e "[UPDATE]----------------K-N-i-N----------------[NEW]"
				 echo -ne "Midia              : $(echo $NAME |sed 's/[._]/ /g')\n"
				 echo -ne "Episódio: $EPISODIO\n"
				 echo -ne "Name File torrent : $(cat null_temp/LINK_TOR | cut -d = -f 3 | sed 's/torrent.*/torrent/')\n"
				 echo -ne "Time : $TIME_FEED_CHECK\n"
				 echo -ne "Iniciando Download .."
				 sleep 4
			    fi
		
			    torrent_file_get "$TYPE" "$TRACKER"
			    
		
			    test "$1" = "--debug"  && { 
				echo -ne "completado!\n"
				echo -e "[UPDATE]----------------K-N-i-N----------------[NEW]" 
				}

			    sleep 2

			    cp $(echo Database/$DB_RELEASE | sed 's/ //') $(echo Database/$DB_RELEASE | sed 's/ //')~


			    cat $(echo Database/$DB_RELEASE | sed 's/ //') | sed "s/EXPECT_EPI=$EPISODIO/EXPECT_EPI=$(($EPISODIO+1))/g ; s/ID=$ID/ID=$(($ID+1))/g" > null_temp/TEMP_DB

			    echo -ne "TOR>$(($ID)):DIA>$(date +%D):TIME>$TIME_FEED_CHECK:NAME>$(cat null_temp/LINK_TOR | cut -d = -f 3 | sed 's/$//')
		#-----------------------------------------------------\n" >> null_temp/TEMP_DB

			    mv null_temp/TEMP_DB $(echo Database/$DB_RELEASE | sed 's/ //')
			    EPISODIO=$(($EPISODIO+1))
			    ID=$(($ID +1))
			    UPDATE_FEED=$(($UPDATE_FEED+1))

			else #[ "$(cat null_temp/LINK_TOR)" ] && 
		
			    if test "$1" = "--debug"
			    then 
				echo -ne "nada novo ..!\n"
				echo -e "-----------------------------------------------\n\n"
				echo -e "[UPDATE]----------------K-N-i-N----------------[NOTHING]"
				echo -ne "Midia              : $(echo $NAME |sed 's/[._]/ /g')\n"            
				echo -ne "Episódio esperado  : $EPISODIO\n"
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

	conf_get "$1"


	bot_print "$1" " lista de trackers com cookie : ${#LIST_TRACKER_COOKIE[*]}"
	sleep 2
	for LINE_ in $(seq ${#LIST_TRACKER_COOKIE[*]})
	do
		init_cookie "$1" "${LIST_TRACKER_COOKIE["$(($LINE_ - 1))"]}"
	done

	while :
	do

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

		bot_print "$1" "Init Update ...."
		
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