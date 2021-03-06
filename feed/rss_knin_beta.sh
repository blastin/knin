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
#------07/NOV/12:> Analise de erros concluido.
#---------------: Limpeza e atualização
#---------------: Database e configuração agora pode ser atualizada sem necessidade de reiniciar o programa
#------08/NOV/12:> Limpeza e atualização
#------10/NOV/12:> Limpeza e atualização
#------11/NOV/12:> Error na função torrent_get foi fixado
#---------------:> Limpeza e atualização
#------15/NOV/12:> BUG em função torrent_get resolvido
#---------------:> Atualização e limpeza
# INFO        :
# -- -- [ "$1" -eq 1 ] : debug  < mod  echo -> stdout [screen] 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
declare -rA INDICE_TRACKER_CHAVE=(["MODE"]=0 ["TRACKER"]=1 ["TYPE"]=2 ["NAME"]=3 ["CATEGORIA"]=4 ["DAY"]=5 ["HOUR"]=6 ["DATABASE"]=7 ["COOKIE"]=8 ["LINK"]=9)
declare -r  INDICE_TRACKER_CONF="${#INDICE_TRACKER_CHAVE[*]}"
declare -A  TRACKER_CONF_ 
declare -A  LIST_FILTER_FEED
declare -r  date_time=$(date +%H:%M:%S)
declare -r  headstatus_ok=200
declare -r  feed_lenght_min=8 #valor mínimo de linhas  a checar em diff

declare     ACCOUNT_MDAN="$(grep '^ACCOUNT' conf/conf.script | cut -d = -f 2)"
declare     PASSWORD_MDAN="$(grep '^PASSWD'  conf/conf.script  | cut -d = -f 2)"
declare     TIME_UPDATE="$(grep '^TIME_UPDATE' conf/conf.script | cut -d = -f 2)"
declare     TIME_SYSTEM="$(grep '^TIME_SYSTEM' conf/conf.script | cut -d = -f 2)"
declare     TIME_NAME="$(grep '^TIME_NAME' conf/conf.script | cut -d = -f 2)"
declare	    SLOW_BOT_TIME_UPDATE="$(grep '^SLOW_BOT_TIME_UPDATE' conf/conf.script | cut -d = -f 2)"
declare     TIME_UPDATE_DATABASE="$(grep '^TIME_DATABASE_UPDATE' conf/conf.script | cut -d = -f 2)"
declare     TIME_UPDATE_CONF="$(grep '^TIME_CONF_SCRIPT_UPDATE' conf/conf.script | cut -d = -f 2)"
declare     SLOW_BOT_HOUR_CONF_SCRIPT="$(grep '^SLOW_BOT_HOUR=' conf/conf.script | cut -d = -f 2 | cut -d \# -f 1)"
declare     SLOW_BOT_DAY_CONF_SCRIPT="$(grep '^SLOW_BOT_DAY=' conf/conf.script | cut -d = -f 2 | cut -d \# -f 1)"

declare     DATABASE_TOTAL
declare     UPDATE_FEED=0
declare     SLOW_BOT_HOUR
declare     SLOW_BOT_DAY
declare     LIST_TRACKER
declare     LIST_TRACKER_COOKIE
declare     TRACKER_TIME_FLAG=1
declare     TIME_UPDATE_NEXT_BEFORE_SLEEP=0
declare     BUFF_TIME_EXCESS=0
declare     NEXT_TIME_UPDATE_DATABASE
declare     NEXT_TIME_CONF_SCRIPT_UPDATE="$(date -d "$TIME_UPDATE_CONF" +'%H')"
declare     VAR_TEMP_GLOBAL


