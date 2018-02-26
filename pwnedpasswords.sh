#!/bin/bash

usage()
{
  printf "%b" "
This is a simple bash script for searching Troy Hunt's pwnedpassword API using the k-anonymity algorithm

Usage

  ${BASH_SOURCE[0]} [options] PASSWORD

Options:

    -h, --help    Shows this message

Arguments:

	PASSWORD    Provide the password as the first argument or leave blank to provide via STDINT or prompt

"
}

pre_requisites()
{
	if ! [ -x "$(command -v curl)" ]; then
		echo "ERROR: curl is required, please install curl."
		exit 1
	fi
}

pwned_password()
{
	local password sha1 short_sha1 sha1_suffix http_status http_body http_response
	password="$1"
	sha1=$(echo -n "$password" | sha1sum | awk '{print toupper($1)}')
	short_sha1=${sha1:0:5}
	sha1_suffix=${sha1:5}

	http_response=$(curl -s -w "\nHTTPSTATUS:%{http_code}\n" "https://api.pwnedpasswords.com/range/${short_sha1}")
	http_body="$(echo "$http_response" | sed '$d')"
	http_status=$(echo "$http_response" | tail -1 | sed -e 's/.*HTTPSTATUS://')

	if [ ! "$http_status" -eq 200 ]; then
	  echo "Error [HTTP status: $http_status]"
	  return 1
	fi

	MATCHES=$(echo "${http_body}" | grep "${sha1_suffix}" | awk -F ':' '{print $2}' | tr -d '[:space:]')
	return 0
}

OPTS=$(getopt -o ":h" -l "help" -n "$PROGRAM $COMMAND" -- "$@")
eval set -- "${OPTS}"
while true; do
  case "$1" in
    -h | --help )
      usage
      exit 0
      ;;
    -- )
      shift
      break
      ;;
    * )
      break
      ;;
  esac
done


 if [ -t 0 ]; then
 	PASSWORD="$1"
else
	PASSWORD=$(cat /dev/stdin)
fi

if [ -z "${PASSWORD}" ]; then
	echo "Enter password:"
	read -s PASSWORD
fi

pre_requisites
pwned_password "${PASSWORD}"

if [ -z "$MATCHES" ]; then
	echo "This password has not appeared in any data breaches!"
else
	echo "This password has appeared ${MATCHES} times in data breaches."
	exit 2
fi