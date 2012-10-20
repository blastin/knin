#!/bin/bash
#                                                     .__   __.  __  .__   __.  __  ___ 
#                                                     |  \ |  | |  | |  \ |  | |  |/  / 
#                                                     |   \|  | |  | |   \|  | |  '  /  
#                                                     |  . `  | |  | |  . `  | |    <   
#                                                     |  |\   | |  | |  |\   | |  .  \  
#                                                     |__| \__| |__| |__| \__| |__|\__\' powered debian.
#
#                               Feed<rtorrent 0.8.6/0.12.6>
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
#---------------:> Problemas são com horários em numeral 'OCT'
#---------------:> Resolvido
#------06/MAR/12:> Adicionado funções para retomada dos horários de TRACKER_TIME  e  COOKIE_TIME
#---------------:> Resolvido wget com save--cookie em tracker check
#---------------:> init_bot retirado, versão obsoleta ....
#------07/MAR/12:> Problema com condicional de fluxo  em linha 318
#test "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END"
##--------------:>Função function_ratio_update() criada ;
# INFO        :
# -- -- [ "$1" -eq 1 ] : debug  < mod  echo -> stdout [screen] 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#USERNAME:
#USERNAME="$(grep 'username' config/config.knin | cut -d : -f 2)"

#TIME_OUT=$(grep '^TIME_OUT' conf/conf.script | cut -d = -f 2)
reset 

rm -rf null_temp patch_feed conf/.backup/ cookie logs conf/file_var.script 
mkdir null_temp conf/.backup/ patch_feed cookie logs


ACCOUNT=$(grep '^ACCOUNT' conf/conf.script | cut -d = -f 2)
PASSWD=$(grep '^PASSWD'  conf/conf.script  | cut -d = -f 2)
date_time=$(date +%H:%M:%S)
UPDATE_FEED=0

SLOW_BOT_INIT=$(grep '^SLOW_BOT_INIT' conf/conf.script | cut -d = -f 2)
SLOW_BOT_END=$(grep '^SLOW_BOT_END' conf/conf.script | cut -d = -f 2)

#TIME_OUT=$(grep '^TIME_OUT' conf/conf.script | cut -d = -f 2)

#########################################################


function_file_var_mod()
{
    [ "$1" -a "$2" ] && {
        cp conf/file_var.script conf/.backup/.file_var.script.backup

        cat conf/file_var.script | sed "s/^$1.*/$1$2/g" > null_temp/TEMP_FILE_VAR.script
        mv null_temp/TEMP_FILE_VAR.script conf/file_var.script    
        cp conf/file_var.script /var/www/feed/conf/file_var.script
    }
}

function_ratio_update(){

    #------------ MDAN RATIO
    grep '<font color=#1900D1>Ratio:</font>' null_temp/web_mdan_connect > /var/www/feed/conf/RATIO_TAG_MDAN.INF
    #------------------------

    #-------------OMDA RATIO
   # LINE_INF_OMDA=$(grep -n '<font color=1900D1>Ratio:</font>' null_temp/web_omda_connect  | cut -d : -f 1)

    #echo " " > /var/www/feed/conf/RATIO_TAG_OMDA.INF

    #for x in $(seq $LINE_INF_OMDA $(($LINE_INF_OMDA+5)))
    #do  

     #   test $x -ne 27 -a $x -ne 28 &&  
      #  sed -n ${x}p null_temp/web_omda_connect >> /var/www/feed/conf/RATIO_TAG_OMDA.INF ||   
       # sed -n ${x}p null_temp/web_omda_connect | sed 's/\/pic\//pic\//g'  >> /var/www/feed/conf/RATIO_TAG_OMDA.INF

    #done
    #-----------------------

    #-----------SHAKAW RATIO
   # grep '<b>Ratio</b>' null_temp/web_shakaw_connect  | cut -d \> -f -29 | sed 's/$/>/ ; s/\/pic\//pic\//g' > /var/www/feed/conf/RATIO_TAG_SHAKAW.INF
    #-----------------------

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
        

    wget  -qO  "null_temp/web_mdan_connect" --limit-rate=32k --save-cookies "cookie/mdan.cookie" --post-data 'username='$ACCOUNT'&password='$PASSWD'' "http://bt.mdan.org/takelogin.php" #--timeout=$TIME_OUT mdan.cookie
    #wget --timeout=$TIME_OUT -qO "null_temp/web_omda_connect" --limit-rate=32k --save-cookies "cookie/omda.cookie" --post-data 'username='$ACCOUNT'&password='$PASSWD'' "http://bt.omda-fansubs.com/takelogin.php"

    if [ "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" ]
    then

        function_file_var_mod "BONUS_WHOLE=" "$(sed -n 85p null_temp/web_mdan_connect | cut -d \> -f 12 | sed 's/<\/a//')"
        function_ratio_update
        
    fi
    #conecta-se ao web site , gerando o arquivo cookie
    test "$1" = "--verbose"  && echo -n " [OK]"
}

