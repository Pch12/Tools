#!/bin/bash

pwsh -v >/dev/null 2>&1 || { echo >&2 "I require PowerShell but it's not installed.Please install 'pwsh'.. Aborting."; exit 1; }
echo '-----PowerShell Base64 Encrypter-----'
echo ''
echo ''
read -p "Enter command for base64: " command
string='$''Bytes = [System.Text.Encoding]::Unicode.GetBytes(''"'$command'");''$''EncodedText =[Convert]::ToBase64String(''$''Bytes);''$''EncodedText'
pwsh -c "$string"
