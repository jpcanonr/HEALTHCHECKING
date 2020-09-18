#!/bin/bash
#-------------------------------------------
#-------------------------------------------
#  AUTOR Juan Pablo Canon IBM
#  Health Checking WMQ
#  Script para generar información de HC
#-------------------------------------------
#-------------------------------------------

TODAY=`date '+%d_%m_%Y-%H_%M_%S'`;
SCRIPTHOME="/admin/IBM/scripts/HEALTHCHECKING"
RUTA_VAR="/var/mqm"
RUTA_USR="/usr/mqm"
RUTA_BIN="/usr/mqm/bin"
QUEUE_MANAGERS=$($RUTA_BIN/dspmq | sed -e 's/^QMNAME(\([^)]*\)).*/\1/')
VERSION=$(dspmqver | grep Version | awk '{print $NF}' | awk '{print substr($0,0,1)}')
REPORT_OUTPUT=$SCRIPTHOME/HCReport-$('hostname')-$TODAY.out

source $SCRIPTHOME/hcmqini.paths
source $SCRIPTHOME/hcmqssl.paths

echo "*************************************************************************"
echo "*************************************************************************"
echo 'Inicio Script Health Checking WMQ'
echo "*************************************************************************"
echo "*************************************************************************"
echo 'Health Checking WMQ' >> $REPORT_OUTPUT
echo 'Hostname: '$('hostname') >> $REPORT_OUTPUT
echo "Fecha: $TODAY" >> $REPORT_OUTPUT
#echo -e "\n" >> $REPORT_OUTPUT
echo "*************************************************************************" >> $REPORT_OUTPUT
echo "*************************************************************************" >> $REPORT_OUTPUT
echo >> $REPORT_OUTPUT
echo "***************************AN.1.7.1**************************************" >> $REPORT_OUTPUT
echo 'lsuser -f mqm' >> $REPORT_OUTPUT
#lsuser -f mqm >> $REPORT_OUTPUT
sudo sh 'lsuser -f mqm | grep rlogin' >> $REPORT_OUTPUT
echo "***************************AN.1.8.1.2************************************" >> $REPORT_OUTPUT
#for QM in $QUEUE_MANAGERS ; do
#    RUTASSL="RUTASSL_$QM"
#    ls -l ${!RUTASSL} >> $REPORT_OUTPUT
#done
for QM in $QUEUE_MANAGERS ; do
    RUTASSL="RUTASSL_$QM"
    if [[ -z "${!RUTASSL}" ]] ; then
	    echo "Sección AN.1.8.1.2. No encuentra ruta del KeyStore $QM en fichero 'hcmqssl.paths'. Agregar manualmente"
        echo "No encuentra ruta SSL de $QM o falta agregarlo en el fichero 'hcmqssl.paths' del script" >> $REPORT_OUTPUT
    else
	    ls -l ${!RUTASSL} >> $REPORT_OUTPUT
    fi
done
echo "***************************AN.1.8.1.3************************************" >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    RUTAINI="RUTAINI_$QM"
    if [[ -z "${!RUTAINI}" ]] ; then
	    echo "Sección AN.1.8.1.3. No encuentra ruta de 'qm.ini' $QM en fichero 'hcmqini.paths'. Agregar manualmente"
        echo "No encuentra ruta de 'qm.ini' de $QM o falta agregarlo en el fichero 'hcmqini.paths' del script" >> $REPORT_OUTPUT
    else
	    ls -l ${!RUTAINI} >> $REPORT_OUTPUT
    fi
done
echo "***************************AN.1.8.1.4************************************" >> $REPORT_OUTPUT
echo "dspmq" >> $REPORT_OUTPUT
dspmq >> $REPORT_OUTPUT
echo >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    QMSTATUS=$("$RUTA_BIN/dspmq"  | grep "QMNAME($QM)" | sed -n 's/^.*STATUS(\(.*\))$/\1/'p)
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo 'Queue Manager: '$QM >> $REPORT_OUTPUT
        echo "dspmqaut -m $QM -n SYSTEM.ADMIN.COMMAND.QUEUE -t q -g staff" >> $REPORT_OUTPUT
        dspmqaut -m $QM -n SYSTEM.ADMIN.COMMAND.QUEUE -t q -g staff >> $REPORT_OUTPUT
    fi
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo 'Queue Manager: '$QM >> $REPORT_OUTPUT
        echo "dspmqaut -m $QM -n SYSTEM.ADMIN.COMMAND.QUEUE -t q -g nobody" >> $REPORT_OUTPUT
        dspmqaut -m $QM -n SYSTEM.ADMIN.COMMAND.QUEUE -t q -g nobody >> $REPORT_OUTPUT
    fi
