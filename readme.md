
Prihlasovnanie cez > SSHkeys. Treba nejako dostať svoj *.pub súbor na stroj a pridať!!! do c:\ProgramData\administrators_authorized_keys, pridať nie prepísať.. Napr. https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement#deploying-the-public-key

Vytvoriť si svoj .pass.yml kde bude heslo k ```ansible vault``` skopirovať na vhodné miesto a upraviť ```ansible.cfg```
```
[defaults]
inventory=inventory/putm13.ini,inventory/putm23.ini,inventory/putm33.ini,inventory/cdipc.ini,inventory/trial.ini
remote_path=C:/temp  # Define your default remote path
vault_password_file=~/.pass.yml
```
napr ```nano ~/.pass.yml``` s obsahom
```
moje_heslo_k_Vaultu
```
Upraviť prístupové práva k súboru ``` chmod 600 ~/.pass.yml```. Súbor bude čitatelný len pre uživatateľa a ```root```

Vytvorenie vaultu so súkromnými údajmi -> zašifrovaný súbor
```
ansible-vault create ~/.secret.yml 
```
ideálne ADM účet
```
---
pwd=Moj3_hesl0
usr=meno@domena
```
Premenné ```pass``` a ```usr``` sa potom môžu používať v playbookoch
```
 - name: Run ps1
      become: true
      become_user: "{{ usr }}"
      vars:
        ansible_become_password: "{{ pwd }}"
      ansible.windows.win_command:...
 ```     
použitie vault-u /```--limit trial``` obmedzi spustenie playbooku na skupinu trial/
```
ansible-playbook --limit trial playbooks/install_7zip.yml --extra-vars @~/.secrets.yml
```
spustí install_7zip.yml s parametrom secrets.yml, za jazdy sa odšifruje pomocou ```vault_password_file```

prvé pokusy s playbookmi spustat parametrom  ```--ssh-common-args='-o StrictHostKeyChecking=accept-new```

```
ansible-playbook playbooks/ping.yml KM_OH --ssh-common-args='-o StrictHostKeyChecking=accept-new'
```
Spustený playbook na celej skupine ```KM_OH```. nie je použitý parameter ```--limit```. Ten je vhodné použiť s nejakým konkrétnym PC  ```--limit PU14```
Skupina ```trial``` je výberom medzi ostatným skupinami a aj súbormi ```*.ini```

Skupina ```KM_OH```
```
[KM_OH]
KM1  ansible_host=putm13tbo4101.tiremes.contiwan.com wc=TBK51
KM2  ansible_host=putm13tbo4201.tiremes.contiwan.com wc=TBK52
KM3  ansible_host=putm13tbo4301.tiremes.contiwan.com wc=TBK53
KM4  ansible_host=putm13tbo4401.tiremes.contiwan.com wc=TBK54
...
...
[KM_OH:vars]
ansible_winrm_server_cert_validation = ignore
ansible_shell_type = cmd
```
v kombinácíí so skupinou ```PU_OH```
```
[PU_OH]
PU1  ansible_host=putm13tbo5101.tiremes.contiwan.com wc=TBO51
PU2  ansible_host=putm13tbo5201.tiremes.contiwan.com wc=TBO52
PU3  ansible_host=putm13tbo5301.tiremes.contiwan.com wc=TBO53
PU4  ansible_host=putm13tbo5401.tiremes.contiwan.com wc=TBO54
```

môžu byť kombinované do nadradenej ```TB_OH```
```
[TB_OH:children]
KM_OH
PU_OH
```
Skupina ```trial```
```
[trial]
13cdipc01
PU1
```
pozri ```inventory/*.ini```
