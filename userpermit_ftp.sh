. ../scripts/.security.users
#--- Build Script to Transmit the Files ---
cd ../data
 user_cmds=user_cmds.cmd
  touch $user_cmds
  echo "user $FTPUSER $FTPPASS" > $user_cmds
  echo "ascii" >> $user_cmds
  echo "cd PermissionsReports" >> $user_cmds
  echo "put ./user_all.txt" >> $user_cmds
  echo "put ./user_cca.txt" >> $user_cmds
  echo "put ./user_mon.txt" >> $user_cmds
  echo "put ./user_scf.txt" >> $user_cmds
  echo "put ./user_snx.txt" >> $user_cmds
  echo "put ./no_linux.txt" >> $user_cmds
  echo "put ./no_swx.txt" >> $user_cmds
  echo "put ./user_prof.txt" >> $user_cmds
  echo "put ./user_table.txt" >> $user_cmds
  echo "bye" >> $user_cmds
  cat $user_cmds | ftp -vin $FTPHOST |tee -a ../logs/user_permit.log
RTNCODE=$?
cd ../scripts
exit $RTNCODE