done
echo "***************************AN.1.8.1.5************************************" >> $REPORT_OUTPUT
echo "dspmq" >> $REPORT_OUTPUT
dspmq >> $REPORT_OUTPUT
echo >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    QMSTATUS=$("$RUTA_BIN/dspmq"  | grep "QMNAME($QM)" | sed -n 's/^.*STATUS(\(.*\))$/\1/'p)
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo 'Queue Manager: '$QM >> $REPORT_OUTPUT
        echo "amqoamd -m $QM -s | grep staff" >> $REPORT_OUTPUT
        amqoamd -m $QM -s | grep staff >> $REPORT_OUTPUT
    fi
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo 'Queue Manager: '$QM >> $REPORT_OUTPUT
        echo "amqoamd -m $QM -s | grep nobody" >> $REPORT_OUTPUT
        amqoamd -m $QM -s | grep nobody >> $REPORT_OUTPUT
    fi
done
echo "***************************AN.1.8.1.6************************************" >> $REPORT_OUTPUT
echo "dspmq" >> $REPORT_OUTPUT
dspmq >> $REPORT_OUTPUT
echo >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    QMSTATUS=$("$RUTA_BIN/dspmq"  | grep "QMNAME($QM)" | sed -n 's/^.*STATUS(\(.*\))$/\1/'p)
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo 'Queue Manager: '$QM >> $REPORT_OUTPUT
        echo "amqoamd -m $QM -s | grep altusr" >> $REPORT_OUTPUT
        amqoamd -m $QM -s | grep altusr >> $REPORT_OUTPUT
    fi
done
echo "***************************AN.1.8.1.7************************************" >> $REPORT_OUTPUT
echo "dspmq" >> $REPORT_OUTPUT
dspmq >> $REPORT_OUTPUT
echo >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    QMSTATUS=$("$RUTA_BIN/dspmq"  | grep "QMNAME($QM)" | sed -n 's/^.*STATUS(\(.*\))$/\1/'p)
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo 'Queue Manager: '$QM >> $REPORT_OUTPUT
        echo "amqoamd -m $QM -s | grep SYSTEM.BASE.TOPIC" >> $REPORT_OUTPUT
        amqoamd -m $QM -s | grep SYSTEM.BASE.TOPIC >> $REPORT_OUTPUT
    fi
done
echo "***************************AN.1.8.5.1************************************" >> $REPORT_OUTPUT
echo "dspmq" >> $REPORT_OUTPUT
dspmq >> $REPORT_OUTPUT
echo >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    QMSTATUS=$("$RUTA_BIN/dspmq"  | grep "QMNAME($QM)" | sed -n 's/^.*STATUS(\(.*\))$/\1/'p)
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo "Queue Manager: $QM" >> $REPORT_OUTPUT
        echo "display channel (SYSTEM.DEF.SVRCONN) MCAUSER " | runmqsc $QM >> $REPORT_OUTPUT
        echo "display channel (SYSTEM.DEF.RECEIVER) MCAUSER " | runmqsc $QM >> $REPORT_OUTPUT
        echo "display channel (SYSTEM.DEF.REQUESTER) MCAUSER " | runmqsc $QM >> $REPORT_OUTPUT
        echo >> $REPORT_OUTPUT
    fi
done
echo "***************************AN.1.8.5.2************************************" >> $REPORT_OUTPUT
echo "dspmq" >> $REPORT_OUTPUT
dspmq >> $REPORT_OUTPUT
echo >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    QMSTATUS=$("$RUTA_BIN/dspmq"  | grep "QMNAME($QM)" | sed -n 's/^.*STATUS(\(.*\))$/\1/'p)
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo "Queue Manager: $QM" >> $REPORT_OUTPUT
        echo "display channel (SYSTEM.AUTO.RECEIVER) MCAUSER " | runmqsc $QM >> $REPORT_OUTPUT
        echo "display channel (SYSTEM.AUTO.SVRCONN) MCAUSER " | runmqsc $QM >> $REPORT_OUTPUT
        echo >> $REPORT_OUTPUT
    fi
