TickleText 2.4 README:
----
  
![TclText](http://www.tonybaldwin.info/images/tcltext020314204513.jpg)

TickleText was created by Anthony Baldwin 
http://wiki.tonybaldwin.info
http://tonyb.us/tcltext

----

## DEPENDENCIES:

LaTeX and pdf functions depend upon enscript, pdflatex,
and latex2html.
Most gnu/linux distros, to my knowledge, will already have most of those
by default, but, if not, install with your distro's pkg manager
(apt, yum, pacman, whatever) or get them here:

* Enscript: http://www.codento.com/people/mtr/genscript/
* pdflatex: http://www.tug.org/applications/pdftex/
* latex2html: http://www.latex2html.org/

FTP tools require tcl package ftp

tcl ftp and http are part of tcllib.

If you don't have that, for most, it's as simple as
`aptitude/yum/apt-get/teacup install tcllib`

ActiveTcl distribution includes Tcllib.

----

tickle text requires:

* Tcl/Tk8.5 (or newer)

Get it here:
* http://www.activestate.com/ActiveTcl
or
* http://sourceforge.net/projects/tcl/

----

While tcl is cross-platform and most of tcltext will work on Windows,
I do not recommend tcltext for windows users.
You are free to try, but, I offer you no support.
Your OS sucks. Sorry.

As far as I know, everyting should work fine on any Linux,
or BSD system, and, possibly, OSX.

Installation for gnu/linux or OSX:

cd to the dir where you've downloaded
and extracted the tarball and do 
`tar -xf tcltext2.3.tar.gz`

or just clone the git repo, and cd to that dir.
Either way, do:

`./install.sh`

This should move all relevant scripts to
$HOME/bin, and properly change permissions,
as well as create a .tcltext directory in your home (and root's home)
to save configs.  
If you have difficulty, feel free to e-mail me.

TDict can be run on it's own, once this installation is run, as can the calculator,
and the calendar.
They'll be at 
* $HOME/bin/tdict
* $HOME/bin/tcalcu
* $HOME/bin/ticklecal
respectively.

----
This program was written by Anthony Baldwin
Other software by tony: http://wiki.tonybaldwin.info

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

