#!/bin/bash

usage()
{
  printf "%b" "
This is a simple bash script for searching Troy Hunt's pwnedpassword API using the k-anonymity algorithm

Usage

  ${BASH_SOURCE[0]} PASSWORD

"
}

if [ ! "$#" -eq 1 ]; then
	usage
	exit 1
fi

if ! [ -x "$(command -v curl)" ]; then
	echo "ERROR: curl is required, please install curl."
	exit 1
fi

SHA1=$(echo -n "$1" | sha1sum | awk '{print toupper($1)}')
SHORT_SHA1=${SHA1:0:5}
SHA1_SUFFIX=${SHA1:5}

HTTP_RESPONSE=$(curl -s -w "\nHTTPSTATUS:%{http_code}\n" "https://api.pwnedpasswords.com/range/${SHORT_SHA1}")
HTTP_BODY="$(echo "$HTTP_RESPONSE" | sed '$d')"
HTTP_STATUS=$(echo "$HTTP_RESPONSE" | tail -1 | sed -e 's/.*HTTPSTATUS://')

if [ ! "$HTTP_STATUS" -eq 200 ]; then
  echo "Error [HTTP status: $HTTP_STATUS]"
  exit 1
fi

MATCHES=$(echo "${HTTP_BODY}" | grep "${SHA1_SUFFIX}" | awk -F ':' '{print $2}' | tr -d '[:space:]')

if [ -z "$MATCHES" ]; then
	echo "This password has not appeared in any data breaches!"
else
	echo "This password has appeared ${MATCHES} times in data breaches."
	exit 2
fi