function init(){
	reset
	rm -rf null_temp conf/.backup/ cookie logs patch_feed
	mkdir null_temp conf/.backup/  cookie logs patch_feed
	local FLAG_VAR_TEMP=0
	local FLAG_VAR_TEMP_DAY=0
	local VAR_TEMP=" "
	local VAR_TEMP_DAY=" "
	
	local SLOW_BOT_COUNT_HOUR=0
	local SLOW_BOT_COUNT_DAY=0

	while :
	do
		VAR_TEMP="$(echo $SLOW_BOT_HOUR_CONF_SCRIPT | cut -d : -f "$(($SLOW_BOT_COUNT_HOUR+1))")"
		

		if test -n  "$VAR_TEMP"
		then		
			SLOW_BOT_HOUR["$SLOW_BOT_COUNT_HOUR"]="$VAR_TEMP"
			SLOW_BOT_COUNT_HOUR=$(($SLOW_BOT_COUNT_HOUR+1))
		
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

	

}

function bot_print(){

	if test -n "$1"
	then
		if test -n "$2" -a "$1" = "--verbose"
		then
			echo -ne '\033[G'
		    	echo -ne "\033[11C"
		    	echo -ne "\033[0K"

			slow_bot_check; if test $? -eq 1
			then
				echo -n "MODE[NORM] DB[$DATABASE_TOTAL] LTC[${#LIST_TRACKER_COOKIE[*]}] UPD[$TIME_UPDATE_DATABASE] UPC[$TIME_UPDATE_CONF] UPDATE[$TIME_UPDATE $TIME_NAME] Notice[$UPDATE_FEED] <> "$2"   "
			else
				echo -n "MODE[SLOW] DB[$DATABASE_TOTAL] LTC[${#LIST_TRACKER_COOKIE[*]}] UPD[$TIME_UPDATE_DATABASE] UPC[$TIME_UPDATE_CONF] UPDATE[$SLOW_BOT_TIME_UPDATE $TIME_NAME] Notice[$UPDATE_FEED] <> "$2"   "
			fi
			test -z "$3" && sleep 2
			

		elif test "$1" != "--quiet"
		then
			echo "$2"
			test -z "$3" && sleep 2
		fi

	fi


}

function filters_feed(){ #todos filters ficaram aqui até resolver conf/feed.filters

	#$2 = Tracker
	#$3 = Número do Episódio
	#$4 = Nome da mídia

	if test -n "$2"
	then
		
		case "$2" in
	
		"MDAN" )

			if test "$3" -gt 0 -a "$3" -le 9
			then 
		    		local EPI="0$3"
			fi

			#'patch_feed/feed_'"$TRACKER"'.xml'
			grep '<link>.*</link>' 'patch_feed/feed_'"$2"'.'"$4"'.xml' | \
			sed '1,2 d ; s/<link>//g ; s/<\/link>//g ; s/amp;//g ; s/          //g' | \
			grep "$4.\("$3"\|"$EPI" \)" > null_temp/LINK_TOR


		;;

		"SUPERSEEDS")


			if test -n "$4" #argumento 4 é o nome da midia
			then
				local LINE_TITLE="$(grep -ni "<title>$4" 'patch_feed/feed_'$2'.'$4'.xml')"
				local LINE="$(echo $LINE_TITLE | cut -d \: -f 1 | head -n 1)"
				local TITLE="$(echo $LINE_TITLE| cut -d \: -f 2 | head -n 1)"
				local MIDIA_EPISODIO="$(echo $TITLE | sed 's/\.\*/.'"$3"'\ \*/')"
				
				if test -n "$MIDIA_EPISODIO"
				then
					echo "entrei"
					exit 0
					while test "$TRY_LINK_LINE" -le 99
					do
						TRY_LINK_LINE="$(head -n "$(($LINE_TITLE + 1))" 'patch_feed/feed_'"$2"'.'"$4"'.xml' | tail -n 1 | sed 's/<link>// ; s/<\/link>//' | grep 'http://superseeds.org/download')"
						if test -n "$TRY_LINK_LINE"
						then

							echo "$TRY_LINK_LINE" > null_temp/LINK_TOR
							VAR_TEMP_GLOBAL="$MIDIA_EPISODIO"
							break

						fi
						TRY_LINK_LINE=$(($TRY_LINK_LINE + 1))			
					done
				fi
			fi

		;;
	
		esac
	else
		bot_print "$1" "ERROR: argumento não especificado para filters_ function"
		exit 1
	fi

}


