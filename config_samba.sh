#!/bin/bash
#Script Version 1.0
config_samba(){
clear
echo "Configuração do SAMBA"
echo "Script desenvolvido por M3nin0"
sleep 5
clear
echo "Verificando se o SAMBA esta instalado"
echo "........."
sleep 2
echo "............"
sleep 2
veri=$(which samba)
way=$(/usr/sbin/samba)

if [ "$veri" != "$way" ];then
	apt-get install samba

fi

sleep 5
clear
echo "Escolha uma das opções para prosseguir: "
echo "1 - Nova configuração"
echo "2 - Adicionar diretorio de compartilhamento"
echo "3 - Adicionar novo usuario"
echo "4 - SAIR"
read menu

case $menu in 

1)
clear
echo "Novas configurações SAMBA"
echo "Digite o nome de sua rede de comparilhamento: "
read workgroup
echo ""
echo "Digite o nome da NetBios: "
read netbios
echo ""
echo "Nome de exibição: "
read srvstring

### Configurando o novo SMB.conf

echo "[global]" >> smb.conf
echo "workgroup = $workgroup" >> smb.conf
echo "netbios name = $netbios" >> smb.conf
echo "server string = $srvstring" >> smb.conf
echo "" >> smb.conf
echo "domain master = yes" >> smb.conf
echo "domain logons = yes" >> smb.conf
echo "logon script = netlogon.bat" >> smb.conf
echo "security = user" >> smb.conf
echo "encrypt passwords = yes" >> smb.conf
echo "enable privileges = yes" >> smb.conf
echo "passdb backend tdbsam" >> smb.conf
echo "preferred master = yes" >> smb.conf
echo "local master = yes" >> smb.conf
echo "os level = 100" >> smb.conf
echo "wins support = yes" >> smb.conf
echo "logon home = %L%U.profiles" >> smb.conf
echo "logon path = %Lprofiles%U" >> smb.conf
echo "" >> smb.conf
echo "[netlogon]" >> smb.conf
echo "comment = Serviço de logon" >> smb.conf
echo "path = /var/samba/netlogon" >> smb.conf
echo "read only = yes" >> smb.conf
echo "browseable = no" >> smb.conf
echo "" >> smb.conf
echo "path = /home/%u" >> smb.conf
echo "valid users = %S" >> smb.conf
echo "read only = no" >> smb.conf
echo "create mask = 0700" >> smb.conf
echo "directory mask" >> smb.conf
echo "browseable = no" >> smb.conf
echo "" >> smb.conf
echo "[profiles]" >> smb.conf
echo "path = /var/profiles" >> smb.conf
echo "writable = yes" >> smb.conf
echo "browseable = no" >> smb.conf
echo "create mask = 0600" >> smb.conf
echo "directory mask = 0700" >> smb.conf
echo "" >> smb.conf
smbpasswd -a root
mkdir -p /var/samba/netlogon
chmod 775 /var/samba/netlogon
### Reiniciando o SAMBA ###
service samba restart 2> /dev/null
service smbd restart 2> /dev/null
service nmbd restart 2> /dev/null
clear
echo "Fazendo a configuração"
echo "Agora basta fazer o acrescimo de pastas a serem compartilhadas"
sleep 5
exit
;;
2)
clear
echo "Adicionando pastas ao SAMBA"
echo "Insira o nome a ser dado aos arquivos"
read name
echo "Insira o caminho a ser compartilhado"
read caminho
echo "Insira o nome de exibição"
read comment
echo "Pode ser modificado?"
read escrita

### Fazendo o compartilhamento de pastas ###
echo "" >> smb.conf
echo "[$name]" >> smb.conf
echo "path = $caminho" >> smb.conf
echo "comment = $comment" >> smb.conf
echo "writable = $escrita" >> smb.conf
clear
sleep 5
echo "Criando o compartilhamento"
echo ".........."
echo "................"
sleep 5
echo "Concluido!!!"
### Reiniciando o SAMBA ###
service samba restart 2> /dev/null
service smbd restart 2> /dev/null
service nmbd restart 2> /dev/null
exit
;;
3)
clear
echo "Adicionando usuarios ao SAMBA"
echo "Insira o nome do usuario"
read name
adduser $name
mkdir /home/$name/profiles.pds
chown -R $name:$name /home/name/profiles.pds
mkdir /etc/skel/profiles.pds
echo "Concluido!!!"
### Reiniciando o SAMBA ###
service samba restart 2> /dev/null
service smbd restart 2> /dev/null
service nmbd restart 2> /dev/null

exit
;;
4)
echo "FALOU!!!"
exit
;;
*)
echo "Escolha a opção valida"
exit
esac
}

ROT=$(id -u)

if [ "$ROT" = "0" ];then
	config_samba

else
	echo "O script abre apenas com ROOT"
	exit
fi	
