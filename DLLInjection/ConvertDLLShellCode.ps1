Import-Module .\ConvertTo-Shellcode.ps1

$sc = ConvertTo-Shellcode <DLL_PATH>

$sc2 = $sc | % { write-output ([System.String]::Format('{0:X2}', $_)) }
$sc2 -join "" > "C:\Users\Pako\Documents\Tools\Powershell Scripts\shell.txt"

echo "[+] Finished converting to shellcode"