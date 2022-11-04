#!/bin/bash
#----------------------
#This is a script that will automatically configure your Arch for audio production.
#-----------------------
#Exit if the script fails
#This still on beta so it might change overtime!

notify () {

	echo "--------------------------------------------"
	echo "Audio Linux Production all in one script"
	echo "--------------------------------------------"
}


###Data variables (this will be used for the logic of the script)
e=1
a=1
d=1

###This will clear the terminal
clear

###User Agreement

COLUMNS=$(tput cols)
title="!!WARNING, MUST READ BEFORE DOING ANYTHING!!"

printf '\033[0;31m'
printf "%*s\n" $(((${#title}+$COLUMNS)/2))  "$title"
printf '\033[0m'
printf "\n"
printf "This script is a beta version, expect bugs and crashes.\nI dont guarantee that this will work on your pc\nUnder no circumstances that im realiable to any damage or data loss\nYou choose to download this script under your own will\nTherefore you must understand the consequences of running the script.\n"
printf "\n"

read -p "Please type 'I Understand'(Exactly like this) to continue: " ANS

		if [[ "I Understand" == "$ANS" ]]; then

			printf "Confirmed, Now proceeding\n"

			clear

		else

			printf "Not Confirmed, Exiting Script\n"
			exit

		fi
		
while [ $e -le 1 ]

	do

		###Main Menu
		main="What do you want to do?\n"
		printf "%*s\n" $(((${#title}+$COLUMNS)/2))  "$main"
		printf "\n"
		printf "1. Automate the proccess(Some User Input still required, Recommended for fresh install, automatically quits when done)\n"
		printf "\n"
		printf "2. Do things separately(Sub menu, Best for advanced users)\n"
		printf "\n"
		printf "3. Exit the script"
		printf "\n"
		printf "\n"

		read -p "Please enter the number of choice: " NUMANS

			if [[ "1" == "$NUMANS" ]]; then

				###Automated script
				clear

				printf "\n"
				printf "You must type the answer precisely. (AKA, yes = yes, No = No)\n"
				printf "The script will start in 5 seconds\n"
				sleep 5
				clear

				###Update
				printf "\n"
                printf "Updating The system"
				sudo apt update -y && sudo apt upgrade -y
				clear

				### Installing the Liquorix kernel (best optimized for audio production a debian/ubuntu based distro enviroment)
				### For documentation and such please refer to https://liquorix.net/
				printf "Installing the liquorix kernel"
				sudo add-apt-repository ppa:dametz/liquorix -y && sudo apt-get update
				sudo apt-get intall linux-image-liquorix-amd64 linux-headers-liquorix-amd64 -y
				clear
				
				### Audio Drivers
				printf "\n"
				printf "What audio server do you want?\n"
				printf "\n"
				printf "1.JACK + Pulseaudio\n"
				printf "\n"
				printf "2.Pipewire\n"
				printf "\n"

				read -p "Please enter a number to continue: " aud
				while [ $a -le 1 ]

					do

						if [[ "1" == "$aud" ]]; then

							### pulseaudio-jack: To bridge pulse to jack using Cadence
							### alsa-utils: For alsamixer (to increase base level of sound card)
							printf "\n"
							printf "Installing  JACK + Pulseaudio  packages\n"
							printf "simulating installing pulse + jack\n"
							clear
							((a++))

						elif [[ "2" == "$aud" ]]; then

							printf "\n"
							printf "Installing Pipewire packages\n"
							notify "Install Pipewire"
							sudo add-apt-repository ppa:pipewire-debian/pipewire-upstream -y
							sudo add-apt-repository ppa:pipewire-debian/wireplumber-upstream -y
							sudo apt update
							sudo apt install gstreamer1.0-pipewire libpipewire-0.3-{0,dev,modules} libspa-0.2-{bluetooth,dev,jack,modules} pipewire{,-{audio-client-libraries,pulse,bin,jack,alsa,v4l2,libcamera,locales,tests}} -y
							sudo apt install wireplumber{,-doc} gir1.2-wp-0.4 libwireplumber-0.4-{0,dev} -y
							systemctl --user --now disable pulseaudio.{socket,service}
							systemctl --user mask pulseaudio
							sudo cp -vRa /usr/share/pipewire /etc/
							systemctl --user --now enable pipewire{,-pulse}.{socket,service} filter-chain.service
							systemctl --user --now enable wireplumber.service
							clear
							((a++))

						else

							printf "\n"
							printf "Sorry that number is not available,Try again"

						fi

					done
					
				### Bootloader
				printf "\n"
				printf "What is your Bootloader?\n"
				printf "\n"
				printf "1.Grub\n"
				printf "\n"
				printf "2.Systemd-boot\n"
				printf "\n"

				read -p "Please enter a number to continue: " btlder
				while [ $d -le 1 ]

					do

						if [[ "1" == "$btlder" ]]; then
						
							###Modifiying GRUB
							printf "\n"
							printf "Modifiying GRUB\n"
							sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet threadirqs cpufreq.default_governor=performance"/g' /etc/default/grub
							sudo grub-mkconfig -o /boot/grub/grub.cfg
							clear
							((d++))

						elif [[ "2" == "$btlder" ]]; then
							
							###Modifiying Systemd-boot
							printf "Simulating modifiying systemd-boot\n"
							clear
							((d++))

						else

							printf "\n"
							printf "Sorry that number is not available,Try again"
							clear

						fi

					done
					
				###Modifiying cpu frequency
				printf "CPU Frequency modifier to max the performance/n"
				printf "\n"
				printf "On a laptop this will drain the battery faster, but will result in much better audio performance.\n"
				sleep 5
				sudo apt install cpufrequtils -y
				echo 'GOVERNOR="performance"' | sudo tee /etc/default/cpufrequtils
				
				###Sysctl.conf
				printf "\n"
                printf "Modifiying  /etc/sysctl.conf"
				# See https://wiki.linuxaudio.org/wiki/system_configuration for more information.
				echo 'fs.inotify.max_user_watches=600000' | sudo tee -a /etc/sysctl.conf
				
				###Installing kxstudio and cadence
				printf "Installing kxstudio and cadance/n"
				sudo apt-get install apt-transport-https gpgv -y
				wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_10.0.3_all.deb
				sudo dpkg -i kxstudio-repos_10.0.3_all.deb
				rm kxstudio-repos_10.0.3_all.deb
				sudo apt update
				sudo apt install cadence -y
