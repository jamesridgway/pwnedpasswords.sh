# pwnedpasswords.sh
[![Build Status](https://travis-ci.org/jamesridgway/pwnedpasswords.sh.svg?branch=master)](https://travis-ci.org/jamesridgway/pwnedpasswords.sh)

A simple bash script for searching Troy Hunt's [pwnedpasswords](https://www.troyhunt.com/ive-just-launched-pwned-passwords-version-2/) API.

![pwnedpasswords.sh](https://www.jamesridgway.co.uk/system/images/images/000/000/006/original/image-1519670764439.png)

## Usage
```
This is a simple bash script for searching Troy Hunt's pwnedpassword API using the k-anonymity algorithm

Usage

  ./pwnedpasswords.sh [options] PASSWORD

Options:

    -h, --help    Shows this message

Arguments:

        PASSWORD    Provide the password as the first argument or leave blank to provide via STDINT or prompt
```

## Functionality
This is a very simple script that allows you to check if a password has been pwned. You can provide the password via one of the following options.
* Provide a password as an argument:
  ```
  $ /pwnedpasswords.sh "P@ssw0rd"
  ```
* Provide a password via stdin:
  ```
  $ echo "P@ssw0rd" | ./pwnedpasswords.sh
  ```
* Provide a password via explicit prompt:
  ```
  $ ./pwnedpasswords.sh
  Enter password:
  This password has appeared 47205 times in data breaches.
  ```