function database_get(){

	local TRACKER_ADD=0

	cp conf/conf.script conf/.backup/conf.script.backup
	DATABASE_TOTAL="$(grep '^[^#/]' Database/database.db | wc -l)"
	for LINE_ in $(seq $DATABASE_TOTAL)
	do
		if test "$LINE_" -gt "$INDICE_TRACKER_CONF"
		then
			bot_print "$1" "ERROR: TRACKER_CONF estou limite da variável INDICE_TRACKER_CONF em função database_get"
			exit 1
		fi


		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 2 | cut -d : -f 2)"
		TRACKER_ADD=$(($TRACKER_ADD+1))		
		#MODE FEED ou link

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 3 | cut -d : -f 2)"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#nome do tracker

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 4 | cut -d : -f 2)"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#Tipo do tracker ; Público ou Privado

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 5 | cut -d : -f 2)"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#Nome do anime

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 6 | cut -d : -f 2)"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#Categoria

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 7 | cut -d : -f 2)"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#Dia específico

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 8 | cut -d : -f 2)"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#Horário de início específico

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 9 | cut -d : -f 2)"	
		local DB_TEMP_INDICE="$TRACKER_ADD"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#Database do anime

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 10 | cut -d : -f 2)"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#cookie

		TRACKERS_CONF_["$TRACKER_ADD"]="$(grep "^$LINE_" Database/database.db | cut -d \; -f 11 | cut -d : -f 2-)"
		TRACKER_ADD=$(($TRACKER_ADD+1))
		#link

		if test "${TRACKERS_CONF_[$(($(($LINE_-1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['COOKIE']}))]}" = "YES"
		then
			if test "$LINE_" -eq 1
			then
				LIST_TRACKER_COOKIE["$(($LINE_-1))"]="${TRACKERS_CONF_[$(($(($LINE_ - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['TRACKER']}))]}"
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

	test "$1" != "--quiet" && echo -e "\n"
	bot_print "$1" "Banco de dados foi armazenado"
	
	
}




function torrent_file_get(){
#
	if test -n "$1" -a -n "$2"
	then
		declare MODE
		declare name_torrent

		case "$1" in 

		"Private")
			
			case "$2" in

			"MDAN" ) 

				MODE="--load-cookies cookie/$2.cookie"
				name_torrent="$(cat null_temp/LINK_TOR | cut -d \= -f 3 | sed 's/\.torrent.*/\.torrent/')"

				#wget --limit-rate=25k --load-cookies 'cookie/'"$2"'.cookie' --directory-prefix=./rtorrent_watch/ -qo logs/logfile -i null_temp/LINK_TOR
			;;	

			"SUPERSEEDS" )

				#wget --limit-rate=25k  -qo logs/logfile -i null_temp/LINK_TOR
			;;		
			* )
				bot_print "$1" "ERROR : argumento 2 em função torrent_file_get é diferente das constantes"
				exit 1
			;;
			esac
			
		;;
		"Public")
			
			case "$2" in

			"Project" )

				#wget --limit-rate=25k -qo logs/logfile -i null_temp/LINK_TOR
			;;

			* )
				bot_print "$1" "ERROR : argumento 2 em função torrent_file_get é diferente das constantes"
				exit 1
			;;
			esac

			
		;;	
		esac
			
			if test -n "$name_torrent"
			then
				wget --limit-rate=25k $MODE -O 'rtorrent_watch/'"$name_torrent"'' --quiet --output-file=logs/logfile --input-file=null_temp/LINK_TOR
			else 
				wget --limit-rate=25k $MODE --directory-prefix=rtorrent_watch/ --quiet --output-file=logs/logfile --input-file=null_temp/LINK_TOR
			fi

	else
		echo "ERROR : argumento 1 e 2 em função torrent_file_get não especificado"
		exit 1
	fi



}

