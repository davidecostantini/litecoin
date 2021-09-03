#!/bin/sh

echo "Run command using shell"
awk '{print $9}' nginx_logs | sort -h | uniq -c | sort -rn

echo "Running using Python3"
python3 script.py
