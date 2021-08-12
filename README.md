# Shell-scripting
## Shell Scripting: A Project-Based Approach <br/>
## Technologies and Tools <br/>
![](https://img.shields.io/badge/🐧%20OS-Linux-brightgreen) ![](https://img.shields.io/badge/🧰%EF%B8%8FShell-Bash-brightgreen) ![](https://img.shields.io/badge/👷%20Version%20Control-Git-brightgreen) ![](https://img.shields.io/badge/☁%EF%B8%8F%20Cloud-Vagrant-brightgreen) ![](https://img.shields.io/badge/🛠%EF%B8%8F%20Tools-CentOS%207-brightgreen)

**Goal:** <br/>
The goal of this repository is to run shell scripts in a local Linux lab environment. Once you have the environment
configured you can quickly and easily create and destroy Linux virtual machines on your Windows,
Mac, or Linux computer.

*First Part of Scripting* <br/>
Add users to a Linux system <br/>
All basics in the process <br/>

*Second Part of Scripting* <br/>
Text and data manipluation through pipes<br/>
Handling command line arguments <br/>
Using special positional parameters <br/>
Generating random Passwords <br/>

*Additionally* <br/>
Using for and while loops <br/>
Mastering I/O <br/>
Linux programming conventions <br/>

## How to run <br/>
Install an SSH Client (Windows Users Only)  <br/>
SSH, secure shell, is the network protocol used to connect to Linux systems. By default Windows
doesn’t include an SSH client. Mac and Linux do, so Mac and Linux users should skip this step.
In order to get an SSH client on Windows you can install Git. Git is used for version control, but
we’re interested in the SSH client that it ships with. Download git here:
https://git-scm.com/download/win <br/>
Start the installer. Be sure to select "Use Git and optional Unix tools from The Windows Command
Prompt" when presented with the option. Otherwise, use the defaults. If you're asked for an
administrator user and password, be sure to enter it.

Install VirtualBox (All Users) <br/>
Download VirtualBox from https://www.virtualbox.org/wiki/Downloads. If you are using
Windows, download the file from the windows subdirectory. If you are using a Mac, download the
file from the mac subdirectory. If you are using RedHat or Centos, download the file from the centos
directory. 

Install Vagrant (All Users) <br/>
   Download Vagrant from https://www.vagrantup.com/downloads.html If you are using Windows,
download the file from the windows subdirectory. If you are using a Mac, download the file from the
mac subdirectory. If you are using RedHat or CentOS, download the file from the centos directory. <br/>
   Install the software on your local machine, accepting all the defaults. If you're asked for an
administrator user and password, be sure to enter it. Reboot your system if requested by the
installer. <br/>

## Start a Command Line Session (All Users) <br/>
First, start a command line session on your local machine.
For Windows users, start the Command Prompt. (Click the Start button. In the Search box,
type "Command Prompt", and then, in the list of results, double-click Command Prompt.)
For Mac users, start the Terminal application which is located in the /Applications/Utilities
folder. <br/>
For Linux users, start your favorite terminal emulator. Examples include GNOME Terminal,
Konsole, and xterm. <br/>
**Add a Box to Vagrant** <br/>
A "box" in Vagrant speak is an operating system image. The "vagrant box add " command will
download and store that box on your local system. You only need to download a box once as this
image will be cloned when you create a new virtual machine with Vagrant using the box’s name.
I created a box specifically for this class and uploaded it to the public Vagrant box catalog. Run the
following command on your local machine to download it. <br/>
`vagrant box add jasonc/centos7` <br/>
The format of the command when downloading a public box is "vagrant box add USER/BOX".
There are several public boxes available to download. You can search for boxes here, but be sure to
use the "jasonc/centos7" box for this class. https://app.vagrantup.com/boxes/search <br/>

## Create a Working Folder <br/>
When the Command Prompt (Windows) or the Terminal (Mac/Linux) is launched you will be placed in
your home directory. For example, if I’m logged into a Windows system as "jason" my home
directory could be "C:⧵Users⧵user". (Note: this might vary depending on the version of Windows
you are using.) If I’m logged into a Mac system as "user" my home directory will be "/Users/user".
If I'm logged into a Linux system as "user" my home directory will be "/home/user". <br/>
Create a folder to keep your course work in. <br/>
`mkdir shell-scripting` <br/>
Change into the Working Folder
Now let's move into the folder we just created. <br/>
`cd shell-scripting` <br/>
*Create a Vagrant Project Folder* <br/>
Vagrant uses the concept of projects. A Vagrant project must consist of a folder and a Vagrant
configuration file, called a Vagrantfile. Start out by creating a "testbox01" folder. <br/>
`mkdir testbox01` <br/>
*Create Your First Vagrant Files* <br/>
To create the Vagrant configuration file (Vagrantfile), run the "vagrant init <BOX_NAME> "
command. Be sure to be in Vagrant project directory you just created. Also, use the
"jasonc/centos7" box you downloaded earlier. <br/>
`cd testbox01` <br/>
`vagrant init jasonc/centos7` <br/>
## Create Your First Virtual Machine <br/>
The first time you run the "vagrant up " command Vagrant will import (clone) the vagrant box into
VirtualBox and start it. If Vagrant detects that the virtual machine already exists in VirtualBox it will
simply start it. By default, when the virtual machine is started, it is started in headless mode
meaning there is no UI for the machine visible on your local host machine. <br/> 
Bring up your first virtual machine running Linux with Vagrant. <br/>
`vagrant up`
## Now it is ready to test scripts <br/>
Once all installments and configurations are done, you can download repository files and copy them to the Vagrant Project folder. For example: <br/>
`cd shell-scripting/testbox01` <br/>
`vagrant up` <br/>
`./luser-demo01.sh` <br/>







