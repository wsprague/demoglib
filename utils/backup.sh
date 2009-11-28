#!/usr/bin/env bash
# Major backup script.  Warn when do weird things to stdout.

# Usage 
USAGE='backup.sh -for-real'

# Funky way to default to only doing --dry-run (wish I understood getopts better)
if [ $1 ]; then DRYRUN=' '
else DRYRUN=' --dry-run '
fi

# Important constants
REMOTE_COMMONS=/data/commons/webbs
REMOTE_HOME='~'
DEMOG_SSN=webbs@demog.berkeley.edu
PASSFILE="$HOME/.demog_pass"
LOGFILE="${HOME}/backup-log"

# Functions
function fpush_stuff (){
    # Push from source to target with port, 4th option makes --dry-run
    local SOURCE=$1; shift
    local TARGET=$1;shift
    local PORT=$1;shift
    local OPT=$1;shift
      
    rsync -auzhq -e "ssh -p$PORT" $OPT \
        --itemize-changes \
        --exclude='*.DS_Store*' \
        --exclude='.*' \
		--exclude='*/_*' \
        --log-file="$HOME/backup.log" \
    	"$SOURCE" \
		"$DEMOG_SSN:$TARGET"
}

# Make database backup and put in OREGON as "lebanon-db.sql".  Start pg_ctl if necessary.
##echo "BACKING UP DATABASE"
if /opt/local/lib/postgresql83/bin/pg_ctl -s -w restart 1>/dev/null 2>/dev/null 3>/dev/null; then
	echo blah >/dev/null
   #echo "starting database";
else
	echo blah >/dev/null
    #echo "error on starting database"
fi

if [ /opt/local/lib/postgresql83/bin/pg_dump lebanon -f lebanon-db.new.sql.gz -Z9 1>/dev/null 2>/dev/null 3>/dev/null ]; then
    mv lebanon-db.sql.gz lebanon-db.old.sql.gz
    mv lebanon-db.new.sql.gz lebanon-db.sql.gz
else
	echo blah >/dev/null
    #echo "Unable to backup LH database"
fi
#echo

# Things to go to malthus
#echo "SIMPLE DIRECTORIES TO MALTHUS"
SIMPLE_DIRS="CLASSES MONEY NOTES-SYLLABI-ETC OREGON PAPERS-PRESENTATIONS-ETC PH-D-NOTDATA "
for DIR in $SIMPLE_DIRS; do 
    #echo "Backing up $DIR"
    fpush_stuff "$HOME/DEMOG/$DIR/"  "$REMOTE_HOME/$DIR/" 22 " --checksum --exclude='*ICPSR*' "
done
#echo

# Things to go to pareto. Should include DOWNLOADS-PAPERS-DATA-ETC but doesn't
#echo "BIG THINGS TO PARETO"
PARETO_BACKUPS="OREGON-RECORDINGS  CODE"
for DIR in $PARETO_BACKUPS; do 
    #echo "Backing up $DIR"
    fpush_stuff "$HOME/DEMOG/$DIR/"  "$REMOTE_HOME/$DIR/" 2294
done

# Things to go commons


################################################################
# On the client run the following commands:

# $ mkdir -p $HOME/.ssh
# $ chmod 0700 $HOME/.ssh
# $ ssh-keygen -t dsa -f $HOME/.ssh/id_dsa -P ''

# This should result in two files, $HOME/.ssh/id_dsa (private key) and $HOME/.ssh/id_dsa.pub (public key).
# #

# Copy $HOME/.ssh/id_dsa.pub to the server.
# #

# On the server run the following commands:

# $ cat id_dsa.pub >> $HOME/.ssh/authorized_keys2
# $ chmod 0600 $HOME/.ssh/authorized_keys2