feed_check(){

    #----------------------------------------------------------------------------------------------------------------
    #FIXME : utilizar sistema avançado WGET para apenas checagem, economia de processo
    wget -qO "patch_feed/feed.xml" --limit-rate=10k --load-cookies "cookie/mdan.cookie" "http://bt.mdan.org/rss.php?feedtype=download&timezone=-3&showrows=10&categories=1"
    #----------------------------------------------------------------------------------------------------------------

    if [ "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" ]
    then
    
        function_file_var_mod "LAST_BUILD=" "$(grep -i '<lastbuilddate>.*<\/lastbuilddate>' patch_feed/feed.xml | sed 's/<\/last[bB]uild[dD]ate>// ; s/<last[Bb]uild[dD]ate>// ;s/-3// ; s/            //g')"
    
    fi

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

    COOKIE_UPDATE=$(grep '^COOKIE_UPDATE' conf/conf.script | cut -d = -f 2)
    TRACKER_UPDATE=$(grep '^TRACKER_UPDATE' conf/conf.script | cut -d = -f 2)

    function_file_var_mod "SLOW_BOT_INIT=" "$SLOW_BOT_INIT"
    function_file_var_mod "SLOW_BOT_END=" "$SLOW_BOT_END"
    function_file_var_mod "SLEEP_FLAG=" "ON"    

    if test "$1" != "--quiet"
    then
	    echo -e "\n-----------------------------------------------\n\n"
	    echo -e ".... Project KNiN : Feed ....\n"
	    echo -e ".... Bem Vindo - Blastin ....\n"
	    echo -e "Horário de Início : $date_time"
	    echo -e "\n"
	    echo -e "Database's Amount: $(grep '^[^#/]' Database/database.db | wc -l)\n"
	    echo -e "\n-----------------------------------------------\n\n"

	    echo -e "TIME UPDATE    : $TIME_UPDATE $TIME_NAME\n"
	    echo -e "SLOW CPU       : $SLOW_BOT_TIME_UPDATE $TIME_NAME [$SLOW_BOT_INIT:00 to $SLOW_BOT_END:00]\n"
	    echo -e "TRACKER_UPDATE : $TRACKER_UPDATE\n"
	    echo -e "COOKIE_UPDATE  : $COOKIE_UPDATE\n"

	    echo -e "\n-----------------------------------------------\n\n"
    fi

    test "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" && {

    if test "$(grep '^COOKIE_TIME=' conf/file_var.script | cut -d = -f 2)"
    then
        
        if test "$(date '+%H')" -gt "$(grep '^COOKIE_TIME=' conf/file_var.script | cut -d = -f 2 | cut -d : -f 1)" -a "$(date '+%d')" -eq "$(grep '^COOKIE_DAY=' conf/file_var.script | cut -d = -f 2 | cut -d : -f 1)"
        then
            TRACKER_TIME_FLAG=0 #tracker será atualizado conjunto ao init_cookie

            DATE_COOKIE_RELOAD_MIN=$(date -d "$COOKIE_UPDATE" +%M)
            DATE_COOKIE_RELOAD_HOUR=$(date -d "$COOKIE_UPDATE" +%H)
            DATE_COOKIE_RELOAD_HOUR_EXCESS=$(date -d "$COOKIE_UPDATE + 1 hour" +%H)

            function_file_var_mod "COOKIE_DAY=" "$(date -d "$COOKIE_UPDATE" '+%d')"

            function_file_var_mod "COOKIE_TIME=" "$(date -d "$COOKIE_UPDATE" +%H:%M:%S)"
            function_file_var_mod "COOKIE_UPDATE="  "$COOKIE_UPDATE"
            function_file_var_mod "TRACKER_TIME=" "$(date -d "$TRACKER_UPDATE" +%H:%M:%S)"

            init_cookie "$1"

        else
            DATE_COOKIE_RELOAD_MIN="$(grep '^COOKIE_TIME=' conf/file_var.script | cut -d = -f 2 | cut -d : -f 2)"
            DATE_COOKIE_RELOAD_HOUR="$(grep '^COOKIE_TIME=' conf/file_var.script | cut -d = -f 2 | cut -d : -f 1)"
            DATE_COOKIE_RELOAD_HOUR_EXCESS=`expr "$(grep '^COOKIE_TIME=' conf/file_var.script | cut -d = -f 2 | cut -d : -f 1)"  \+ 1`
            
        fi
    
    else

        TRACKER_TIME_FLAG=0 #tracker será atualizado conjunto ao init_cookie

        DATE_COOKIE_RELOAD_MIN=$(date -d "$COOKIE_UPDATE" +%M)
        DATE_COOKIE_RELOAD_HOUR=$(date -d "$COOKIE_UPDATE" +%H)
        DATE_COOKIE_RELOAD_HOUR_EXCESS=$(date -d "$COOKIE_UPDATE + 1 hour" +%H)

        if [ "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" ] 
        then
            function_file_var_mod "COOKIE_TIME=" "$(date -d "$COOKIE_UPDATE" +%H:%M:%S)"
            function_file_var_mod "COOKIE_DAY=" "$(date -d "$COOKIE_UPDATE" '+%d')"
            function_file_var_mod "COOKIE_UPDATE="  "$COOKIE_UPDATE"
            function_file_var_mod "TRACKER_TIME=" "$(date -d "$TRACKER_UPDATE" +%H:%M:%S)"
        fi
        init_cookie "$1"

    fi

    
    }
    test "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" && {
    
    if test "$(grep '^TRACKER_TIME=' conf/file_var.script | cut -d = -f 2)" -a "$TRACKER_TIME_FLAG"
    then
        
        if test ! "$(date '+%H')" -gt "$(grep '^TRACKER_TIME=' conf/file_var.script | cut -d = -f 2 | cut -d : -f 1)"
        then 
            DATE_TRACKER_RELOAD_HOUR="$(grep '^TRACKER_TIME=' conf/file_var.script | cut -d = -f 2 | cut -d : -f 1)"
            DATE_TRACKER_RELOAD_MIN="$(grep '^TRACKER_TIME=' conf/file_var.script | cut -d = -f 2 | cut -d : -f 2)"            
            DATE_TRACKER_RELOAD_HOUR_EXCESS=`expr "$(grep '^TRACKER_TIME=' conf/file_var.script | cut -d = -f 2 | cut -d : -f 1)" \+ 1`
        
        else
                        
            DATE_TRACKER_RELOAD_HOUR=$(date -d "$TRACKER_UPDATE" +%H)
            DATE_TRACKER_RELOAD_MIN=$(date -d "$TRACKER_UPDATE" +%M)
            DATE_TRACKER_RELOAD_HOUR_EXCESS=$(date -d "$TRACKER_UPDATE + 1 hour" +%H)
            if [ "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" ] 
            then
                function_file_var_mod "TRACKER_TIME=" "$(date -d "$TRACKER_UPDATE" +%H:%M:%S)"
            fi
            
    
        fi
    else
        

        DATE_TRACKER_RELOAD_HOUR=$(date -d "$TRACKER_UPDATE" +%H)
        DATE_TRACKER_RELOAD_MIN=$(date -d "$TRACKER_UPDATE" +%M)
        DATE_TRACKER_RELOAD_HOUR_EXCESS=$(date -d "$TRACKER_UPDATE + 1 hour" +%H)

        if [ "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" ] 
        then
            function_file_var_mod "TRACKER_TIME=" "$(date -d "$TRACKER_UPDATE" +%H:%M:%S)"
        fi
    fi

    }


    if test "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END"
    then
        function_file_var_mod "TIME_UPDATE=" "$TIME_UPDATE $TIME_NAME"
        function_file_var_mod "TRACKER_UPDATE=" "$TRACKER_UPDATE"
    else
        function_file_var_mod "TIME_UPDATE=" "$SLOW_BOT_TIME_UPDATE $TIME_NAME"
    fi
        
    
    while :
    do
        
        #---------------------------------------------------------------------
        #FIXME: Sistema sincronizado pela Shell CGI
        #TIME_UPDATE=$(grep '^TIME_UPDATE' conf/conf.script | cut -d = -f 2)
        #TIME_SYSTEM=$(grep '^TIME_SYSTEM' conf/conf.script | cut -d = -f 2)
        #------------------------------------------------------------------

        if [ "$(date '+%H')" -eq  "$DATE_COOKIE_RELOAD_HOUR"  -a "$(date '+%M')" -ge "$DATE_COOKIE_RELOAD_MIN" -o "$(date '+%H')" -eq "$DATE_COOKIE_RELOAD_HOUR_EXCESS" ]
            then
                
                DATE_COOKIE_RELOAD_MIN=$(date -d "$COOKIE_UPDATE" +%M)
                DATE_COOKIE_RELOAD_HOUR=$(date -d "$COOKIE_UPDATE" +%H)
                DATE_COOKIE_RELOAD_HOUR_EXCESS=$(date -d "$COOKIE_UPDATE + 1 hour" +%H)
                DATE_TRACKER_RELOAD_MIN=$(date -d "$TRACKER_UPDATE" +%M)
                DATE_TRACKER_RELOAD_HOUR=$(date -d "$TRACKER_UPDATE" +%H)
                DATE_TRACKER_RELOAD_HOUR_EXCESS=$(date -d "$TRACKER_UPDATE + 1 hour" +%H)
    
                if test "$1" = "--verbose"
                then

                    echo -ne '\033[G'
                    echo -ne "\033[11C"
                    echo -ne '\033[0K'

                fi
                init_cookie "$1"

                if [ "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" ] 
                then                    
                    function_file_var_mod "COOKIE_TIME=" "$(date -d "$COOKIE_UPDATE" +%H:%M:%S)"
                    function_file_var_mod "COOKIE_DAY=" "$(date -d "$COOKIE_UPDATE" '+%d')"
                    function_file_var_mod "TRACKER_TIME=" "$(date -d "$TRACKER_UPDATE" +%H:%M:%S)"

                fi



        elif [ "$(date '+%H')" -eq  "$DATE_TRACKER_RELOAD_HOUR"   -a "$(date '+%M')" -ge "$DATE_TRACKER_RELOAD_MIN" -o "$(date '+%H')" -eq "$DATE_TRACKER_RELOAD_HOUR_EXCESS" ]
            then
                DATE_TRACKER_RELOAD_MIN=$(date -d "$TRACKER_UPDATE" +%M)
                DATE_TRACKER_RELOAD_HOUR=$(date -d "$TRACKER_UPDATE" +%H)
                DATE_TRACKER_RELOAD_HOUR_EXCESS=$(date -d "$TRACKER_UPDATE + 1 hour" +%H)
                if [ "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" ]
                then    

                    if test "$1" = "--verbose"
                    then
                        echo -ne '\033[G'
                        echo -ne "\033[11C"
                        echo -ne '\033[0K'
                        echo -n "[NORM] UPDATE : [$UPDATE_FEED] | Atualizando informações do tracker in CGI/HTML..."            
                    fi

                    function_file_var_mod "TRACKER_TIME=" "$(date -d "$TRACKER_UPDATE" +%H:%M:%S)"

                    wget --timeout=$TIME_OUT --limit-rate=15k -qO "null_temp/web_mdan_connect"  --load-cookies "cookie/mdan.cookie" "http://bt.mdan.org/index.php"
                    #wget --timeout=$TIME_OUT --limit-rate=15k -qO "null_temp/web_omda_connect"  --load-cookies "cookie/omda.cookie" "http://bt.omda-fansubs.com/index.php"
                    #wget --timeout=$TIME_OUT --limit-rate=15k -qO "null_temp/web_shakaw_connect"  --load-cookies "cookie/shakaw.cookie" "http://tracker.shakaw.com.br/index.php"
                    function_file_var_mod "BONUS_WHOLE=" "$(sed -n 85p null_temp/web_mdan_connect | cut -d \> -f 12 | sed 's/<\/a//')"

                    function_ratio_update


                    test "$1" = "--verbose" && echo -n "sucesso  >"

                fi

        fi

        if [ "$(date '+%H')" -lt "$SLOW_BOT_INIT" -o "$(date '+%H')" -ge "$SLOW_BOT_END" ]
        then
            test "$1" = "--verbose" && function_file_var_mod "SLEEP_FLAG=" "OFF"
        fi
        
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

            function_file_var_mod "SLEEP_TIME=" "$(date -d "$TIME_UPDATE $TIME_NAME - $BUFF_TIME_EXCESS seconds" +%H:%M:%S)"

            if test "$1" = "--verbose"
            then
                function_file_var_mod "SLEEP_FLAG=" "ON"
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



if test ! -f conf/file_var.script  
then
 	bash conf/init_file_var.sh
elif test ! $(cat conf/file_var.script | wc -l) 
then
	bash conf/init_file_var.sh
fi

if test "$2" = "-q" -o "$1" = "--quiet"
then
	automatic_bot "--quiet"
elif test "$2" = "-v" -o "$1" = "--verbose"
then
	automatic_bot "--verbose"
elif test "$2" = "-d" -o "$1" = "--debug"
then
	automatic_bot "--debug"
else
	automatic_bot "--verbose"
fi

#elif test "$1" = "--knin-debug"
#then
#    echo "init_bot obsoleto .. a implementar"



exit 0