done
echo "***************************AN.1.8.5.3************************************" >> $REPORT_OUTPUT
echo "dspmq" >> $REPORT_OUTPUT
dspmq >> $REPORT_OUTPUT
echo >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    QMSTATUS=$("$RUTA_BIN/dspmq"  | grep "QMNAME($QM)" | sed -n 's/^.*STATUS(\(.*\))$/\1/'p)
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo "Queue Manager: $QM" >> $REPORT_OUTPUT
        echo "display channel (SYSTEM.ADMIN.SVRCONN) MCAUSER " | runmqsc $QM >> $REPORT_OUTPUT
        echo >> $REPORT_OUTPUT
    fi
done
echo "***************************AN.1.8.5.4************************************" >> $REPORT_OUTPUT
echo "dspmq" >> $REPORT_OUTPUT
dspmq >> $REPORT_OUTPUT
echo >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    QMSTATUS=$("$RUTA_BIN/dspmq"  | grep "QMNAME($QM)" | sed -n 's/^.*STATUS(\(.*\))$/\1/'p)
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo 'Queue Manager: '$QM >> $REPORT_OUTPUT
        echo "amqoamd -m $QM -s | grep SVRCONN" >> $REPORT_OUTPUT
        amqoamd -m $QM -s | grep SVRCONN >> $REPORT_OUTPUT
    fi
done
echo "***************************AN.1.8.5.5************************************" >> $REPORT_OUTPUT
if [ "$VERSION" == '7' ] ; then
    echo "N/A" >> $REPORT_OUTPUT
    #dspmqver | grep Version | awk '{print $NF}'
    dspmqver | grep Version >> $REPORT_OUTPUT
elif [ "$VERSION" \> '7' ] ; then
    dspmqver >> $REPORT_OUTPUT
    echo "display qmgr CONNAUTH" | runmqsc $QM >> $REPORT_OUTPUT
fi
echo "***************************AN.1.8.5.6************************************" >> $REPORT_OUTPUT
echo "dspmq" >> $REPORT_OUTPUT
dspmq >> $REPORT_OUTPUT
echo >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    QMSTATUS=$("$RUTA_BIN/dspmq"  | grep "QMNAME($QM)" | sed -n 's/^.*STATUS(\(.*\))$/\1/'p)
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo 'Queue Manager: '$QM >> $REPORT_OUTPUT
        echo "amqoamd -m $QM -n SYSTEM.MQEXPLORER.REPLY.MODEL -t queue -s" >> $REPORT_OUTPUT
        amqoamd -m $QM -n SYSTEM.MQEXPLORER.REPLY.MODEL -t queue -s >> $REPORT_OUTPUT
    fi
done
echo "***********************AN.1.8.6.1-AN.1.8.6.2*****************************" >> $REPORT_OUTPUT
ls -l $RUTA_BIN >> $REPORT_OUTPUT
echo "***************************AN.1.8.6.3************************************" >> $REPORT_OUTPUT
echo "$RUTA_BIN" >> $REPORT_OUTPUT
ls -l $RUTA_USR | grep bin | grep mqm >> $REPORT_OUTPUT
echo "***************************AN.1.8.6.4************************************" >> $REPORT_OUTPUT
ls -l $RUTA_BIN >> $REPORT_OUTPUT
echo "***************************AN.1.8.6.5************************************" >> $REPORT_OUTPUT
echo "$RUTA_BIN" >> $REPORT_OUTPUT
ls -l $RUTA_USR | grep bin | grep mqm >> $REPORT_OUTPUT
echo "***************************AN.1.8.8.1************************************" >> $REPORT_OUTPUT
echo "dspmq" >> $REPORT_OUTPUT
dspmq >> $REPORT_OUTPUT
echo >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    QMSTATUS=$("$RUTA_BIN/dspmq"  | grep "QMNAME($QM)" | sed -n 's/^.*STATUS(\(.*\))$/\1/'p)
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo "Queue Manager: $QM" >> $REPORT_OUTPUT
        echo "display service(*) STARTCMD STOPCMD" | runmqsc $QM >> $REPORT_OUTPUT
        echo >> $REPORT_OUTPUT
    fi
