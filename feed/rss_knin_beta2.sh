reset 

rm -rf null_temp patch_feed conf/.backup/ cookie logs conf/file_var.script 
mkdir null_temp conf/.backup/ patch_feed cookie logs

ACCOUNT=$(grep '^ACCOUNT' conf/conf.script | cut -d = -f 2)
PASSWD=$(grep '^PASSWD'  conf/conf.script  | cut -d = -f 2)
date_time=$(date +%H:%M:%S)
UPDATE_FEED=0

SLOW_BOT_INIT=$(grep '^SLOW_BOT_INIT' conf/conf.script | cut -d = -f 2)
SLOW_BOT_END=$(grep '^SLOW_BOT_END' conf/conf.script | cut -d = -f 2)


function_file_var_mod()
{
    [ "$1" -a "$2" ] && {
        cp conf/file_var.script conf/.backup/.file_var.script.backup

        cat conf/file_var.script | sed "s/^$1.*/$1$2/g" > conf/file_var.script    
 
    }
}


init_cookie(){ 

        if test "$1" = "--debug" 
        then
            echo -e "-----------------------------------------------\n\n"
            echo -e "Recebendo cookie .......\n"
            echo -e "-----------------------------------------------\n\n"
        
        elif test "$1" = "--verbose"
        then
            echo -ne '\033[G'
            echo -ne "\033[11C"
            echo -ne "\033[0K"
            if [ "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" ]
            then
                echo -n "[NORM] UPDATE : [0] | Salvando cookie:   "
            else
                echo -n "[SLOW] UPDATE : [0] | Salvando cookie:   "
            fi
        fi
        

    wget  -qO  "null_temp/web_mdan_connect" --limit-rate=32k --save-cookies "cookie/mdan.cookie" --post-data 'username='$ACCOUNT'&password='$PASSWD'' "http://bt.mdan.org/takelogin.php"

    #conecta-se ao web site , gerando o arquivo cookie
    test "$1" = "--verbose"  && echo -n " [OK]"
}

