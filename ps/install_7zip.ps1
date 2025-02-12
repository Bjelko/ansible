Copy-Item -Path '//putm09engms05.tiremes.contiwan.com/ac_Repository/swrep/7zip_msi/' -Destination 'c:\tmp\7zip_msi' -Recurse -Force
msiexec /i "c:\tmp\7zip_msi\7z2409.msi" /quiet /norestart

