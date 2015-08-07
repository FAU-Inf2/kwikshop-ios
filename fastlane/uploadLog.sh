if [ -f "../$LOG_FILE" ]
then
  echo "Uploading log file $LOG_FILE"
  scp ../$LOG_FILE mad:/var/www/kwikshop/log
fi
