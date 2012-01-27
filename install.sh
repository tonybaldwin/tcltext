#!/bin/bash


name=$(whoami)

echo "Installing Tickle Text..."

if [ ! $HOME/bin/ ];
	# if you have no /home/you/bin, we make one to install tcltext in
	then mkdir $HOME/bin
fi

echo "Checking for configs, and setting them up if you don't have them..."

if [ ! $HOME/.tcltext ]
	# checking for config dir, if none, we make it
	then mkdir $HOME/.tcltext
fi
if [ ! $HOME/.tcltext/tcltext.conf ]
	# also checking to see if you have a .conf file, perhaps from a previous version.
	# we don't want to overwrite it, if you do, and lose your config
	# but if you have none, we copy in the prefab, with dummy vars
	then cp tcltext.conf $HOME/.tcltext/
fi

echo "Moving files"

cp tcltext.tcl $HOME/bin/tcltext
cp tdict.tcl $HOME/bin/tdict
cp ticklecal $HOME/bin/ticklecal
cp tcalcu.tcl $HOME/bin/tcalcu
cp tickletext.gif $HOME/.tcltext/tcltxt.gif

echo "Configuring permissions"

cd $HOME/bin
chmod +x tcltext
chmod +x tdict
chmod +x ticklecal
chmod +x tcalcu

echo "Installation complete!"
echo "Thank you for using TclText"
echo "To run TclText, in terminal type tcltext, or make an icon/menu item/short cut to $HOME/bin/tcltext"
echo "Enjoy!"

exit
