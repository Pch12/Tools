#!/bin/bash
pwsh -v >/dev/null 2>&1 || { echo >&2 "I require PowerShell but it's not installed.Please install 'pwsh'  Aborting. "; exit 1;  }
echo '-----PowerShell Base64 Decryptor-----'
echo ''
echo ''
read -p "Enter command for base64: " command
string='$''EncodedText = '"'$command'"';$''DecodedText =[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String(''$''EncodedText));''$''DecodedText' 
pwsh -c "$string"
