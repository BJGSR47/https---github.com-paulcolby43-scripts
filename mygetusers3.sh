# mygetusers3.sh written on 09-20-12 by bjg for tranact
# this script pulls all of the users from the /etc/passwd file and
# then changes the delimiter to a '|' for import into Informix. 10-23-02 dls
cat /etc/passwd | awk -F: '{print $1 "|" $5 "|"}'>/tmp/swxusers.txt