done
echo "***********************AN.1.8.8.2-AN.1.8.8.3*****************************" >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    QMSTATUS=$("$RUTA_BIN/dspmq"  | grep "QMNAME($QM)" | sed -n 's/^.*STATUS(\(.*\))$/\1/'p)
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo "Gestor de colas: $QM" >> $REPORT_OUTPUT
        RUTA_STARTCMD=$(echo "display service(*) STARTCMD" | runmqsc $QM  | sed -n 's/^.*STARTCMD(\(.*\))$/\1/p')
        if [ "$RUTA_STARTCMD" == " " ] ; then
            echo "N/A: Parametro vacio STARTCMD para $QM" >> $REPORT_OUTPUT
        elif [ "$RUTA_STARTCMD" != " " ] ; then
            if [[ "$RUTA_STARTCMD" == *"+MQ_INSTALL_PATH+/bin/amqp.sh"* ]] ; then
                ls -l $RUTA_STARTCMD >> $REPORT_OUTPUT
                echo "Sección AN.1.8.8.2. Ruta 'amqp.sh' no encontrada para $QM. Se genera reporte para $RUTA_BIN/amqp.sh (Default)"
                ls -l $RUTA_BIN/amqp.sh >> $REPORT_OUTPUT
            else
                ls -l $RUTA_STARTCMD >> $REPORT_OUTPUT
            fi
        fi
        RUTA_STOPCMD=$(echo "display service(*) STOPCMD" | runmqsc $QM  | sed -n 's/^.*STOPCMD(\(.*\))$/\1/p')
        if [ "$RUTA_STOPCMD" == " " ] ; then
            echo "N/A: Parametro vacio STOPCMD para $QM" >> $REPORT_OUTPUT
        elif [ "$RUTA_STOPCMD" != " " ] ; then
            if [[ "$RUTA_STOPCMD" == *"+MQ_INSTALL_PATH+/bin/endmqsde"* ]] ; then
                ls -l $RUTA_STOPCMD >> $REPORT_OUTPUT
                echo "Sección AN.1.8.8.2. Ruta 'endmqsde' no encontrada para $QM. Se genera reporte para $RUTA_BIN/endmqsde (Default)"
                ls -l $RUTA_BIN/endmqsde >> $REPORT_OUTPUT
            else
                ls -l $RUTA_STOPCMD >> $REPORT_OUTPUT
            fi
        fi
    fi
done
echo "***************************AN.1.8.9.1************************************" >> $REPORT_OUTPUT
echo "dspmq" >> $REPORT_OUTPUT
dspmq >> $REPORT_OUTPUT
echo >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    QMSTATUS=$("$RUTA_BIN/dspmq"  | grep "QMNAME($QM)" | sed -n 's/^.*STATUS(\(.*\))$/\1/'p)
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo "Queue Manager: $QM" >> $REPORT_OUTPUT
        echo "display PROCESS(*) APPLICID" | runmqsc $QM >> $REPORT_OUTPUT
        echo >> $REPORT_OUTPUT
    fi
done
echo "***********************AN.1.8.9.2-AN.1.8.9.3*****************************" >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    QMSTATUS=$("$RUTA_BIN/dspmq"  | grep "QMNAME($QM)" | sed -n 's/^.*STATUS(\(.*\))$/\1/'p)
    if [ "$QMSTATUS" = 'Running' ] ; then
        echo 'Queue Manager: '$QM >> $REPORT_OUTPUT
        RUTA_APPLICID=$(echo "display PROCESS(*) APPLICID" | runmqsc $QM  | sed -n 's/^.*APPLICID(\(.*\))$/\1/p')
        if [ "$RUTA_APPLICID" == " " ] ; then
            echo "N/A: Parametro vacio APPLICID en $QM" >> $REPORT_OUTPUT
        elif [ "$RUTA_APPLICID" != " " ] ; then
            ls -l $RUTA_APPLICID >> $REPORT_OUTPUT
        fi
    fi
done
echo "***************************AN.2.1.1**************************************" >> $REPORT_OUTPUT
for QM in $QUEUE_MANAGERS ; do
    RUTAINI="RUTAINI_$QM"
    echo 'Queue Manager: '$QM >> $REPORT_OUTPUT
    if [[ -z "${!RUTAINI}" ]] ; then
	    echo "Sección AN.2.1.1. No encuentra ruta de 'qm.ini' $QM en fichero 'hcmqini.paths'. Agregar manualmente"
        echo "No encuentra ruta de 'qm.ini' o falta agregarlo en el fichero 'hcmqini.paths' del script" >> $REPORT_OUTPUT
    else
	    echo ${!RUTAINI} >> $REPORT_OUTPUT
        cat ${!RUTAINI} | grep SSLV3 >> $REPORT_OUTPUT
    fi
done
echo "*************************************************************************"
echo "*************************************************************************"
echo 'Reporte generado: '$REPORT_OUTPUT
echo "*************************************************************************"
echo "*************************************************************************"
echo 'Fin Script Health Checking WMQ'
echo "*************************************************************************"
echo "*************************************************************************"
