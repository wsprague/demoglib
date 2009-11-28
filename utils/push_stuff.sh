#!/opt/local/bin/bash
# Get the source dir, the target dir, and ush everything up to that                                                                                       
function fpush_stuff (){
    rsync -auzL --ignore-existing --progress \ 
    	--exclude='*.DS_Store*' \
        --exclude='.*'\ "$HOME/DEMOG/$1/" \ 
    	"$DEMOG_SSN:$3/$2/"
}

export REMOTE_COMMONS=/data/commons/webbs
export REMOTE_REGULAR='~'
export DEMOG_SSN=webbs@demog.berkeley.edu
USAGE='push_stuff source'
IMPORTANT_DIRS='OREGON/DATA/Recordings 


$SOURCE=$1; shift

case $SOURCE in
    '

fpush_stuff 
