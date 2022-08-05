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
				sudo pacman -Syu
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
							sudo pacman -S cadence pulseaudio-jack alsa-utils --noconfirm
							((a++))

						elif [[ "2" == "$aud" ]]; then

							printf "\n"
							printf "Installing Pipewire packages\n"
							echo "NOTE: When prompted, select (y)es to remove pulseaudio and pulseaudio-bluetooth."
							# alsa-utils: For alsamixer (to increase base level of sound card)
							sudo pacman -S pipewire pipewire-alsa pipewire-jack pipewire-pulse alsa-utils helvum

							echo "/usr/lib/pipewire-0.3/jack" | sudo tee /etc/ld.so.conf.d/pipewire-jack.conf
							sudo ldconfig
							((a++))

						else

							printf "\n"
							printf "Sorry that number is not available,Try again"

						fi

					done

				###Grub stuff
				printf "\n"
				printf "Modifiying GRUB\n"
				sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet threadirqs cpufreq.default_governor=performance"/g' /etc/default/grub
				sudo grub-mkconfig -o /boot/grub/grub.cfg

				###Sysctl.conf
				printf "\n"
                		printf "Modifiying  /etc/sysctl.conf"
				# See https://wiki.linuxaudio.org/wiki/system_configuration for more information.
				echo 'fs.inotify.max_user_watches=600000' | sudo tee -a /etc/sysctl.conf

				###Limits
				printf "\n"
                		printf "Modify limits.d/audio.conf\n"
				# See https://wiki.linuxaudio.org/wiki/system_configuration for more information.
				echo '@audio - rtprio 90
				@audio - memlock unlimited' | sudo tee -a /etc/security/limits.d/audio.conf

				###Adding usr to group
				printf "\n"
				printf "Add ourselves to the audio group\n"
				sudo usermod -a -G audio $USER

				clear
				
				###Optional DAW
				clear
		        	dawt="Choose what DAW's to install"
				printf "%*s\n" $(((${#title}+$COLUMNS)/2))  "$dawt"
               			printf "\n"
               			printf "1. Bitwig\n"
                		printf "\n"
                		printf "2. Reaper\n"
                		printf "\n"
                		printf "3. Ardour\n"
                		printf "\n"
				printf "4. LMMS\n"
                		printf "\n"
				printf "5. Qtractor\n"
				printf "\n"
				printf "6. Rosegarden\n"
				printf "\n"
				printf "7. MusE\n"
				printf "\n"
				printf "8. Don't install any DAW"
				printf "\n"
				printf "\n"

				read -p "Pick A number: " daw

					case $daw in
						'1')

							###Bitwig
							printf "\n"
							printf "Installing Bitwig\n"
							yay -S bitwig-studio --noconfirm

						;;

						'2')

							###Reaper
							printf "\n"
							printf "Installing Reaper\n"
							sudo pacman -S wget --noconfirm
							wget -O reaper.tar.xz http://reaper.fm/files/6.x/reaper658_linux_x86_64.tar.xz
							mkdir ./reaper
							tar -C ./reaper -xf reaper.tar.xz
							sudo ./reaper/reaper_linux_x86_64/install-reaper.sh --install /opt --integrate-desktop --usr-local-bin-symlink
							rm -rf ./reaper
							rm reaper.tar.xz

						;;

						'3')

							###Ardour
							printf "\n"
							printf "Installing Ardour\n"
							sudo pacman -S ardour --noconfirm

						;;

						'4')

							###LMMS
							printf "\n"
							printf "Installing LMMS\n"
							sudo pacman -S lmms --noconfirm

						;;

						'5')

							###Qtractor
							printf "\n"
							printf "Installing Qtractor\n"
							sudo pacman -S qtractor --noconfirm

						;;

						'6')

							###Rosegarden
							printf "\n"
							printf "Installing Rosegarden"
							sudo pacman -S rosegarden --noconfirm

						;;

						'7')

							###MusE
							printf "\n"
							printf "Installing MusE\n"
							sudo pacman -S muse --noconfirm

						;;

						*)

							###Skip DAW Installation
							printf "\n"
							printf "Not Installing Any DAW"

						;;

				esac
				
				clear
				
				read -p "Do you want to install some Plugins(Yes to continue, press enter to skip): " plugin

					if [[ "Yes" == "$plugin" ]]; then

						### Adding Distrho-ports
						printf "\n"
						printf "Adding distrho-ports\n"
						sudo pacman -S distrho-ports --noconfirm
						clear

					else

						### Skipping Distrho-ports
						printf "/n"
						printf "Ok Skipping...\n"

					fi

				clear

				read -p "Do you want to add windows VST support?(yes or no): " vst

					if [[ "yes" == "$vst" ]]; then

						###Enable multilib
						sudo cp /etc/pacman.conf /etc/pacman.conf.bak
						cat /etc/pacman.conf.bak | tr '\n' '\f' | sed -e 's/#\[multilib\]\f#Include = \/etc\/pacman.d\/mirrorlist/\[multilib\]\fInclude = \/etc\/pacman.d\/mirrorlist/g'  | tr '\f' '\n' | sudo tee /etc/pacman.conf
						sudo pacman -Syyu

						###Installing wine-staging
						###Fair warning: You may need to downgrade if wine-staging has regressions.
						###installing the downgrade package from AUR will allow you to accomplish that.
						###after which you must provide the wine-staging version you like.
						printf "Installing Wine-staging"
						sudo pacman -S wine-staging winetricks --noconfirm

						### Base wine packages required for proper plugin functionality
						winetricks corefonts

						yay -S yabridge-bin --noconfirm

						# Create common VST paths
						mkdir -p "$HOME/.wine/drive_c/Program Files/Steinberg/VstPlugins"
						mkdir -p "$HOME/.wine/drive_c/Program Files/Common Files/VST2"
						mkdir -p "$HOME/.wine/drive_c/Program Files/Common Files/VST3"

						# Add them into yabridge
						yabridgectl add "$HOME/.wine/drive_c/Program Files/Steinberg/VstPlugins"
						yabridgectl add "$HOME/.wine/drive_c/Program Files/Common Files/VST2"
						yabridgectl add "$HOME/.wine/drive_c/Program Files/Common Files/VST3"

						echo " Please read this carefully

						
						# Install Windows VST plugins
						This is a manual step for you to run when you download plugins.
						First, run the plugin installer .exe file
						When the installer asks for a directory, make sure you select
						one of the directories above.

						VST2 plugins:
						  	C:\Program Files\Steinberg\VstPlugins
						 OR
						  	C:\Program Files\Common Files\VST2

						VST3 plugins:
							C:\Program Files\Common Files\VST3

							Each time you install a new plugin, you need to run:
							yabridgectl sync
						" > ~/Readme.txt

						clear
						printf "There's a Readme.txt on your home user directory, please read it as it contains critical information on your vst bridging\n"
						printf "\n"
						printf "please reboot and thank you for using the script"
						printf "\n"

						((e++))

				elif [[ "no" == "$vst" ]]; then

						clear
						printf "\n"
						printf "please reboot and thank you for using the script! "
						printf "\n"

						((e++))

				else

						printf "\n"
						printf "done, please reboot and thank you for using the script!"
						printf "\n"

						((e++))

				fi

			elif [[ "2" == "$NUMANS" ]]; then

				###Manual Guided Installation
				clear
				submen = "Sub Menu(For Advanced Users.)\n"
				printf "%*s\n" $(((${#title}+$COLUMNS)/2))  "$submen"

				###SubMen
               			printf "\n"
                		printf "1. Do Core system modification(GRUB, Sysctl.conf, Limits, Adding User to group\n"
                		printf "\n"
                		printf "2. Install Audio Servers?\n"
                		printf "\n"
                		printf "3.Adding Distrho-ports\n"
                		printf "\n"
				printf "4.Install DAWS\n"
				printf "\n"
				printf "5. Add Windows VST Support\n"
                		printf "\n"
				printf "6. Exit Submenu"
				printf "\n"
				printf "\n"

				read -p "Pick A number: " sub

					case $sub in
						'1')

							###Update
							printf "\n"
                					printf "Updating The system\n"
							sudo pacman -Syu

							###Grub stuff
							printf "\n"
							printf "Modifiying GRUB\n"
							sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet threadirqs cpufreq.default_governor=performance"/g' /etc/default/grub
							sudo grub-mkconfig -o /boot/grub/grub.cfg

							###Sysctl.conf
							printf "\n"
                					printf "Modifiying  /etc/sysctl.conf\n"
							# See https://wiki.linuxaudio.org/wiki/system_configuration for more information.
							echo 'fs.inotify.max_user_watches=600000' | sudo tee -a /etc/sysctl.conf

							###Limits
							printf "\n"
                					printf "Modify limits.d/audio.conf"
							# See https://wiki.linuxaudio.org/wiki/system_configuration for more information.
							echo '@audio - rtprio 90
							@audio - memlock unlimited' | sudo tee -a /etc/security/limits.d/audio.conf

							###Adding usr to group
							printf "\n"
							printf "Add ourselves to the audio group\n"
							sudo usermod -a -G audio $USER

							clear

						;;

						'2')

							### Audio Drivers
							printf "\n"
							printf "What audio server do you want?\n"
							printf "\n"
							printf "1.JACK + Pulseaudio\n"
							printf "\n"
							printf "2.Pipewire\n"
							printf "\n"

							read -p "Please enter a number to continue: \n" aud

							while [ $a -le 1 ]

								do

									if [[ "1" == "$aud" ]]; then

										### pulseaudio-jack: To bridge pulse to jack using Cadence
										### alsa-utils: For alsamixer (to increase base level of sound card)
										printf "\n"
										printf "Installing  JACK + Pulseaudio  packages\n"
										sudo pacman -S cadence pulseaudio-jack alsa-utils --noconfirm
										((a++))

									elif [[ "2" == "$aud" ]]; then

										printf "\n"
										printf "Installing Pipewire packages\n"
										echo "NOTE: When prompted, select (y)es to remove pulseaudio and pulseaudio-bluetooth."
										# alsa-utils: For alsamixer (to increase base level of sound card)
										sudo pacman -S pipewire pipewire-alsa pipewire-jack pipewire-pulse alsa-utils helvum
										echo "/usr/lib/pipewire-0.3/jack" | sudo tee /etc/ld.so.conf.d/pipewire-jack.conf
										sudo ldconfig
										((a++))

									else

										printf "\n"
										printf "Sorry that number is not available,Try again\n "

								fi

							done

						;;

						'3')

							### Adding Distrho-ports
							printf "\n"
							printf "Adding distrho-ports\n"
							sudo pacman -S distrho-ports --noconfirm
							clear

						;;

						'4')

							###Optional DAW
							dawt="Choose what DAW's to install"
							printf "%*s\n" $(((${#title}+$COLUMNS)/2))  "$dawt"
							printf "\n"
							printf "1. Bitwig\n"
							printf "\n"
							printf "2. Reaper\n"
							printf "\n"
							printf "3. Ardour\n"
							printf "\n"
							printf "4. LMMS\n"
							printf "\n"
							printf "5. Qtractor\n"
							printf "\n"
							printf "6. Rosegarden\n"
							printf "\n"
							printf "7. MusE\n"
							printf "\n"
							printf "8. Don't install any DAW"
							printf "\n"
							printf "\n"

							read -p "Pick A number: " daw

								case $daw in
									'1')

										###Bitwig
										printf "\n"
										printf "Installing Bitwig\n"
										yay -S bitwig-studio --noconfirm

									;;

									'2')

										###Reaper
										printf "\n"
										printf "Installing Reaper\n"
										sudo pacman -S wget --noconfirm
										wget -O reaper.tar.xz http://reaper.fm/files/6.x/reaper658_linux_x86_64.tar.xz
										mkdir ./reaper
										tar -C ./reaper -xf reaper.tar.xz
										sudo ./reaper/reaper_linux_x86_64/install-reaper.sh --install /opt --integrate-desktop --usr-local-bin-symlink
										rm -rf ./reaper
										rm reaper.tar.xz

									;;

									'3')

										###Ardour
										printf "\n"
										printf "Installing Ardour\n"
										sudo pacman -S ardour --noconfirm

									;;

									'4')

										###LMMS
										printf "\n"
										printf "Installing LMMS\n"
										sudo pacman -S lmms --noconfirm

									;;

									'5')

										###Qtractor
										printf "\n"
										printf "Installing Qtractor\n"
										sudo pacman -S qtractor --noconfirm

									;;

									'6')

										###Rosegarden
										printf "\n"
										printf "Installing Rosegarden\n"
										sudo pacman -S rosegarden --noconfirm

									;;

									'7')

										###MusE
										printf "\n"
										printf "Installing MusE\n"
										sudo pacman -S muse --noconfirm

									;;

									*)

										###Skip DAW Installation
										printf "\n"
										printf "Not Installing Any DAW\n"

									;;

							esac

							clear

						;;

						'5')
							###Enable multilib
							sudo cp /etc/pacman.conf /etc/pacman.conf.bak
							cat /etc/pacman.conf.bak | tr '\n' '\f' | sed -e 's/#\[multilib\]\f#Include = \/etc\/pacman.d\/mirrorlist/\[multilib\]\fInclude = \/etc\/pacman.d\/mirrorlist/g'  | tr '\f' '\n' | sudo tee /etc/pacman.conf
							sudo pacman -Syyu

							###Installing wine-staging
							###Fair warning: You may need to downgrade if wine-staging has regressions.
							###installing the downgrade package from AUR will allow you to accomplish that.
							###after which you must provide the wine-staging version you like.
							printf "Installing Wine-staging"
							sudo pacman -S wine-staging winetricks --noconfirm

							### Base wine packages required for proper plugin functionality
							winetricks corefonts

							yay -S yabridge-bin --noconfirm

							# Create common VST paths
							mkdir -p "$HOME/.wine/drive_c/Program Files/Steinberg/VstPlugins"
							mkdir -p "$HOME/.wine/drive_c/Program Files/Common Files/VST2"
							mkdir -p "$HOME/.wine/drive_c/Program Files/Common Files/VST3"

							# Add them into yabridge
							yabridgectl add "$HOME/.wine/drive_c/Program Files/Steinberg/VstPlugins"
							yabridgectl add "$HOME/.wine/drive_c/Program Files/Common Files/VST2"
							yabridgectl add "$HOME/.wine/drive_c/Program Files/Common Files/VST3"

							echo " Please read this carefully

							
							# Install Windows VST plugins
							This is a manual step for you to run when you download plugins.
							First, run the plugin installer .exe file
							When the installer asks for a directory, make sure you select
							one of the directories above.

							VST2 plugins:
								C:\Program Files\Steinberg\VstPlugins
							OR
								C:\Program Files\Common Files\VST2

							VST3 plugins:
								C:\Program Files\Common Files\VST3

								Each time you install a new plugin, you need to run:
								yabridgectl sync
							" > ~/Readme.txt

							clear
							printf "There's a Readme.txt on your home user directory, please read it as it contains critical information on your vst bridging\n"
							printf "\n"

						;;

						'6')

							###Go back to main
							printf "go back to main\n"
							clear
							
						;;

						*)

							###Default
							printf "\n"
							printf "Error, Going back to main..."
							clear

						;;

				esac




			elif [[ "3" == "$NUMANS" ]]; then

				###This is where the we terminate the script
				clear
				printf "\nThank you for using this script!\n"
				printf "\n"
				((e++))

			else

				printf "Sorry try again."

		fi

done