function slow_bot_check(){

	if test "${#SLOW_BOT_DAY[*]}" -ne 0
	then
		for LINE_ in $(seq ${#SLOW_BOT_DAY[*]})
		do
			test "$(date '+%a')" = "${SLOW_BOT_DAY["$(($LINE_-1))"]}" -o "$(date '+%A')" = "${SLOW_BOT_DAY["$(($LINE_-1))"]}"  && return 0
		done

	fi

	if test "${#SLOW_BOT_HOUR[*]}" -ne 0
	then
		for LINE_ in $(seq ${#SLOW_BOT_HOUR[*]})
		do
			test "$(date '+%H')" -eq "${SLOW_BOT_HOUR["$(($LINE_-1))"]}" && return 0
		done
	fi
	
	return 1

}




function cookie_(){ 

#$1 debug ou verbose

	bot_print "$1" "Salvando cookie"
        
	if test -n "$2"
	then
		case "$2" in

		"MDAN" ) 
			
			wget  -qO  "null_temp/web_mdan_connect" --limit-rate=32k --save-cookies "cookie/MDAN.cookie" --post-data 'username='"$ACCOUNT_MDAN"'&password='"$PASSWORD_MDAN"'' "http://bt.mdan.org/takelogin.php"
		;;			

		* )
			bot_print "$1" "ERROR : argumento 1 em função cookie_ é diferente das constantes"
			exit 1
		;;

		esac

	fi
	
}



function bot_check(){


	if test "$(date '+%H')" -ge "$NEXT_TIME_UPDATE_DATABASE" #Atualização do banco de dados
	then

		local FLAG_DATABASE_UPDATE="$(grep '^FLAG_DATABASE_UPDATE' conf/file_var.script | cut -d \= -f 2)"
		if test "$FLAG_DATABASE_UPDATE" -eq 1
		then
			bot_print "$1" "Atualizado informações do banco de dados"
			database_get "$1"	

			for LINE_ in $(seq ${#LIST_TRACKER_COOKIE[*]})
			do
				cookie_ "$1" "${LIST_TRACKER_COOKIE["$(($LINE_ - 1))"]}"
			done
		
			cat conf/file_var.script | sed 's/FLAG_DATABASE_UPDATE=1/FLAG_DATABASE_UPDATE=0/' | tee null_temp/file_var.temp  > /dev/null
			mv null_temp/file_var.temp conf/file_var.script

			
			bot_print "$1" "banco de dados foi atualizado com sucesso !"

		fi
		NEXT_TIME_UPDATE_DATABASE="$(date -d "$TIME_UPDATE_DATABASE" +'%H')"
	fi
	
	if test "$(date '+%H')" -ge "$NEXT_TIME_CONF_SCRIPT_UPDATE" #Atualização do arquivo conf.script
	then

		local FLAG_CONF_SCRIPT_UPDATE="$(grep '^FLAG_CONF_SCRIPT_UPDATE' conf/file_var.script | cut -d \= -f 2)"
		if test "$FLAG_CONF_SCRIPT_UPDATE" -eq 1
		then
			bot_print "$1" "Atualizado informações do conf.script"
			
			ACCOUNT_MDAN="$(grep '^ACCOUNT' conf/conf.script | cut -d = -f 2)"
			PASSWORD_MDAN="$(grep '^PASSWD'  conf/conf.script  | cut -d = -f 2)"
			TIME_UPDATE="$(grep '^TIME_UPDATE' conf/conf.script | cut -d = -f 2)"
			TIME_SYSTEM="$(grep '^TIME_SYSTEM' conf/conf.script | cut -d = -f 2)"
			TIME_NAME="$(grep '^TIME_NAME' conf/conf.script | cut -d = -f 2)"
			SLOW_BOT_TIME_UPDATE="$(grep '^SLOW_BOT_TIME_UPDATE' conf/conf.script | cut -d = -f 2)"
			TIME_UPDATE_DATABASE="$(grep '^TIME_DATABASE_UPDATE' conf/conf.script | cut -d = -f 2)"
			TIME_UPDATE_CONF="$(grep '^TIME_CONF_SCRIPT_UPDATE' conf/conf.script | cut -d = -f 2)"
			SLOW_BOT_HOUR_CONF_SCRIPT="$(grep '^SLOW_BOT_HOUR=' conf/conf.script | cut -d = -f 2 | cut -d \# -f 1)"
			SLOW_BOT_DAY_CONF_SCRIPT="$(grep '^SLOW_BOT_DAY=' conf/conf.script | cut -d = -f 2 | cut -d \# -f 1)"

			cat conf/file_var.script | sed 's/FLAG_CONF_SCRIPT_UPDATE=1/FLAG_CONF_SCRIPT_UPDATE=0/' | tee null_temp/file_var.temp  > /dev/null
			mv null_temp/file_var.temp conf/file_var.script 

			
			bot_print "$1" "conf.script foi atualizado com sucesso!"
		fi
		NEXT_TIME_CONF_SCRIPT_UPDATE="$(date -d "$TIME_UPDATE_CONF" +'%H')"

	fi

	for LINE_ in $(seq $(grep '^[^#/]' Database/database.db | wc -l))
	do 
		
		local DAY="${TRACKERS_CONF_[$(($(($LINE_        - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['DAY']}))]}"
		test "$DAY" != "NO" && test "$(date '+%a')" != "$DAY" -a "$(date '+%A')" != "$DAY" && continue

		local HOUR="${TRACKERS_CONF_[$(($(($LINE_       - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['HOUR']}))]}"
		test "$HOUR" != "NO" && test "$(date '+%H')" -lt "$HOUR" && continue

		local CATEGORIA="${TRACKERS_CONF_[$(($(($LINE_  - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['CATEGORIA']}))]}"
		local LINK="${TRACKERS_CONF_[$(($(($LINE_       - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['LINK']}))]}"
	      	local TRACKER="${TRACKERS_CONF_[$(($(($LINE_    - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['TRACKER']}))]}"	
	       	local COOKIE="${TRACKERS_CONF_[$(($(($LINE_     - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['COOKIE']}))]}"
		local MODE="${TRACKERS_CONF_[$(($(($LINE_       - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['MODE']}))]}"
		local TYPE="${TRACKERS_CONF_[$(($(($LINE_       - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['TYPE']}))]}"
		local NAME="${TRACKERS_CONF_[$(($(($LINE_       - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['NAME']}))]}"
		local DATABASE="${TRACKERS_CONF_[$(($(($LINE_   - 1))* $INDICE_TRACKER_CONF + ${INDICE_TRACKER_CHAVE['DATABASE']}))]}"
		local ID="$(grep '^ID=' $(echo Database/$DATABASE | sed 's/ //') | cut -d = -f 2 | cut -d \# -f -1 | cut -d \; -f -1)"
		local EPISODIO="$(grep '^EXPECT_EPI=' $(echo Database/$DATABASE | sed 's/ //') | cut -d = -f 2 | cut -d \# -f -1 | cut -d \; -f -1)"
		TIME_FEED_CHECK=$(date +%H:%M:%S) #feed.xml contém a última atualização do feed.

		case  "$MODE" in

			"_FEED_" )
				
				case "$COOKIE" in


				"YES" )
					wget -qO 'patch_feed/feed_check_'"$TRACKER"'.'"$NAME"'.xml' --limit-rate=10k --load-cookies 'cookie/'"$TRACKER"'.cookie' "$LINK"
					;;


				"NO" )

					wget -qO 'patch_feed/feed_check_'"$TRACKER"'.'"$NAME"'.xml' --limit-rate=10k "$LINK"
					;;

				* )

					bot_print "$1" "ERROR: in COOKIE : cookie diferente de NO ou Yes"
					exit 1
					;;
				esac


				if test -f 'patch_feed/feed_'"$TRACKER"'.'"$NAME"'.xml'
				then
					if test $(diff 'patch_feed/feed_check_'"$TRACKER"'.'"$NAME"'.xml' 'patch_feed/feed_'"$TRACKER"'.'"$NAME"'.xml'  | wc -l) -le $feed_lenght_min
					then
						rm 'patch_feed/feed_check_'"$TRACKER"'.'"$NAME"'.xml'
						continue
					else
						mv 'patch_feed/feed_check_'"$TRACKER"'.'"$NAME"'.xml'  'patch_feed/feed_'"$TRACKER"'.'"$NAME"'.xml'
					fi
					
				else
					bot_print "$1" "Gerando arquivo "$TRACKER"."$NAME".xml"
					mv 'patch_feed/feed_check_'"$TRACKER"'.'"$NAME"'.xml'  'patch_feed/feed_'"$TRACKER"'.'"$NAME"'.xml'
					
				fi

			;;

		esac
		
		while :
	    	do
			#$1 = DEBUG,VERBOSE,QUIET
			#$2 = Tracker
			#$3 = Número do Episódio
			#$4 = Nome da mídia
			
			if test "$TYPE" = "Private" -o "$TYPE" = "private"
			then
				bot_print "$1" "Verificando disponibilidade de $NAME $EPISODIO"			
				filters_feed "$1" "$TRACKER" "$EPISODIO" "$NAME"

			elif test "$MODE" = "_LINK_"
			then
				bot_print "$1" "Verificando disponibilidade de $NAME $EPISODIO"
				LINK_EPI="$(echo $LINK | sed 's/#EPKNIN/'"$EPISODIO"'/ ')"
				status="$(curl -s --head "$LINK_EPI" | head -n 1 | cut -d ' ' -f 2)"
				if test $status -ne $headstatus_ok
				then
					bot_print "$1" "$NAME $EPISODIO não disponível."
					break
				fi
				echo $LINK_EPI > null_temp/LINK_TOR
			fi

			if test  "$(cat null_temp/LINK_TOR)"
			then

				bot_print "$1" "$NAME $EPISODIO foi encontrado com sucesso"
			   		
				torrent_file_get "$TYPE" "$TRACKER"
			    	   
				if test "$CATEGORIA" = "NORMAL"
				then
					cat $(echo Database/$DATABASE | sed 's/ //') | sed "s/EXPECT_EPI=$EPISODIO/EXPECT_EPI=$(($EPISODIO+1))/g ; s/ID=$ID/ID=$(($ID+1))/g" > null_temp/TEMP_DB
			    		echo -ne "TOR>$ID:DIA>$(date +%D):TIME>$TIME_FEED_CHECK:NAME>$NAME [$EPISODIO]\n" >> null_temp/TEMP_DB
					EPISODIO=$(($EPISODIO+1))

				elif test "$CATEGORIA" = "SERIE"
				then
					if test "$EPISODIO" -le 9
					then
						EPISODIO="$(echo $EPISODIO | sed 's/E.*/E0'"$(($(echo $EPISODIO | cut -d E -f 2) + 1))"'/')"
					else
						EPISODIO="$(echo $EPISODIO | sed 's/E.*/E'"$(($(echo $EPISODIO | cut -d E -f 2) + 1))"'/')"
					fi

					cat $(echo Database/$DATABASE | sed 's/ //') | sed "s/EXPECT_EPI=.*/EXPECT_EPI=$EPISODIO/g ; s/ID=$ID/ID=$(($ID+1))/g" > null_temp/TEMP_DB
					
			    		echo -ne "\nTOR>$ID:DIA>$(date +%D):TIME>$TIME_FEED_CHECK:NAME>$VAR_TEMP_GLOBAL\n" >> null_temp/TEMP_DB
					VAR_TEMP_GLOBAL=0

				fi
	
			    	mv null_temp/TEMP_DB $(echo Database/$DATABASE | sed 's/ //')	
			    	ID=$(($ID +1))
			    	UPDATE_FEED=$(($UPDATE_FEED+1))

		    	else
				bot_print "$1" "$NAME $EPISODIO não disponível."
				break
			fi

		done #while :

	done #for LINE_ in $(seq $(cat Database/database.db | cut -d : -f 3 | wc -l))

}

