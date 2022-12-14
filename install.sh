LOG_PIPE=log.pipe
mkfifo ${LOG_PIPE}
LOG_FILE=log.file
rm -f LOG_FILE
tee < ${LOG_PIPE} ${LOG_FILE} &
exec  > ${LOG_PIPE}
exec  2> ${LOG_PIPE}
Infon() {
	printf "\033[1;32m$@\033[0m"
}
Info()
{
	Infon "\031$@\n"
}
Error()
{
	printf "\033[1;31m$@\033[0m\n"
}
Error_n()
{
	Error "$@"
}
Error_s()
{
	Error "${red}===========================================================${reset}"
}
log_s()
{
	Info "${green}=========================================================== ${reset}"
}
cp_s ()
{
	Info ""
}
log_n()
{
	Info "- - - $@"
}
log_t()
{
	log_s
	Info "- - - $@ - - -"
	log_s
}
RED=$(tput setaf 1)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
white=$(tput setaf 7)
reset=$(tput sgr0)
toend=$(tput hpa $(tput cols))$(tput cub 6)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
LIME_YELLOW=$(tput setaf 190)
CYAN=$(tput setaf 6)

UPD="0"
upd()
{
	if [ "$UPD" = "0" ]; then
		echo "• Обновляем ${green}список пакетов! •"
		apt-get update > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
		UPD="1"
	fi
}
menu()
{
	clear
	Info
	log_t "${white}Добро пожаловать в меню установки ${red}LitePanel${green}"
	Info "- ${YELLOW}1${green} -  ${white}Настройка серверной части для ${red}LitePanel"
	Info "- ${YELLOW}0${green} -  ${white}Выход"
	Info
	cp_s
	Info
	read -p "${white}Пожалуйста, введите пункт меню:" case
	case $case in
		1) echo "• Создание папки ${green}/home! •"
		mkdir -p /home/ > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${green}[Папка существует]"
		tput sgr0
	fi
		echo "• Созлаем группу ${green}gameservers! •"
		groupadd gameservers > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
		echo "• Обновляем ${green}список пакетов! •"
		apt-get update > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
	echo "• Устанавливаем ${green}sudo zip unzip openssh-server python3 screen! •"
		apt-get install -y sudo zip unzip openssh-server python3 screen > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
		echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
		echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
		echo "• Обновляем ${green}список пакетов! •"
		apt-get update > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
	echo "• Распаковываем ${green}hostplcp! •"
	unzip cp.zip -d /home/ > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
			rm cp.zip
			echo "• Выдаем права ${green}на папки и файлы! •"
			chown -R root /home/ > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
	        chmod -R 755 /home/ > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
			cd
			cd /home/cp/ > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
			chmod -R 700 /home/cp/gameservers.py > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
			cd			
		OS=$(lsb_release -s -i -c -r | xargs echo |sed 's; ;-;g' | grep Ubuntu)
		echo "• Добавляем пакеты ${green}x32! •"
	sudo dpkg --add-architecture i386 > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
	echo "• Обновляем ${green}список пакетов! •"
		apt-get update > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
	echo "• Устанавливаем ${green}libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386! •"
    sudo apt-get install -y libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386 > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
	echo "• Запрещаем доступ к ssh группе ${green}gameservers! •"
    echo 'DenyGroups gameservers' » /etc/ssh/sshd_config	 > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
	echo "• Обновляем ${green}список пакетов! •"
	apt-get update > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
	echo "• Устанавливаем ${green}pure-ftpd! •"
	apt-get install -y pure-ftpd > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
	echo "yes" > /etc/pure-ftpd/conf/ChrootEveryone
	echo "yes" > /etc/pure-ftpd/conf/CreateHomeDir
	echo "yes" > /etc/pure-ftpd/conf/DontResolve 
	echo "• Перезагружаем ${green}pure-ftpd! •"
	/etc/init.d/pure-ftpd restart > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "${green}[OK]"
		tput sgr0
	else
		echo "${red}[fail]"
		tput sgr0
		exit
	fi
			;;
	
		0) exit;;
	esac
}
menu