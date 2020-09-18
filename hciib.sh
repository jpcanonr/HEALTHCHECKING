#!/bin/bash
#-------------------------------------------
#-------------------------------------------
#  AUTOR Juan Pablo Canon IBM
#  Health Checking WMB/IIB
#  Script para generar información de HC
#-------------------------------------------
#-------------------------------------------

TODAY=`date '+%d_%m_%Y-%H_%M_%S'`;
SCRIPTHOME="/admin/IBM/scripts/HEALTHCHECKING"
REPORT_OUTPUT=$SCRIPTHOME/HCReport-$('hostname')-$TODAY.out

echo "*************************************************************************"
echo "*************************************************************************"
echo 'Inicio Script Health Checking WMB/IIB'
echo "*************************************************************************"
echo "*************************************************************************"
echo 'Health Checking WMB/IIB' >> $REPORT_OUTPUT
echo 'Hostname: '$('hostname') >> $REPORT_OUTPUT
echo "Fecha: $TODAY" >> $REPORT_OUTPUT
echo "*************************************************************************" >> $REPORT_OUTPUT
echo "*************************************************************************" >> $REPORT_OUTPUT
echo "Digite usuario de trabajo WMB/IIB: 1 (mqsi), 2 (mqsiadm)"
read OPC
if [ $OPC == "1" ]; then
  USER=mqsi
elif [ $OPC == "2" ]; then
  USER=mqsiadm
fi
echo >> $REPORT_OUTPUT
echo "***************************BJ.1.1.1.1************************************" >> $REPORT_OUTPUT
echo "Fecha de caducidad de la contraseña de $USER" >> $REPORT_OUTPUT
echo "sudo sh 'lsuser -f $USER | fgrep maxage'" >> $REPORT_OUTPUT
sudo sh "lsuser -f $USER | fgrep maxage" >> $REPORT_OUTPUT

MAXAGE=$(sudo sh 'lsuser -f $USER | fgrep maxage' | sed -e 's#.*=\(\)#\1#')
if  [ $MAXAGE == "0" ]; then
  echo "maxage: No hay edad máxima de la contraseña" >> $REPORT_OUTPUT
elif [ $MAXAGE != "0" ]; then
  echo "maxage: La edad máxima de la contraseña es $MAXAGE semanas" >> $REPORT_OUTPUT
fi

# MMDDhhmmyy MM = month, DD = day, hh = hour, mm = minute, and yy = last 2 digits of the years 1939 through 2038
# echo
# echo "Fecha de caducidad de la cuenta $USER" >> $REPORT_OUTPUT
# echo "sudo sh 'lsuser -f $USER | fgrep expires'" >> $REPORT_OUTPUT
# sudo sh "lsuser -f $USER | fgrep expires" >> $REPORT_OUTPUT
#
# EXPIRES=$(sudo sh 'lsuser -f $USER | fgrep expires' | sed -e 's#.*=\(\)#\1#')
# if  [ $EXPIRES == "0" ]; then
#   echo "expires: No hay edad máxima de la cuenta $USER" >> $REPORT_OUTPUT
# elif [ $EXPIRES != "0" ]; then
#   echo "expires: La edad máxima de la cuenta es:" >> $REPORT_OUTPUT
#   echo "Month:" >> $REPORT_OUTPUT
#   sudo sh "lsuser -f $USER | fgrep expires" | sed -e 's#.*=\(\)#\1#' | awk '{print substr ($0, 1, 2)}' >> $REPORT_OUTPUT
#   echo "Day:" >> $REPORT_OUTPUT
#   sudo sh "lsuser -f $USER | fgrep expires" | sed -e 's#.*=\(\)#\1#' | awk '{print substr ($0, 3, 2)}' >> $REPORT_OUTPUT
#   echo "hour:" >> $REPORT_OUTPUT
#   sudo sh "lsuser -f $USER | fgrep expires" | sed -e 's#.*=\(\)#\1#' | awk '{print substr ($0, 5, 2)}' >> $REPORT_OUTPUT
#   echo "minute:" >> $REPORT_OUTPUT
#   sudo sh "lsuser -f $USER | fgrep expires" | sed -e 's#.*=\(\)#\1#' | awk '{print substr ($0, 7, 2)}' >> $REPORT_OUTPUT
#   echo "year" >> $REPORT_OUTPUT
#   sudo sh "lsuser -f $USER | fgrep expires" | sed -e 's#.*=\(\)#\1#' | awk '{print substr ($0, 9, 2)}' >> $REPORT_OUTPUT
# fi
echo "***************************BJ.1.2.1**************************************" >> $REPORT_OUTPUT
echo "ls -lrt /var/log/user.log" >> $REPORT_OUTPUT
ls -lrt /var/log/user.log >> $REPORT_OUTPUT
echo "***************************BJ.1.2.2.2************************************" >> $REPORT_OUTPUT
echo "sudo -l | grep -in $USER" >> $REPORT_OUTPUT
sudo -l | grep -in $USER >> $REPORT_OUTPUT
echo
echo "sudo su - $USER -c 'date'" >> $REPORT_OUTPUT
sudo su - $USER -c 'date' >> $REPORT_OUTPUT
echo "***************************BJ.1.7.2**************************************" >> $REPORT_OUTPUT
echo "sudo -l | grep -in $USER" >> $REPORT_OUTPUT
sudo -l | grep -in $USER >> $REPORT_OUTPUT
echo
echo "sudo su - $USER -c 'date'" >> $REPORT_OUTPUT
sudo su - $USER -c 'date' >> $REPORT_OUTPUT
echo "***************************BJ.1.8.1**************************************" >> $REPORT_OUTPUT
if  [ $USER == "mqsi" ]; then
  echo "sudo su - $USER -c 'ls -l /opt/IBM/mqsi/server'" >> $REPORT_OUTPUT
  sudo su - $USER -c 'ls -l /opt/IBM/mqsi/server' >> $REPORT_OUTPUT
elif [ $USER == "mqsiadm" ]; then
  echo "sudo su - $USER -c 'ls -l /opk/IBM/mqsi/7.0'" >> $REPORT_OUTPUT
  sudo su - $USER -c 'ls -l /opk/IBM/mqsi/7.0' >> $REPORT_OUTPUT
fi
echo "***************************BJ.1.8.2**************************************" >> $REPORT_OUTPUT
echo "sudo su - $USER -c 'ls -lrt /var/mqsi'" >> $REPORT_OUTPUT
sudo su - $USER -c 'ls -lrt /var/mqsi' >> $REPORT_OUTPUT
echo "*************************************************************************"
echo "*************************************************************************"
echo 'Reporte generado: '$REPORT_OUTPUT
echo "*************************************************************************"
echo "*************************************************************************"
echo 'Fin Script Health Checking WMB/IIB'
echo "*************************************************************************"
echo "*************************************************************************"