function automatic_bot(){

	database_get "$1"
	NEXT_TIME_UPDATE_DATABASE="$(date -d "$TIME_UPDATE_DATABASE" +'%H')"

	for LINE_ in $(seq ${#LIST_TRACKER_COOKIE[*]})
	do
		cookie_ "$1" "${LIST_TRACKER_COOKIE["$(($LINE_ - 1))"]}"
	done

	while :
	do
		bot_check "$1"

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

			#Seguindo a regra de ser específicado  em conf/conf.script 
		    	TIME_UPDATE_NEXT=$(($TIME_UPDATE * $TIME_SYSTEM))
			bot_print "$1" "Próxima atualização <!> $(date -d "$TIME_UPDATE $TIME_NAME - $BUFF_TIME_EXCESS seconds" +%H:%M:%S)" "off sleep"

		else
		    	#Seguindo a regra de ser específicado  em conf/conf.script 
		    	TIME_UPDATE_NEXT=$(($SLOW_BOT_TIME_UPDATE * $TIME_SYSTEM)) 
			bot_print "$1" "Próxima atualização <!> $(date -d "$SLOW_BOT_TIME_UPDATE $TIME_NAME - $BUFF_TIME_EXCESS seconds" +%H:%M:%S)" "off sleep"
		fi


		#-------- ------------Sleep--------- ------------#
		sleep $(($TIME_UPDATE_NEXT - $BUFF_TIME_EXCESS)) #
		TIME_UPDATE_NEXT_BEFORE_SLEEP=$(date '+%s')        #
		#-------- ----------- KNiN --------- ------------#

		bot_print "$1" "Inicializando checagem de atualização !"
	done

}

################### INICIALIZAÇÃO #################
init $1


if test "$1" != "--quiet"
	then
	echo -e ".... Project KNiN   : Feed ....\n"
	echo -e ".... Bem Vindo - Blastin ....\n"
	echo -e "Horário de Início   : $date_time"
	echo -e "\n- - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - -\n"
	echo -e "TIME UPDATE NORMAL  : $TIME_UPDATE $TIME_NAME\n"
	echo -e "TIME UPDATE SLOW    : $SLOW_BOT_TIME_UPDATE $TIME_NAME\n"
	echo -e "TIME DATABASE UPDATE: $TIME_UPDATE_DATABASE\n"
	echo -e "TIME CONF UPDATE    : $TIME_UPDATE_CONF\n"
	if test "${#SLOW_BOT_HOUR[*]}" -ne 0
	then
		echo -ne "SLOW CPU            : "
		for LINE_ in $(seq ${#SLOW_BOT_HOUR[*]})
		do
			echo -ne "(${SLOW_BOT_HOUR["$(($LINE_-1))"]}:00)" 
		done
		echo -e "\n"
	fi
	if test "${#SLOW_BOT_DAY[*]}" -ne 0
	then
	    echo -ne "SLOW CPU DAY        : "
	    for LINE_ in $(seq ${#SLOW_BOT_DAY[*]})
	    do
	    	echo -ne "(${SLOW_BOT_DAY["$(($LINE_-1))"]})" 
	    done
	   
	fi
	echo -e "\n- - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - -\n"
 	
fi


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