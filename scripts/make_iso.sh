#!/bin/bash

################################################################################
# Name    : make_iso.sh                                                        #
# Author  : Ibrahim Musayev                                                    #
# Purpose : creates a new ISO image named CentOS-7-x86_64.iso and includes     #
#           latest version of kickstart script.                                #
# History : 15.05.23 Ibrahim Musayev, creation                                 #
################################################################################

iso_file="CentOS-7-x86_64-Everything-2009.iso"
new_iso_name="CentOS-7-x86_64.iso"
downloads_dir="$HOME/Downloads"
new_iso_dir=$downloads_dir/iso
mnt_iso_dir="/mnt/iso"
tmp_workdir="/tmp/workdir"
tmp_workdir_iso="$tmp_workdir/iso"
kickstart_dir="$tmp_workdir_iso/kickstart"
ks_cfg=$1

# Check if the kickstart script name is provided
if [ -z "$1" ]; then
  read -p "Please provide the name of the kickstart script: " ks_cfg
else
  ks_cfg=$1
fi

# Check if the ISO file exists in the Downloads folder and proceed further
if [ -f "$downloads_dir/$iso_file" ]; then
    echo "ISO file found in Downloads folder..."
    # Check if the /mnt/iso directory exists
    if [ ! -d "$mnt_iso_dir" ]; then
        echo "Creating $mnt_iso_dir directory..."
        sudo mkdir -p "$mnt_iso_dir"
    else
        echo "Unmount $mnt_iso_dir directory before starting..."
        sudo umount $mnt_iso_dir
    fi

    # Check if the /tmp/workdir directory exists
    if [ ! -d "$tmp_workdir" ]; then
        echo "Creating $tmp_workdir directory..."
        sudo mkdir -p "$tmp_workdir"
    else
        echo "Cleaning $tmp_workdir directory..."
        sudo rm -rf $tmp_workdir/*
    fi

    # Check if the $HOME/Downloads/iso directory exists
    if [ ! -d "$new_iso_dir" ]; then
        echo "Creating $new_iso_dir directory..."
        sudo mkdir -p "$new_iso_dir"
    else
        echo "Cleaning $new_iso_dir directory..."
        sudo rm -rf $new_iso_dir/*
    fi
  
    # Mount the ISO file to /mnt/iso directory
    sudo mount "$downloads_dir/$iso_file" "$mnt_iso_dir"
    sleep 3
    echo "ISO file mounted to $mnt_iso_dir and copying contents to $tmp_workdir"
    sudo cp -Rpf $mnt_iso_dir $tmp_workdir
    sleep 2
    if [ $? -eq 0 ]; then
      echo "Directory copied successfully."    
      echo "The $kickstart_dir directory doesn't exist. Creating it..."
      sudo mkdir -p "$kickstart_dir"
      sudo cp -p "$ks_cfg" "$kickstart_dir/ks.cfg"
      sudo cp -p "isolinux.cfg" "$tmp_workdir_iso/isolinux/isolinux.cfg"
      # Check if the copy operation was successful
      if [ $? -eq 0 ]; then
          echo "Kickstart script copied successfully."
          echo "Creating a $new_iso_name File" && cd $tmp_workdir_iso
          sudo genisoimage -o $new_iso_name -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -V "CentOS 7 x86_64" -R -J -v -T .
          if [ $? -eq 0 ]; then
              echo "$new_iso_name File successfully created..."
              sudo mv $new_iso_name $new_iso_dir
              echo "The new file is moved to the $new_iso_dir directory..."
              sudo umount "$mnt_iso_dir"
          else
              echo "$new_iso_name File creation failed. Exiting..."
              exit 1
          fi
      else
          echo "Failed to copy the kickstart script. Exiting..."
          exit 1
      fi      
    else
      echo "Failed to copy the directory."
      exit 1
    fi
else
    echo "Please download the ISO file: $iso_file"
    echo "First you need a CentOS-7 ISO --> https://www.centos.org/download/"
    exit 1
fi