feed_check(){

    #----------------------------------------------------------------------------------------------------------------
    #FIXME : utilizar sistema avançado WGET para apenas checagem, economia de processo
    wget -qO "patch_feed/feed.xml" --limit-rate=10k --load-cookies "cookie/mdan.cookie" "http://bt.mdan.org/rss.php?feedtype=download&timezone=-3&showrows=10&categories=1"
    #----------------------------------------------------------------------------------------------------------------

    

    test "$1" = "--debug"  && {
        echo -e "-----------------------------------------------\n\n"
        echo -e "Filtrando feed.xml .......\n"
        echo -e "-----------------------------------------------\n\n"
        }
    #feed.xml contém a última atualização do feed.
    TIME_FEED_CHECK=$(date +%H:%M:%S)


    grep '<link>.*</link>' patch_feed/feed.xml  | 
    sed '1,2 d ; s/<link>//g ; s/<\/link>//g ; s/amp;//g ; s/          //g' | 
    grep "$(grep '^Anime' conf/conf.script |cut -d = -f 2 | sed 's/:/\\|/g ; s/$/\\)/g ; s/^/\\(/g')" > null_temp/LINK_RELEASE


    for LINE_ in $(seq $(grep '^[^#/]' Database/database.db | wc -l))
         do 
            if [ "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" ]
            then
                cp Database/database.db /var/www/feed/conf/Database/database.db
            fi
            NAME_="$(grep "^$LINE_" Database/database.db | cut -d : -f 2 | cut -d \; -f -1)"
            #Nome do anime

            DB_RELEASE="$(grep "^$LINE_" Database/database.db | cut -d : -f 3)"
            #Database do anime
            
            RELEASED="$(grep '^EXPECT_EPI=' $(echo Database/$DB_RELEASE | sed 's/ //') | cut -d = -f 2 | cut -d \# -f -1 | cut -d \; -f -1)"

            

            ID="$(grep '^ID=' $(echo Database/$DB_RELEASE | sed 's/ //') | cut -d = -f 2 | cut -d \# -f -1 | cut -d \; -f -1)"
            #ID a ser armazenado

        
            while :
            do
                test $RELEASED -gt 0 -a $RELEASED -le 9 &&
                    RELEASED_OCT="0$RELEASED" ||
                    RELEASED_OCT="_KNIN_"
                #Episódio a procura

                grep "$NAME_.\($RELEASED\|$RELEASED_OCT\)" null_temp/LINK_RELEASE > null_temp/LINK_TOR

                test "$1" = "--debug"  &&  { 
                    echo -ne "Verificando nova atualização ..."
                }

                [ "$(cat null_temp/LINK_TOR)" ] && 
                {
                    if test "$1" = "--verbose"
                    then
                        echo -ne '\033[G'
                        echo -ne "\033[11C"
                        echo -ne '\033[0K'

                        if [ "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" ]
                        then
                            echo -n "[NORM] UPDATE : [$UPDATE_FEED] | Feed encontrado : $(cat null_temp/LINK_TOR | cut -d = -f 3)"
                        else
                            echo -n "[SLOW] UPDATE : [$UPDATE_FEED] | Feed encontrado : $(cat null_temp/LINK_TOR | cut -d = -f 3)"
                        fi
                    fi
                    
                    test "$1" = "--debug"  && {
                         echo -ne "sucessed!\n"
                         echo -e "-----------------------------------------------\n"
                         echo -e "[UPDATE]----------------K-N-i-N----------------[NEW]"
                         echo -ne "Anime              : $(echo $NAME_ |sed 's/[._]/ /g')\n"
                         echo -ne "Episódio: $RELEASED\n"
                         echo -ne "Name File torrent : $(cat null_temp/LINK_TOR | cut -d = -f 3 | sed 's/torrent.*/torrent/')\n"
                         echo -ne "Time : $TIME_FEED_CHECK\n"
                         echo -ne "Iniciando Download .."
                         sleep 4
                    }

                    
                
                    wget --limit-rate=25k --load-cookies "cookie/mdan.cookie" -O "rtorrent_watch/$(cat null_temp/LINK_TOR | cut -d = -f 3 | sed 's/torrent.*/torrent/')"   -o logs/logfile -i null_temp/LINK_TOR
                
                    test "$1" = "--debug"  && { 
                        echo -ne "completado!\n"
                        echo -e "[UPDATE]----------------K-N-i-N----------------[NEW]" 
                        }

                    sleep 2

                    cp $(echo Database/$DB_RELEASE | sed 's/ //') $(echo Database/$DB_RELEASE | sed 's/ //')~


                    cat $(echo Database/$DB_RELEASE | sed 's/ //') | sed "s/EXPECT_EPI=$RELEASED/EXPECT_EPI=$(($RELEASED+1))/g ; s/ID=$ID/ID=$(($ID+1))/g" > null_temp/TEMP_DB

                    echo -ne "TOR>$(($ID)):DIA>$(date +%D):TIME>$TIME_FEED_CHECK:NAME>$(cat null_temp/LINK_TOR | cut -d = -f 3 | sed 's/$//')
#-----------------------------------------------------\n" >> null_temp/TEMP_DB

                    if [ "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" ]
                    then
                        sleep 2
                        grep '^TOR' null_temp/TEMP_DB > /var/www/feed/conf/$DB_RELEASE
                    fi

                    mv null_temp/TEMP_DB $(echo Database/$DB_RELEASE | sed 's/ //')
                    RELEASED=$(($RELEASED+1))
                    ID=$(($ID +1))
                    UPDATE_FEED=$(($UPDATE_FEED+1))

                }  || #[ "$(cat null_temp/LINK_TOR)" ] && 
                {
                    test "$1" = "--debug"  && { 
                        echo -ne "nada novo ..!\n"
                        echo -e "-----------------------------------------------\n\n"
                        echo -e "[UPDATE]----------------K-N-i-N----------------[NOTHING]"
                        echo -ne "Anime              : $(echo $NAME_ |sed 's/[._]/ /g')\n"            
                        echo -ne "Episódio esperado  : $RELEASED\n"
                        echo -ne "Horário de checagem: $TIME_FEED_CHECK\n"
                        echo -e "[UPDATE]----------------K-N-i-N----------------[NOTHING]\n\n"
                        sleep 4
                    }

                    break # While
        
                }
    
        
        done #while :

    done #for LINE_ in $(seq $(cat Database/database.db | cut -d : -f 3 | wc -l))
    
}

