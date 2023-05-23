#!/bin/sh

INTRO_TEXT="\033[1;34m"
NORMAL="\033[0m"
MENU="\033[1;36m"
NUMBER="\033[1;33m"
RED_TEXT="\033[1;31m"
END="\033[0m"
ENTER_LINE="\033[1;36m"

extractinitrd() {
    echo "Extract and prepare the working directories"                                 
    if [ -d /tmp/inittmp/ ]
    then
        read -r -p "Found the folder /tmp/inittmp/, Do you want to delete it? (y/n)? " yn
        case $yn in
            [Yy]* ) 
                echo "Removing /tmp/inittmp/"
                sudo rm -rf /tmp/inittmp/  
                sudo mkdir /tmp/inittmp/                                                              
                sudo mkdir /tmp/inittmp/extracted/                                                    
                cp initrd /tmp/inittmp/                                                        
                cd /tmp/inittmp                                                                  
                unmkinitramfs initrd ./extracted    
                if ! ls /tmp/inittmp/extracted/main/lib/modules/ | grep generic                                         
                then
                    echo "Something went wrong, not all files were extracted. pls see help"
                    exit
                fi
                ver=$(ls /tmp/inittmp/extracted/main/lib/modules/ | grep generic)
                echo "The initrd kernel is $ver"
                cd extracted  && ls -la
                cd main && ls -la
                echo
                echo "Your extracted initrd is in /tmp/inittmp/"
                echo
                ;;
            [Nn]* ) 
                echo "Not removing existing /tmp/inittmp/"
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
            echo "Something went wrong, not all files were extracted. pls see help"
            exit
        fi
        ver=$(ls /tmp/inittmp/extracted/main/lib/modules/ | grep generic)
        echo "The initrd kernel is $ver"                                   
        cd extracted  && ls -la
        cd main && ls -la
        echo ""
        echo "Your extracted initrd is in /tmp/inittmp/"
        echo ""
    fi
    return_FN                                                                                                      
}

# Other functions go here

return_FN() {
    read -r -p "Return to menu (y/n)? " yn
    case $yn in 
        [Yy]* ) MENU_FN;;
        [Nn]* ) exit;;
        * ) echo 'Please answer yes or no.';;
    esac
}

# Menu function and other functions go here

PRECHECK() {
    if  [ -f initrd ]
    then
        MENU_FN
    else
        echo "You need to have an initrd file in this folder to run the script"
        exit
    fi
}

PRECHECK
