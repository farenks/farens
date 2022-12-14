#!/bin/sh
Infon()
{
 printf "\033[1;32m$@\033[0m"
}
Info()
{
 Infon "$@\n"
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
 Error "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
}
log_s()
{
 Info "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
}
log_n()
{
 Info "$@"
}
log_t()
{
 log_s
 Info "- - - $@"
 log_s
}
log_tt()
{
 Info "- - - $@"
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
VER=`cat /etc/issue.net | awk '{print $1$3}'`
OS=$(lsb_release -s -i -c -r | xargs echo |sed 's; ;-;g' | grep Ubuntu)
IP_SERV=$(echo "${SSH_CONNECTION}" | awk '{print $3}')

install_panel()
{
	clear

	if [ $VER = "UbuntuLTS" ]; then
		read -p "${white}Пожалуйста, введите домен или IP :${reset}" DOMAIN
		if [ $? -eq 0 ]; then
			echo "${green}[SUCCESS] "
			tput sgr0
		else
			echo "${red}[ERROR] "
			tput sgr0
			exit
		fi
		log_n "${BLUE}Updating packages "
		
		
		
		 sudo apt-get install -y software-properties-common > /dev/null 2>&1 

         sudo add-apt-repository ppa:ondrej/php -y > /dev/null 2>&1
		
		sudo apt-get update > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo "${green}[SUCCESS] "
			tput sgr0
		else
			echo "${red}[ERROR] "
			tput sgr0
			exit
		fi
		
		
		sudo apt-get install -y pwgen apache2 php7.0 php7.0-curl php-curl php7.0-gd php7.0-mysql php7.0-xml php7.0-ssh2 php7.0-mbstring mariadb-server unzip htop sudo curl screen > /dev/null 2>&1
		
		log_n "${BLUE}Instaling Packages " > /dev/null 2>&1
		MYPASS=$(pwgen -cns -1 16) > /dev/null 2>&1
		CRONTOKE=$(pwgen -cns -1 14) > /dev/null 2>&1
		mysql -e "GRANT ALL ON *.* TO 'admin'@'localhost' IDENTIFIED BY '$MYPASS' WITH GRANT OPTION" > /dev/null 2>&1
		mysql -e "FLUSH PRIVILEGES" > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo "${green}[SUCCESS] "
			tput sgr0
		else
			echo "${red}[ERROR] "
			tput sgr0
			exit
		fi
		log_n "${BLUE}Instaling PhpMyAdmin "
		echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections > /dev/null 2>&1
		echo "phpmyadmin phpmyadmin/mysql/admin-user string admin" | debconf-set-selections > /dev/null 2>&1
		echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MYPASS" | debconf-set-selections > /dev/null 2>&1
		echo "phpmyadmin phpmyadmin/mysql/app-pass password $MYPASS" |debconf-set-selections > /dev/null 2>&1
		echo "phpmyadmin phpmyadmin/app-password-confirm password $MYPASS" | debconf-set-selections > /dev/null 2>&1
		echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections > /dev/null 2>&1
		apt-get install -y phpmyadmin > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo "${green}[SUCCESS] "
			tput sgr0
		else
			echo "${red}[ERROR] "
			tput sgr0
			exit
		fi
		log_n "${BLUE}Setting Apache2 and MariaDB "
		cd /etc/apache2/sites-available/
		touch panel.conf
		FILE='panel.conf'
			echo "<VirtualHost *:80>">>$FILE
			echo "ServerAdmin hosting-rus@mail.ru">>$FILE
			echo "ServerName $DOMAIN">>$FILE
			echo "DocumentRoot /var/www">>$FILE
			echo "<Directory /var/www/>">>$FILE
			echo "Options Indexes FollowSymLinks">>$FILE
			echo "AllowOverride All">>$FILE
			echo "Require all granted">>$FILE
			echo "</Directory>">>$FILE
			echo "ErrorLog ${APACHE_LOG_DIR}/error.log">>$FILE
			echo "CustomLog ${APACHE_LOG_DIR}/access.log combined">>$FILE
			echo "</VirtualHost>">>$FILE
		cd 
		a2ensite panel > /dev/null 2>&1
		a2dissite 000-default > /dev/null 2>&1
		a2enmod rewrite > /dev/null 2>&1
		echo "Europe/Moscow" > /etc/timezone > /dev/null 2>&1
		sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php/7.0/apache2/php.ini > /dev/null 2>&1
		sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 90M/g" /etc/php/7.0/apache2/php.ini > /dev/null 2>&1
		sed -i "s/post_max_size = 8M/post_max_size = 360M/g" /etc/php/7.0/apache2/php.ini > /dev/null 2>&1
		sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf > /dev/null 2>&1
		sed -i 's/#max_connections        = 100/max_connections        = 1000/g' /etc/mysql/mariadb.conf.d/50-server.cnf > /dev/null 2>&1
		service apache2 restart > /dev/null 2>&1
		service mysql restart > /dev/null 2>&1
		rm -rf /var/www/html > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo "${green}[SUCCESS] "
			tput sgr0
		else
			echo "${red}[ERROR] "
			tput sgr0
			exit
		fi
		log_n "${BLUE}Setting Cronrab "
		(crontab -l ; echo "0 0 * * * curl http://127.0.0.1/main/cron/index?token=$CRONTOKE") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
		(crontab -l ; echo "*/1 * * * * curl http://127.0.0.1/main/cron/gameServers?token=$CRONTOKE") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
		(crontab -l ; echo "*/5 * * * * curl http://127.0.0.1/main/cron/updateSystemLoad?token=$CRONTOKE") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
		(crontab -l ; echo "*/5 * * * * curl http://127.0.0.1/main/cron/gamelocationstatsupd?token=$CRONTOKE") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
		(crontab -l ; echo "0 */10 * * * curl http://127.0.0.1/main/cron/serverReloader?token=$CRONTOKE") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
		(crontab -l ; echo "*/30 * * * * curl http://127.0.0.1/main/cron/updateStats?token=$CRONTOKE") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
		(crontab -l ; echo "*/30 * * * * curl http://127.0.0.1/main/cron/stopServers?token=$CRONTOKE") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
		(crontab -l ; echo "*/30 * * * * curl http://127.0.0.1/main/cron/stopServersQuery?token=$CRONTOKE") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
		(crontab -l ; echo "0 * */7 * * curl http://127.0.0.1/main/cron/clearLogs?token=$CRONTOKE") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
		service cron restart > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo "${green}[SUCCESS] "
			tput sgr0
		else
			echo "${red}[ERROR] "
			tput sgr0
			exit
		fi
		log_n "${BLUE}Creating and Upload Database "
		mkdir /var/lib/mysql/host > /dev/null 2>&1
		chown -R mysql:mysql /var/lib/mysql/host > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo "${green}[SUCCESS]"
			tput sgr0
		else
			echo "${red}[ERROR]"
			tput sgr0
			exit
		fi
		log_n "================== Настройка вдс под Панель на Ubuntu	завершена  =================="
		Error_n "${green}Адрес : ${white}http://$DOMAIN"
		Error_n "${green}Адрес phpmyadmin : ${white}http://$DOMAIN/phpmyadmin"
		Error_n "${green}Ваш Cron Token : ${white} $CRONTOKE"
		Error_n "${green}Данные для входа в phpmyadmin (база панели) :"
		Error_n "${green}Пользователь : ${white}admin"
		Error_n "${green}Пароль : ${white}$MYPASS"
		Error_n "${green}Мониторинг нагрузки сервера : ${white}htop"
		Error_n "${green}Пропишите ключ сайта и секретный ключ от рекапчи в конфигурации панели. "
		log_n "===============================  ==============================="
		Info
		log_tt "${white}Добро пожаловать в установочное меню ${BLUE}"
		Info "- ${white}1 ${green}- ${white}Выход в главное меню "
		Info "- ${white}0 ${green}- ${white}Выход из установщика "
		log_s
		Info
		read -p "Пожалуйста, введите пункт меню: " case
		case $case in
		  1) menu;;
		  0) exit;;
		esac
	else
		Info
		log_tt "${white}К сожалению, настройка панели возможна только на Ubuntu 18.04"
		Info "- ${white}0 ${green}- ${white}Выход"
		log_s
		Info
		read -p "Пожалуйста, введите пункт меню: " case
		case $case in
		  0) exit;;
		esac
	fi
}

menu()
{
 clear
 
 log_s
 log_tt "${white}Добро пожаловать в установочное меню ${BLUE}"
 
 Info "- ${white}1 ${green}- ${white}Настроить веб-часть"
 Info "- ${white}2 ${green}- ${white} (Скоро перенесу локации под Ubuntu )"
 Info "- ${white}0 ${green}- ${white}Выход "
 log_s
 Info
 read -p "Пожалуйста, введите пункт меню: " case
 case $case in
  1) install_panel;;     
  2) install_location;;
  0) exit;;
 esac
}
menu