automatic_bot(){

    #
    TRACKER_TIME_FLAG=1
    #

    TIME_UPDATE_NEXT_BEFORE_FEED_CHECK=0
    TIME_UPDATE_NEXT_BEFORE_SLEEP=0
    BUFF_TIME_EXCESS=0

    TIME_UPDATE=$(grep '^TIME_UPDATE' conf/conf.script | cut -d = -f 2)
    TIME_SYSTEM=$(grep '^TIME_SYSTEM' conf/conf.script | cut -d = -f 2)
    TIME_NAME=$(grep '^TIME_NAME' conf/conf.script | cut -d = -f 2)

    SLOW_BOT_TIME_UPDATE=$(grep '^SLOW_BOT_TIME_UPDATE' conf/conf.script | cut -d = -f 2)

    TRACKER_UPDATE=$(grep '^TRACKER_UPDATE' conf/conf.script | cut -d = -f 2)

    
    if test "$1" != "--quiet"
    then
	    echo -e "\n-----------------------------------------------\n\n"
	    echo -e ".... Project KNiN : Feed ....\n"
	    echo -e ".... Bem Vindo - Blastin ....\n"
	    echo -e "Horário de Início : $date_time"
	    echo -e "\n"
	    echo -e "Database's Quantidade: $(grep '^[^#/]' Database/database.db | wc -l)\n"
	    echo -e "\n-----------------------------------------------\n\n"

	    echo -e "TIME UPDATE    : $TIME_UPDATE $TIME_NAME\n"
	    echo -e "SLOW CPU       : $SLOW_BOT_TIME_UPDATE $TIME_NAME [$SLOW_BOT_INIT:00 to $SLOW_BOT_END:00]\n"
	    echo -e "TRACKER_UPDATE : $TRACKER_UPDATE\n"


	    echo -e "\n-----------------------------------------------\n\n"
    fi

    init_cookie "$1"

    function_file_var_mod "DAY=" "$(date '+%d')"

    while :
    do

	#$if test "$(date '+%H')" -eq "00" -a "$DAY_UNLOCK" -eq 1
	#then
	#	function_file_var_mod "DAY=" "$(date -d '1 days' +'%d')"
	#	DAY_UNLOCK=0
	#else
	#	DAY_UNLOCK=1
	#fi
 
	feed_check "$1"

        TIME_UPDATE_NEXT_BEFORE_FEED_CHECK=$(date +%s)
        
        #--------------------------------------------------------------------------------------
        #TODO:BUFF_TIME : retira o excesso de segundos em feed_check
        if test $TIME_UPDATE_NEXT_BEFORE_FEED_CHECK -ne 0 -a $TIME_UPDATE_NEXT_BEFORE_SLEEP -ne 0
        then
            BUFF_TIME_EXCESS=`expr $TIME_UPDATE_NEXT_BEFORE_FEED_CHECK \- $TIME_UPDATE_NEXT_BEFORE_SLEEP`
        fi
        #--------------------------------------------------------------------------------------

        
        if [ "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" ]
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
                echo -n "[SLOW] UPDATE : [$UPDATE_FEED] | Next Update  : $(date -d "$TIME_UPDATE $TIME_NAME - $BUFF_TIME_EXCESS seconds" +%H:%M:%S)"
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

            echo -ne '\033[G'
            echo -ne "\033[11C"
            echo -ne '\033[0K'
        
            if [ "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" ]
            then

                echo -n "[NORM] UPDATE : [$UPDATE_FEED] | Init Update ....    "
            else

                echo -n "[SLOW] UPDATE : [$UPDATE_FEED] | Init Update ....    "
            fi
        fi
    done

}

################### INICIALIZAÇÃO #################
bash conf/init_file_var_beta2.sh

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
