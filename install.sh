#!/bin/bash


name=$(whoami)

if [ $name != "root" ]; then
echo "You must be root or sudo to continue installation"
echo "Please log in as root or sudo and try again."


else

# hdir=$(zenity --entry --hide-text --title "Installing TclText" --text "Enter non-root your username:")
echo "enter your user name, please"

read hdir

echo "Installing Tickle Text..."

echo "Creating config files..."

mkdir /home/root/.tcltext
mkdir /home/$hdir/.tcltext
chmod a+rw /home/$hdir/.tcltext
cp tcltext.conf /home/$hdir/.tcltext
cp tcltext.conf /home/root/.tcltext
chmod a+rw /home/$hdir/.tcltext/tcltext.conf
chmod a+rw /home/root/.tcltext/tcltext.conf

echo "Moving files"

cp tcltext.tcl /usr/local/bin/tcltext
cp tdict.tcl /usr/local/bin/tdict
cp ticklecal /usr/local/bin/ticklecal
cp tcalcu.tcl /usr/local/bin/tcalcu
cp tickletext.gif /usr/share/tcltxt.gif

echo "Configuring permissions"

cd /usr/local/bin
chmod a+x tcltext
chmod a+x tdict
chmod a+x ticklecal
chmod a+x tcalcu

echo "Installation complete!"
echo "Thank you for using TickleText"
echo "To run TickleText, in terminal type tcltext, or make an icon/menu item/short cut to /usr/local/bin/tcltext"
echo "Enjoy!"

zenity --question --title Done --text "Installation of TickleText is now complete for $hdir and r00t!\n To install for other users, run install again, entering their name.\nTo run TickleText, in terminal type tcltext,\n or make an icon/menu item/short cut to /usr/local/bin/tcltext.\n Would you like tickle some text now?"

echo "Installation of Tcl Text for $hdir is now complete. To run TickleText, in terminal type tcltext,\n or make an icon/menu item/short cut to /usr/local/bin/tcltext."

fi
exit