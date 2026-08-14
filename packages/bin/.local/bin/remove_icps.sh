# !/bin/bash
################################################################################
#
# File:     remove_icps.sh
#
# Purpose:  Remove ipcs types based on certain users.
#
# Usage:    remove_icps.sh -u=<user> -t=<type>
#
# Description:
#   This script is used to remove ipcs types based on certain users. The user can
#   specify the user and the type of ipcs to remove.
#
#   Types: semaphores, message queues, shared memory, or all
#   Default user: is the current user.
#
################################################################################

print_usage()
{
    cat << "USAGE_TXT"
-----------------------------------------------------
Usage:
    remove-icps.sh -u=<user> -t=<type>

Description:
    Remove ipcs types based on certain users.

flags:
    -u/--user=  <user> -> name of user to kill ipcs types
                ( default is 'whoami' )
    -t/--type=  sema -> Semaphores
                msgq -> Message Queues
                shm  -> Shared Memory
                all  -> All 3 types
    -h/--help=  <anything>
-----------------------------------------------------
USAGE_TXT
}

print_selection()
{
    # printf "\n\n-----------------------------------------------------\n"
    printf "\nUser Input:\n"
    printf "\tUSER: '$USR'\n"
    printf "\tTYPE: '$TYPE'\n"
}

# TYPE_LST=( "sema" "msgq" "shm" "all" )
TYPE_LST="sema msgq shm all"
HELP="PLACE_HOLDER"
USR=$(whoami)
while [[ $# -gt 0 ]]; do
  case $1 in
    -u|--user)
      USR="$2"
      shift # past argument
      shift # past value
      ;;
    -t|--type)
      TYPE="$2"
      shift # past argument
      shift # past value
      ;;
    -h|--help)
      HELP="$2"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option '$1'"
      exit 1
      ;;
  esac
done

if ! [ "${HELP}" == "PLACE_HOLDER" ]; then
    print_usage
    echo $HELP
    exit 1
fi

print_selection

# Checks the flags
if [ -z "${TYPE}" ]; then
    printf "\n\nERROR:\n"
    printf "\tThe following flags are required: -t\n"
    printf "\tExiting.\n\n"
    exit 1
fi

# TODO: This doesn't work for say 's' or single letters
if ! echo ${TYPE_LST} | grep -q ${TYPE}; then
    printf "\n\nERROR:\n"
    printf "\tEntered type '$TYPE' is not available. See usage.\n"
    printf "\tExiting.\n\n"
    exit 1
fi

# Gets ID's from ipcs
IPCS_Q='ipcs -q | egrep "0x[0-9a-f]+ [0-9]+" | grep $USR | cut -f2 -d" "'  # Message Queues
IPCS_M='ipcs -m | egrep "0x[0-9a-f]+ [0-9]+" | grep $USR | cut -f2 -d" "'  # Shared Memory
IPCS_S='ipcs -s | egrep "0x[0-9a-f]+ [0-9]+" | grep $USR | cut -f2 -d" "'  # Semaphores

# Removes selections
case ${TYPE} in
    sema)
        printf "Sema"
        # for id in $IPCS_S; do
        #   ipcrm -s $id;
        # done
        ;;
    msgq)
        printf "msgq"
        # for id in $IPCS_Q; do
        #   ipcrm -q $id;
        # done
        ;;
    shm)
        printf "shm"
        # for id in $IPCS_M; do
        #   ipcrm -m $id;
        # done
        ;;
    all)
        prinf "all"
        # for id in $IPCS_S; do
        #   ipcrm -s $id;
        # done
        # for id in $IPCS_Q; do
        #   ipcrm -q $id;
        # done
        # for id in $IPCS_M; do
        #   ipcrm -m $id;
        # done
        ;;
    *)
        printf "ERROR:"
        printf "\tCase not found. Code change needed.\n\n"
        ;;
esac
