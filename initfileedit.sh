#!/bin/sh
extractinitrd()
{
echo "Extract and prepare the working directories"                                 
# -------------------------------------------                                 
if [ -d /tmp/inittmp/ ]
then
read -r -p "found the folder /tmp/inittmp/ , Do you whant to delete it? (y/n)?" yn
 case $yn in
    [Yy]* ) echo "Removing /tmp/inittmp/"
    sudo rm -rf /tmp/inittmp/  
    sudo mkdir /tmp/inittmp/                                                              
    sudo mkdir /tmp/inittmp/extracted/                                                    
    cp initrd /tmp/inittmp/                                                        
    cd /tmp/inittmp                                                                  
    unmkinitramfs initrd ./extracted    
    if ! ls /tmp/inittmp/extracted/main/lib/modules/ | grep generic                                         
    then
    echo "Something whent wrong, not all files were extracted. pls see help"
    exit
    fi
    ver=$(ls /tmp/inittmp/extracted/main/lib/modules/ | grep generic)
    echo "the initrd kernel is $ver"
    cd extracted  && ls -la
    cd main && ls -la
    echo
    echo "yout extracterd initrd is in /tmp/inittmp/ "
    echo
    ;;
    [Nn]* ) echo "Not removing existing /tmp/inittmp/"
        exit
        ;;
    * ) echo 'Please answer yes or no.';;
   esac
else
    echo "Creating folders and extracting initrd"
    sudo mkdir /tmp/inittmp/                                                              
    sudo mkdir /tmp/inittmp/extracted/                                                    
    cp initrd /tmp/inittmp/                                                          
    cd /tmp/inittmp                                                                  
    unmkinitramfs initrd ./extracted 
    if ! ls /tmp/inittmp/extracted/main/lib/modules/ | grep generic                                         
    then
    echo "Something whent wrong, not all files were extracted. pls see help"
    exit
    fi
    ver=$(ls /tmp/inittmp/extracted/main/lib/modules/ | grep generic)
    echo "the initrd kernel is $ver"                                   
    cd extracted  && ls -la
    cd main && ls -la
    echo ""
    echo "your extracterd initrd is in /tmp/inittmp/ "
    echo ""
fi
return                                                                                                      
}

recreate()
{
echo "This can take several minutes"
# Add the first microcode firmware                                            
# --------------------------------                                            
cd /tmp/inittmp/                                                                   
cd extracted                                                                  
cd early                                                                      
find . -print0 | cpio --null --create --format=newc > /tmp/inittmp/newinitrd      
                                                                              
# Add the second microcode firmware                                           
# ---------------------------------                                           
                                                                              
cd ../early2                                                                  
find kernel -print0 | cpio --null --create --format=newc >> /tmp/inittmp/newinitrd
                                                                              
# Add the ram fs file system                                                  
# --------------------------                                                  
                                                                              
cd ../main                                                                    
find . | cpio --create --format=newc | xz --format=lzma >> /tmp/inittmp/newinitrd 
return     
}

binwalkinitrd()
{
#binwalk initrd 
binwalk initrd
#binwalk newinitrd                                                           
binwalk newinitrd 
read -r -p "Return to menu (y/n)?" yn
 case $yn in 
[Yy]* ) MENU_FN
;;
[Nn]* ) exit
        exit
        ;;
    * ) echo 'Please answer yes or no.';;
   esac
exit                                                            
}
Checkfile()
{
file initrd
return
}
PRECHECK()
{
if  [ -f initrd ]
then
MENU_FN
else
echo "you need to have a initrd file in this folder to run the script"
exit
fi
}
helper()
{
echo "if the extracted folders has an empty main folder i can be because you the initrd is a different version from your system"
ehco "If so please boot to a system that have a match version as the initrd"
echo "you can not extract an ubuntu 20 initrd in a ubuntu 22 server/client"
exit
}
return()
{
read -r -p "Return to menu (y/n)?" yn
 case $yn in 
[Yy]* ) MENU_FN
;;
[Nn]* ) exit
        exit
        ;;
    * ) echo 'Please answer yes or no.';;
   esac
exit    
}
############################################## Menu #####################################
MENU_FN(){
clear
    echo "${INTRO_TEXT}                 initrd edit tool                          ${END}"
    echo "${INTRO_TEXT}               Created by Pierre Goude                     ${END}"
	echo "${INTRO_TEXT}      This script will edit several critical files..       ${END}"
	echo "${INTRO_TEXT}      DO NOT attempt this without expert knowledge         ${END}"
    echo "${NORMAL}                                                               ${END}"
    echo "${NORMAL} Please place the initrd file you wish to  edit in this folder ${END}"
    echo "${NORMAL}                                                               ${END}"
    echo "${MENU}*${NUMBER} 1)${MENU} Extract initrd file    ${END}"
    echo "${MENU}*${NUMBER} 2)${MENU} binwalk initrd    ${END}"
    echo "${MENU}*${NUMBER} 3)${MENU} Check file               ${END}"
	echo "${MENU}*${NUMBER} 4)${MENU} Create new initrd from extract  ${END}"
    echo "${MENU}*${NUMBER} 5)${MENU} Delete created /tmp/inittmp and extracted files${END}"
    echo "${MENU}*${NUMBER} 6)${MENU} HELP ${END}"
    echo "${NORMAL}                                                    ${END}"
    echo "${ENTER_LINE}Please enter a menu option and enter or ${RED_TEXT}ctrl + c to exit. ${END}"
	read -r opt
while [ "$opt" != '' ]
    do
    if [ "$opt" = "" ]; then
            exit;
    else
        case $opt in
    1) clear;
            echo "Extract initrd file";
            extractinitrd
            ;;

	2) clear;
	    echo "binwalk initrd"
	     binwalkinitrd
             ;;
	3) clear;
	     echo "Check file"
	     Checkfile  
             ;;
	4) clear;
	    echo "Create new initrd from extract"
	    recreate
            ;;
    5) clear;
	    echo "Delete created /tmp/inittmp"
	    sudo rm -rf /tmp/inittmp
        echo "/tmp/inittmp deleted"
        exit
            ;;
    6) clear;
	    echo "HELP"
	    helper
            ;;
        x)exit;
        ;;
       '\n')exit;
        ;;
        *)clear;
        opt "Pick an option from the menu";
        MENU_FN;
        ;;
    esac
fi
done
}
PRECHECK
