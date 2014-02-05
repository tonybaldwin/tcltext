#!/bin/sh

# a text editor written with Tcl8.5
# copyright anthony baldwin / tony@tonybaldwin.info/ http://tonyb.us/tcltext
# released according to the terms of the Gnu Public License v. 2 or later.
# just tricking tcl here\
exec wish8.5 -f "$0" ${1+"$@"}

package require ftp
package require http

uplevel #0 [list source ~/.tcltext/tcltext.conf]

## global variables

global butn
global wbg
global wtx
global brow
global doctype 
global title 
global author 
global lfont
global tpage 
global paper 
global columns 
global emal
global lang
global keywords
global lino
global filetypes
global wrap
global host
global filename

set filename " "
set currentfile " "
set wrap word

font create font  -family fixed

set novar "cows"
set allvars [list host path username txfg password author txbg emal brow wbg wtx novar]

## filetypes
################

set file_types {
{"All Files" * }
{"Text Files" { .txt .TXT}}
{"LaTex" {.tex}}
{"Tcl Scripts" {.tcl}}
{"Python" {.py}}
{"Perl" {.pl}}
{"PHP" {.php}}
{"Lua Scripts" {.lua}}
{"Java" {.java}}
{"C files" {.c}}
{"Shell scripts" {.sh}}
{"Xml" {.xml}}
{"Html" {.html}}
{"CSS" {.css}}
{"PowerShell Scripts" {.ps1}}
{"Visual Basic Scripts" {.vsb}}
{"AutoIt" {.au3}}
{"NuSpec Files" {.nuspec}}
}

# bindings
########################

bind . <Escape> leave
bind . <F1> {linenums .txt.txt}
bind . <Control-z> {catch {.txt.txt edit undo}}
bind . <Control-r> {catch {.txt.txt edit redo}}
bind . <Control-a> {.txt.txt tag add sel 1.0 end}
bind . <F4> specialbox
bind . <F3> {FindPopup}
bind . <Control-s> {file_save}
bind . <Control-b> {file_saveas}
bind . <Control-n> {eval exec tcltext &}
bind . <Control-t> {eval exec xterm &}
bind . <Control-p> {prnt}
bind . <Control-o> {OpenFile}
bind . <Control-q> {clear}
bind . <Control-d> {eval exec tdict}
bind . <F8> {prefs}
bind . <F7> {browz}
bind . <F6> {wwrap}
bind . <F5> {wordcount}
bind . <F2> {eval exec xterm /usr/bin/wish}
bind . <F11> {eval exec ticklecal}
bind . <F12> {eval exec tcalcu}
bind . <F9> {Comment}
bind . <F10> {Uncomment}

tk_setPalette background $::wbg foreground $::wtx


## icon
image  create  photo  tcltico -format GIF -file  ~/.tcltext/tcltxt.gif


## start the editor window
#####################################################

wm title . "TclText" 

######3
# Menus
#################################

# menu bar buttons
frame .fluff -bd 1 -relief groove

tk::menubutton .fluff.mb -text File -menu .fluff.mb.f 
tk::menubutton .fluff.ed -text Edit -menu .fluff.ed.t
tk::menubutton .fluff.lh -text "Web/LaTeX" -menu .fluff.lh.p
tk::menubutton .fluff.tul -text Tools -menu .fluff.tul.t 
tk::menubutton .fluff.clrs -text Display -menu .fluff.clrs.c 
tk::label .fluff.font1 -text "Font size:" 
ttk::combobox .fluff.size -width 4 -value [list 8 10 12 14 16 18 20 22 24 28] -state readonly

# file menu
#############################
menu .fluff.mb.f -tearoff 1
.fluff.mb.f add command -label "New" -command {eval exec tcltext &} -accelerator Ctrl+n
.fluff.mb.f add separator
.fluff.mb.f add command -label "Open" -command {OpenFile} -accelerator Ctrl+o
.fluff.mb.f add command -label  "Save" -command {file_save} -accelerator Ctrl+s
.fluff.mb.f  add command -label "SaveAs" -command {file_saveas} -accelerator Ctrl-b
.fluff.mb.f add command -label "Close" -command {clear} -accelerator Ctrl+q
.fluff.mb.f  add separator
.fluff.mb.f add command -label "Tcl Template" -command {tcltemp}
.fluff.mb.f add command -label "Perl Template" -command {pltemp}
.fluff.mb.f add command -label "Python Template" -command {pytemp}
.fluff.mb.f  add separator
.fluff.mb.f  add command -label "Print" -command {prnt} -accelerator Ctrl+p
.fluff.mb.f add command -label "Export to PDF" -command {pdfout} 
.fluff.mb.f add separator
.fluff.mb.f  add command -label "Quit" -command {leave} -accelerator Escape

# edit menu
######################################3
menu .fluff.ed.t -tearoff 1
.fluff.ed.t add command -label "Cut" -command cut_text -accelerator Ctrl+x
.fluff.ed.t add command -label "Copy" -command copy_text -accelerator Ctrl+c
.fluff.ed.t add command -label "Paste" -command paste_text -accelerator Ctrl+v
.fluff.ed.t add command -label "Select all"	-command ".txt.txt tag add sel 1.0 end" -accelerator Ctrl+a
.fluff.ed.t add command -label "Undo" -command {catch {.txt.txt edit undo}} -accelerator Ctrl+z
.fluff.ed.t add command -label "Redo" -command {catch {.txt.txt edit redo}} -accelerator Ctrl+r
.fluff.ed.t add command -label "Comment" -command {Comment} -accelerator F9
.fluff.ed.t add command -label "Uncomment" -command {Uncomment} -accelerator F10
.fluff.ed.t add separator
.fluff.ed.t add command -label "Search" -command {FindPopup} -accelerator F3
.fluff.ed.t add separator
.fluff.ed.t add comman -label "Toggle Word Wrap" -command {wwrap} -accelerator F6
.fluff.ed.t add command -label "Toggle Line Nos." -command {linenums .txt.txt} -accelerator F1
.fluff.ed.t add command -label "Word Count" -command {wordcount} -accelerator F5
.fluff.ed.t add command -label "Time Stamp" -command {indate}
.fluff.ed.t add command -label "Special Characters" -underline 0 -command specialbox -accelerator F4
.fluff.ed.t add separator
.fluff.ed.t add command -label "Preferences" -command {prefs} -accelerator F8

# html & latex tools menu
########################
menu .fluff.lh.p -tearoff 1
.fluff.lh.p add command -label "LaTeX Template" -command {textemp}
.fluff.lh.p add command -label "LaTeX to PDF" -command {texpdf} 
.fluff.lh.p add command -label "LaTeX to HTML" -command {texweb}
.fluff.lh.p add separator
.fluff.lh.p add command -label "HTML Template" -command {webtemp}
.fluff.lh.p add command -label "FTP" -command {setFTP}

# tools menu
################################
menu .fluff.tul.t -tearoff 1
.fluff.tul.t add command -label "Xterm" -command {eval exec xterm &} -accelerator Ctrl+t
.fluff.tul.t add command -label "Wish Shell" -command {eval exec xterm /usr/bin/wish} -accelerator F2
.fluff.tul.t add command -label "Tclsh" -command {exec xterm tclsh &}
.fluff.tul.t add command -label "Python shell" -command {exec xterm python &}
.fluff.tul.t add command -label "Ruby shell" -command {exec xterm irb &}
.fluff.tul.t add command -label "Lua shell" -command {exec xterm lua &}
.fluff.tul.t add command -label "cmd.exe" -command {exec "C:/Windows/system32/cmd.exe /c start &"}
.fluff.tul.t add command -label "Power Shell" -command {exec "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe /c start &"}
.fluff.tul.t add separator
.fluff.tul.t add command -label "Browser" -command {browz} -accelerator F7 
.fluff.tul.t add command -label "Dictionary" -command {eval exec tdict &} -accelerator Ctrl+d
.fluff.tul.t add command -label "Calendar" -command {eval exec ticklecal &} -accelerator F11
.fluff.tul.t add command -label "Calculator" -command {eval exec tcalcu &} -accelerator F12
.fluff.tul.t add separator
.fluff.tul.t add command -label "HELP!" -command {help}

tk::button .fluff.abt -image tcltico -command {about}

# pack ém in...
############################

pack .fluff.mb -in .fluff -side left
pack .fluff.ed -in .fluff -side left
pack .fluff.lh -in .fluff -side left
pack .fluff.tul -in .fluff -side left
pack .fluff.font1 -in .fluff -side left
pack .fluff.size -in .fluff -side left
pack .fluff.abt -in .fluff -side right

# font combobox binding

bind .fluff.size <<ComboboxSelected>> [list sizeFont .txt.txt .fluff.size]

pack .fluff -in . -fill x

# Here is the text widget
########################################TEXT WIDGET
# amazingly simple, this part, considering the great power in this little widget...
# of course, that's because someone a lot smarter than me built the widget already.
# that sure was nice of them...

frame .txt -bd 2 -relief sunken
text .txt.txt -yscrollcommand ".txt.ys set" -xscrollcommand ".txt.xs set" -wrap $::wrap -maxundo 0 -undo true -bg $::txbg -fg $::txfg

scrollbar .txt.ys -command ".txt.txt yview"
scrollbar .txt.xs -command ".txt.txt xview" -orient horizontal

pack .txt.xs -in .txt -side bottom -fill x
pack .txt.txt -in .txt -side left -fill both -expand true

pack .txt.ys -in .txt -side left -fill y
pack .txt -in . -fill both -expand true

focus .txt.txt
set foco .txt.txt
bind .txt.txt <FocusIn> {set foco .txt.txt}
bind .txt.txt <Return> {indent %W;break}

# toggle word wrap
###########################################

proc wwrap { } {

	if {$::wrap == "word" } {
	uplevel set wrap none
	.txt.txt configure -wrap none
	} else { 
	uplevel set wrap word 
	.txt.txt configure -wrap word 
	} 
}

## open a new tickle text for multiple editing
################################################3

proc tickle {} {
exec tcltext
}

proc sizeFont {txt combo} {
	set font [$txt cget -font]
	font configure $font -size [list [$combo get]]
}

# various saving / opening / exporting procs
################################################3

proc file_save {} {
	if {$::filename != " "} {
   set data [.txt.txt get 1.0 {end -1c}]
   set fileid [open $::filename w]
   puts -nonewline $fileid $data
   close $fileid
	} else {file_saveas}
 
}

proc file_saveas {} { 
global filename
set filename [tk_getSaveFile -filetypes $::file_types]
   set data [.txt.txt get 1.0 {end -1c}]
   wm title . "Now Tickling: [file tail $::filename]"
   set fileid [open $::filename w]
   puts -nonewline $fileid $data
   close $fileid
}

# save LaTeX to pdf
####################

proc texpdf {} {
	if {$::filename != " "} {
   set data [.txt.txt get 1.0 {end -1c}]
   set fileid [open $::filename w]
   puts -nonewline $fileid $data
   close $fileid
   eval exec pdflatex $::filename
	} else { 
	global filename
	set filename [tk_getSaveFile -filetypes $::file_types]
	set data [.txt.txt get 1.0 {end -1c}]
	wm title . "Now Tickling: [file tail $::filename]"
	set fileid [open $::filename w]
	puts -nonewline $fileid $data
	close $fileid
	eval exec pdflatex $::filename
	}   
}

## export to pdf
#######################33

proc pdfout {} {
	if {$::filename != " "} {
   set data [.txt.txt get 1.0 {end -1c}]
   set fileid [open $::filename w]
   puts -nonewline $fileid $data
   close $fileid
   eval exec enscript $::filename -q -B -p $::filename.ps
   eval exec ps2pdf $::filename.ps $::filename.pdf
   eval exec rm $::filename.ps
	}  else { 
   global filename
   set filename [tk_getSaveFile -filetypes $::file_types]
   set data [.txt.txt get 1.0 {end -1c}]
   wm title . "Now Tickling: [file tail $::filename]"
   set fileid [open $::filename w]
   puts -nonewline $fileid $data
   close $fileid
   eval exec enscript $::filename -q -B -p $::filename.ps
   eval exec ps2pdf $::filename.ps $::filename.pdf
   eval exec rm $::filename.ps
   }
   
}

## output LaTeX to html files
###############################

proc texweb {} {
if {$::filename !=  " "} {
eval exec latex2html $::filename $::filename.html
} else {
   set filename [tk_getSaveFile -filetypes $::file_types]
   set data [.txt.txt get 1.0 {end -1c}]
   wm title . "Now Tickling: [file tail $::filename]"
   set fileid [open $::filename w]
   puts -nonewline $fileid $data
   close $fileid
   eval exec latex2html $::filename $::filename.html
   }
}

# open
############################

proc OpenFile {} {

if {$::filename != " "} {
	eval exec tcltext &
	} else {
	global filename
	set filename [tk_getOpenFile -filetypes $::file_types]
	wm title . "Now Tickling: [file tail $::filename]"
	set data [open $::filename RDWR]
	.txt.txt delete 1.0 end
	while {![eof $data]} {
		.txt.txt insert end [read $data 1000]
		}
	close $data
	.txt.txt mark set insert 1.0
	}
}

# print it
############################PRINT

proc prnt {} {
	set data [.txt.txt get 1.0 {end -1c}]
	set fileid [open $::filename w]
	puts -nonewline $fileid $data
	close $fileid
	if { $::os == "Windows NT" } {
		#print routine for windows
		eval exec "C:/Windows/system32/cmd.exe /c start /min C:/Windows/system32/notepad.EXE /p $::filename"
	} elseif { $::os == "Linux" } {
		exec cat $::filename | lpr
	} else {sorry}
}

# about message box
####################################ABOUT

proc about {} {

toplevel .about
wm title .about "About TickleText"
# tk_setPalette background $::wbg 

tk::message .about.t -text "TickleText\n by Tony Baldwin\n tony@tonybaldwin.org\n A quick and ticklish text editor\n Released under the GPL\n For more info see README, or\n http://tonyb.us/tcltext\n" -width 270
tk::button .about.o -text "Okay" -command {destroy .about} 
pack .about.t -in .about -side top
pack .about.o -in .about -side top

}

# find/replace/go to line
############################################FIND REPLACE DIALOG

proc FindPopup {} {

global seltxt repltxt

toplevel .fpop 
# -width 12c -height 4c

wm title .fpop "Find Text"

frame .fpop.l1 -bd 2 -relief raised

tk::label .fpop.l1.fidis -text "FIND     :"
tk::entry .fpop.l1.en1 -width 20 -textvariable seltxt
tk::button .fpop.l1.finfo -text "Forward" -command {FindWord  -forwards $seltxt}
tk::button .fpop.l1.finbk -text "Backward" -command {FindWord  -backwards $seltxt}
tk::button .fpop.l1.tagall -text "Highlight All" -command {TagAll}

pack .fpop.l1.fidis -in .fpop.l1 -side left
pack .fpop.l1.en1 -in .fpop.l1 -side left
pack .fpop.l1.finfo -in .fpop.l1 -side left
pack .fpop.l1.finbk -in .fpop.l1 -side left
pack .fpop.l1.tagall -in .fpop.l1 -side left
pack .fpop.l1 -in .fpop -fill x

frame .fpop.l2 -bd 2 -relief raised

tk::label .fpop.l2.redis -text "REPLACE:"
tk::entry .fpop.l2.en2 -width 20 -textvariable repltxt
tk::button .fpop.l2.refo -text "Forward" -command {ReplaceSelection -forwards}
tk::button .fpop.l2.reback -text "Backward" -command {ReplaceSelection -backwards}
tk::button .fpop.l2.repall -text "Replace All" -command {ReplaceAll}

pack .fpop.l2.redis -in .fpop.l2 -side left
pack .fpop.l2.en2 -in .fpop.l2 -side left
pack .fpop.l2.refo -in .fpop.l2 -side left
pack .fpop.l2.reback -in .fpop.l2 -side left
pack .fpop.l2.repall -in .fpop.l2 -side left
pack .fpop.l2 -in .fpop -fill x

frame .fpop.l3 -bd 2 -relief raised

tk::label .fpop.l3.goto -text "Line No. :"
tk::entry .fpop.l3.line -textvariable lino
tk::button .fpop.l3.now -text "Go" -command {gotoline}
tk::button .fpop.l3.dismis -text Done -command {destroy .fpop}

pack .fpop.l3.goto -in .fpop.l3 -side left
pack .fpop.l3.line -in .fpop.l3 -side left
pack .fpop.l3.now -in .fpop.l3 -side left
pack .fpop.l3.dismis -in .fpop.l3 -side right
pack .fpop.l3 -in .fpop -fill x

# focus .fpop.en1
}

## all this find-replace stuff needs work...

proc FindWord {swit seltxt} {
global found
set l1 [string length $seltxt]
scan [.txt.txt index end] %d nl
scan [.txt.txt index insert] %d cl
if {[string compare $swit "-forwards"] == 0 } {
set curpos [.txt.txt index "insert + $l1 chars"]

for {set i $cl} {$i < $nl} {incr i} {
		
	#.txt.txt mark set first $i.0
	.txt.txt mark set last  $i.end ;#another way "first lineend"
	set lpos [.txt.txt index last]
	set curpos [.txt.txt search $swit -exact $seltxt $curpos]
	if {$curpos != ""} {
		selection clear .txt.txt 
		.txt.txt mark set insert "$curpos + $l1 chars "
		.txt.txt see $curpos
		set found 1
		break
		} else {
		set curpos $lpos
		set found 0
			}
	}
} else {
	set curpos [.txt.txt index insert]
	set i $cl
	.txt.txt mark set first $i.0
	while  {$i >= 1} {
		
		set fpos [.txt.txt index first]
		set i [expr $i-1]
		
		set curpos [.txt.txt search $swit -exact $seltxt $curpos $fpos]
		if {$curpos != ""} {
			selection clear .txt.txt
			.txt.txt mark set insert $curpos
			.txt.txt see $curpos
			set found 1
			break
			} else {
				.txt.txt mark set first $i.0
				.txt.txt mark set last "first lineend"
				set curpos [.txt.txt index last]
				set found 0
			}
		
	}
}
}

proc FindSelection {swit} {

global seltxt GotSelection
if {$GotSelection == 0} {
	set seltxt [selection get STRING]
	set GotSelection 1
	} 
FindWord $swit $seltxt
}

proc FindValue {} {

FindPopup
}

proc TagSelection {} {
global seltxt GotSelection
if {$GotSelection == 0} {
	set seltxt [selection get STRING]
	set GotSelection 1
	} 
TagAll 
}

proc ReplaceSelection {swit} {
global repltxt seltxt found
set l1 [string length $seltxt]
FindWord $swit $seltxt
if {$found == 1} {
	.txt.txt delete insert "insert + $l1 chars"
	.txt.txt insert insert $repltxt
	}
}

proc ReplaceAll {} {
global seltxt repltxt
set l1 [string length $seltxt]
set l2 [string length $repltxt]
scan [.txt.txt index end] %d nl
set curpos [.txt.txt index 1.0]
for {set i 1} {$i < $nl} {incr i} {
	.txt.txt mark set last $i.end
	set lpos [.txt.txt index last]
	set curpos [.txt.txt search -forwards -exact $seltxt $curpos $lpos]
	
	if {$curpos != ""} {
		.txt.txt mark set insert $curpos
		.txt.txt delete insert "insert + $l1 chars"
		.txt.txt insert insert $repltxt
		.txt.txt mark set insert "insert + $l2 chars"
		set curpos [.txt.txt index insert]
		} else {
			set curpos $lpos
			}
	}
}

proc TagAll {} {
global seltxt 
set l1 [string length $seltxt]
scan [.txt.txt index end] %d nl
set curpos [.txt.txt index insert]
for {set i 1} {$i < $nl} {incr i} {
	.txt.txt mark set last $i.end
	set lpos [.txt.txt index last]
	set curpos [.txt.txt search -forwards -exact $seltxt $curpos $lpos]
		if {$curpos != ""} {
		.txt.txt mark set insert $curpos
		scan [.txt.txt index "insert + $l1 chars"] %f pos
		.txt.txt tag add $seltxt $curpos $pos
		.txt.txt tag configure $seltxt -background yellow -foreground purple
		.txt.txt mark set insert "insert + $l1 chars"
		set curpos $pos
		} else {
			set curpos $lpos
			}
	}
}

#################THEMES
###########################COLORPROCS
##############################################

# set text widget colors
#######################
 proc tback {} {
    global i
    set color [tk_chooseColor -initialcolor [.txt.txt cget -bg]]
    if {$color != ""} {.txt.txt configure -bg $color}
    set ::txbg $color    
 }
 
 proc tfore {} {
    global i
    set color [tk_chooseColor -initialcolor [.txt.txt cget -fg]]
    if {$color != ""} {.txt.txt configure -fg $color}
    set ::txfg $color    
 }

# set window color
################################

proc winback {} {
	global wbg
    set wbg [tk_chooseColor -initialcolor $::wbg]
    if {$wbg != ""} {tk_setPalette background $wbg}
    set $::wbg $wbg

 }

#set window font color
###################################

proc wintex {} {

	global wtx
    set wtx [tk_chooseColor -initialcolor $::wtx]
    if {$wtx != ""} {tk_setPalette background $::wbg foreground $wtx}
    set $::wtx $wtx

 }

## toggle line number display

proc linenums {w} {
    if [llength [$w tag ranges linenum]] {
        foreach {from to} [$w tag ranges linenum] {
            $w delete $from $to
        }
    } else {
        set lastline [expr int([$w index "end - 1 c"])]
        for {set i 1} {$i <= $lastline} {incr i} {
            $w insert $i.0 [format "%5d " $i] linenum
        }
    }
}

global charlist
set charlist [list \
	"¡" "¢" "£" "¤" "¥" \
	"¦" "§" "¨" "©" "ª" \
	"«" "¬" "­" "®" "¯" \
	"°" "±" "²" "³" "´" \
	"µ" "¶" "·" "¸" "¹" \
	"º" "»" "¼" "½" "¾" \
	"¿" "À" "Á" "Â" "Ã" \
	"Ä" "Å" "Æ" "Ç" "È" \
	"É" "Ê" "Ë" "Ì" "Í" \
	"Î" "Ï" "Ð" "Ñ" "Ò" \
	"Ó" "Ô" "Õ" "Ö" "×" \
	"Ø" "Ù" "Ú" "Û" "Ü" \
	"Ý" "Þ" "ß" "à" "á" \
	"â" "ã" "ä" "å" "æ" \
	"ç" "è" "é" "ê" "ë" \
	"ì" "í" "î" "ï" "ñ" \
	"ò" "ó" "ô" "õ" "ö" \
	"÷" "ø"	"ù" "ú" "û" \
	"ü" "ý" "þ" "ÿ"]

# Procedure for finding correct text or entry widget
# and inserting special (or non-special) characters:

proc findwin {char} {
	global foco
	set winclass [winfo class $foco]
	$foco insert insert $char
	if {$winclass == "Text"} {
		$foco edit separator
		}
	after 10 {focus $foco}
}

# Procedure for setting up special-character selection box (borrowed from supernotepad)

proc range {start cutoff finish {step 1}} {
	
	# "Step" has to be an integer, and
	# no infinite loops that go nowhere are allowed:
	if {$step == 0 || [string is integer -strict $step] == 0} {
		error "range: Step must be an integer other than zero"
	}
	
	# Does the range include the last number?
	switch $cutoff {
		"to" {set inclu 1}
		"no" {set inclu 0}
		default {
			error "range: Use \"to\" for an inclusive range,\
			or \"no\" for a noninclusive range"
		}
	}
		
	# Is the range ascending or descending (or neither)?
	set ascendo [expr $finish - $start]
	if {$ascendo > -1} {
		set up 1
	} else {
		set up 0
	}
	
	# If range is descending and step is positive but doesn't have a "+" sign,
	# change step to negative:
	if {$up == 0 && $step > 0 && [string first "+" $start] != 0} {
		set step [expr $step * -1]
	}
	
	set ranger [list] ; # Initialize list variable for generated range
	switch "$up $inclu" {
		"1 1" {set op "<=" ; # Ascending, inclusive range}
		"1 0" {set op "<" ; # Ascending, noninclusive range}
		"0 1" {set op ">=" ; # Descending, inclusive range}
		"0 0" {set op ">" ; # Descending, noninclusive range}
	}
	
	# Generate a list containing the specified range of integers:
	for {set i $start} "\$i $op $finish" {incr i $step} {
		lappend ranger $i
	}
	return $ranger
}

set specialbutts [list]

#  This special box was borrowed from Pa McClemmock's Supernotepad.
proc specialbox {} {
	global charlist foco buttlist
	toplevel .spec
	wm title .spec "Special"
	set bigfons -adobe-helvetica-bold-r-normal--14-*-*-*-*-*-*
	set row 0
	set col 0
	foreach c [range 0 no [llength $charlist]] {
		set chartext [lindex $charlist $c]
		grid [button .spec.but($c) -text $chartext -font $bigfons \
			-pady 1 -padx 2 -borderwidth 1] \
			-row $row -column $col -sticky news
			bind .spec.but($c) <Button-1> {
			set butt %W
			set charx [$butt cget -text]
			findwin $charx
		}
		incr col
		if {$col > 4} {
			set col 0
			incr row
		}
	}
		
	grid [button .spec.amp -text "&"] -row $row -column 4 -sticky news
	bind .spec.amp <Button-1> {findwin "&amp;"}
	
	set bigoe_data "
	#define bigoe_width 17
	#define bigoe_height 13
	static unsigned char bigoe_bits[] = {
		0xf8, 0xfe, 0x01, 0xfe, 0xff, 0x01, 0xcf, 0x07, \
		0x00, 0x87, 0x07, 0x00, 0x07, 0x07, 0x00, 0x07, \
		0x3f, 0x00, 0x07, 0x3f, 0x00, 0x07, 0x07, 0x00, \
		0x07, 0x07, 0x00, 0x07, 0x07, 0x00, 0x8e, 0x07, \
		0x00, 0xfc, 0xff, 0x01, 0xf8, 0xfe, 0x01 };"
	image create bitmap bigoe -data $bigoe_data
	grid [button .spec.oebig -image bigoe \
		-pady 1 -padx 2 -borderwidth 1] \
		-row [expr $row+1] -column 0 -sticky news
	bind .spec.oebig <Button-1> {findwin "&#140;"}
	
	set liloe_data "
	#define liloe_width 13
	#define liloe_height 9
	static unsigned char liloe_bits[] = {
		0xbc, 0x07, 0xfe, 0x0f, 0xc3, 0x18, 0xc3, 0x18, \
		0xc3, 0x1f, 0xc3, 0x00, 0xe7, 0x18, 0xfe, 0x0f, \
		0x3c, 0x07 };"
	image create bitmap liloe -data $liloe_data
	grid [button .spec.oelil -image liloe -pady 1 \
		-pady 1 -padx 2 -borderwidth 1] \
		-row [expr $row+1] -column 1 -sticky news
	bind .spec.oelil <Button-1> {findwin "&#156;"}
	
	grid [button .spec.lt -text "<"] \
		-row [expr $row+1] -column 2 -sticky news
	bind .spec.lt <Button-1> {findwin "&lt;"}
	grid [button .spec.gt -text ">"] \
		-row [expr $row+1] -column 3 -sticky news
	bind .spec.gt <Button-1> {findwin "&gt;"}
	grid [button .spec.quot -text "\""] \
		-row [expr $row+1] -column 4 -sticky news
	bind .spec.quot <Button-1> {findwin "&quot;"}
	grid [button .spec.nbsp -text " "] \
		-row [expr $row+2] -column 0 -columnspan 2 -sticky news
	bind .spec.nbsp <Button-1> {findwin "&nbsp;"}
	grid [button .spec.close -text "Close" \
		-command {destroy .spec}] -row [expr $row+2] \
		-column 2 -columnspan 3 -sticky news
	foreach butt [list .spec.oebig .spec.oelil .spec.nbsp .spec.amp \
		.spec.lt .spec.gt .spec.quot .spec.close] {
		$butt configure -pady 1 -padx 2 -borderwidth 1
			
	}
}

## go to line number 
proc gotoline {} {
	set newlineno [.fpop.l3.line get]
	.txt.txt mark set insert $newlineno.0
	.txt.txt see insert
	focus .txt.txt
	set foco .txt.txt
}

## show word count
proc wordcount {} {
	set wordsnow [.txt.txt get 1.0 {end -1c}]
	set wordlist [split $wordsnow]
	set countnow 0
	foreach item $wordlist {
		if {$item ne ""} {
			incr countnow
		}
	}
	toplevel .count
	wm title .count "Word Count"
	tk::label .count.word -text "Current count:"
	tk::label .count.show -text "$countnow words"
	tk::button .count.ok -text "Okay" -command {destroy .count}
	
	pack .count.word -in .count -side top
	pack .count.show -in .count -side top
	pack .count.ok -in .count -side top
}

## insert time stamp

proc indate {} {
	if {![info exists date]} {set date " "}
	set date [clock format [clock seconds] -format "%R %p %D"]
	.txt.txt insert insert $date
}

## b'bye
##################################

proc leave {} {
	if {[.txt.txt edit modified]} {
	set xanswer [tk_messageBox -message "Would you like to save your work?"\
 -title "B'Bye..." -type yesnocancel -icon question]
	if {$xanswer eq "yes"} {
		{file_save} 
		{exit}
				}
	if {$xanswer eq "no"} {exit}
		} else {exit}
}

## clear text widget / close document
#########################################

proc clear {} {
	if {[.txt.txt edit modified]} {
	set xanswer [tk_messageBox -message "Would you like to save your work?"\
 -title "B'Bye..." -type yesnocancel -icon question]
	if {$xanswer eq "yes"} {
	{file_save} 
	{yclear}
		}
	if {$xanswer eq "no"} {yclear}
	}
}

proc yclear {} {
	.txt.txt delete 1.0 end
	.txt.txt edit reset
	.txt.txt edit modified 0
	set ::filename " "
	wm title . "TclText"
}

# open html in browser
###########################################

proc browz {} {
	global brow
	if {$brow != " "} {
	eval exec $::brow $::filename &
	} else {
	tk_messageBox -message "You have not chosen a browser.\nLet's set the browser now." -type ok -title "Set browser"
	set brow [tk_getOpenFile -filetypes $::file_types]
	{browz}
	}
}

# LaTeX template dialog
####################################

proc textemp {} {

toplevel .laxt

wm title .laxt "TeX Template"

frame .laxt.doc -bd 2

tk::label .laxt.doc.tit -text "Title:"
tk::entry .laxt.doc.ttl -textvariable title
tk::label .laxt.doc.d -text "Document Type:"
ttk::combobox .laxt.doc.t -width 12 -value [list article report book memoir letter proc minimal slides]\
 -state readonly -textvariable doctype

pack .laxt.doc.tit -in .laxt.doc -side left
pack .laxt.doc.ttl -in .laxt.doc -side left
pack .laxt.doc.d -in .laxt.doc -side left
pack .laxt.doc.t -in .laxt.doc -side left
pack .laxt.doc -in .laxt -fill x

frame .laxt.fn -bd 2

tk::label .laxt.fn.f -text "Font size:"
ttk::combobox .laxt.fn.s -width 4 -value [list 10 11 12] -state readonly -textvariable lfont

tk::label .laxt.fn.tp -text "Title page:"
ttk::combobox .laxt.fn.tpg -width 12 -value [list titlepage notitlepage] -textvariable tpage

pack .laxt.fn.f -in .laxt.fn -side left
pack .laxt.fn.s -in .laxt.fn -side left
pack .laxt.fn.tp -in .laxt.fn -side left
pack .laxt.fn.tpg -in .laxt.fn -side left
pack .laxt.fn -in .laxt -fill x

frame .laxt.ppr -bd 2

tk::label .laxt.ppr.au -text "Author: "
tk::entry .laxt.ppr.atr -textvariable author
tk::label .laxt.ppr.l -text "Paper:"
ttk::combobox .laxt.ppr.s -width 12 -value [list a4paper a5paper letterpaper executivepaper legalpaper]\
 -state readonly -textvariable paper

pack .laxt.ppr.au -in .laxt.ppr -side left
pack .laxt.ppr.atr -in .laxt.ppr -side left
pack .laxt.ppr.l -in .laxt.ppr -side left
pack .laxt.ppr.s -in .laxt.ppr -side left
pack .laxt.ppr -in .laxt -fill x

frame .laxt.col -bd 2

tk::label .laxt.col.l -text "Columns:"
ttk::combobox .laxt.col.no -value [list onecolumn twocolumn] -state readonly -textvariable columns

tk::button .laxt.col.apply -text "APPLY" -command {maketex}
tk::button .laxt.col.close -text "DONE" -command {destroy .laxt}

pack .laxt.col.l -in .laxt.col -side left
pack .laxt.col.no -in .laxt.col -side left
pack .laxt.col.close -in .laxt.col -side right
pack .laxt.col.apply -in .laxt.col -side right
pack .laxt.col -in .laxt -fill x

frame .laxt.t

}

# LaTeX insertion (whoooo)
###################

proc maketex { } {

set date [clock format [clock seconds] -format "%R %p %D"]

.txt.txt insert end "\\documentclass\[$::lfont, $::paper, $::columns, $::tpage\]\{$::doctype\} \n\\title\{$::title\} \n\\author\{$::author\} \n\\date\{$date\} \n\\usepackage\{hyperref\} \n\\usepackage\{graphicx\} \n \n\\begin\{document\} \n\\maketitle \n\\tableofcontents \n \n \\section\[section1title\]\{section1heading\} \nsection one here \n \\subsection \n \n \\section\[section2title\]\{section2heading\} \nsection two here \n \n\\end\{document\} \n \n NOTES: format ULRs like this: \n \\url\{http://www.baldwinsoftware.com\} \n format images like this:\n \\includegraphics\[scale=0.5\]\{/pathto/image.jpg\} \n LISTS:\n \\begin\{enumerate\} \n \\item \n \\end\{enumerate\}"

destroy .laxt

}

## found this on wiki.tcl.tck  - preserves indentation
#######################################################

 proc indent {w {extra "    "}} {
	set lineno [expr {int([$w index insert])}]
	set line [$w get $lineno.0 $lineno.end]
	regexp {^(\s*)} $line -> prefix
	if {[string index $line end] eq "\{"} {
		tk::TextInsert $w "\n$prefix$extra"
	} elseif {[string index $line end] eq "\}"} {
		if {[regexp {^\s+\}} $line]} {
			$w delete insert-[expr [string length $extra]+1]c insert-1c
			tk::TextInsert $w "\n[string range $prefix 0 end-[string length $extra]]"
		} else {
			tk::TextInsert $w "\n$prefix"
		}
	} else {
		tk::TextInsert $w "\n$prefix"
	}
 }

proc tindent {w {extra "    "}} {
	set lineno [expr {int([$w index insert])}]
	set line [$w get $lineno.0 $lineno.end]
	regexp {^(\s*)} $line -> prefix
	tk::TextInsert $w "\n$prefix"
	if {[string index $line end] eq "\{"} {
		tk::TextInsert $w "$extra"
	}
 }

##  Tcl script template #######################
## just inserts interpreter and GPL information.
##################################################

proc tcltemp {} {
    
toplevel .tclt
wm title .tclt "Tcl Template"

tk::label .tclt.tit -text "Title:"
tk::entry .tclt.tit2 -textvariable title
tk::label .tclt.aut -text "Author:"
tk::entry .tclt.anm -textvariable author
tk::label .tclt.acon -text "Contact:"
tk::entry .tclt.atco -textvariable emal
tk::button .tclt.btn -text "GO" -command {intcl}
tk::button .tclt.b2 -text "Cancel" -command {destroy .tclt}

pack .tclt.tit -in .tclt -side left
pack .tclt.tit2 -in .tclt -side left
pack .tclt.aut -in .tclt -side left
pack .tclt.anm -in .tclt -side left
pack .tclt.acon -in .tclt -side left
pack .tclt.atco -in .tclt -side left
pack .tclt.btn -in .tclt -side left
pack .tclt.b2 -in .tclt -side left
}

# tcl insertion
#########################

proc intcl {} {

.txt.txt insert end "#!/bin/sh \n \n\# $::title copyright $::author - $::emal\n# just tricking tcl here\\ \nexec wish8.5 -f \"\$0\" \$\{1+\" \$@\"\} \n \n content here \n \n# This program was written by $::author - $::emal \n# This program is free software; you can redistribute it and/or modify \n# it under the terms of the GNU General Public License as published by \n# the Free Software Foundation; either version 2 of the License, or \n# (at your option) any later version.\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU General Public License for more details.\n# You should have received a copy of the GNU General Public License\n# along with this program; if not, write to the Free Software\n# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA."

destroy .tclt
}

## html template tool
############################################

proc webtemp {} {
    toplevel .web
    wm title .web "Web Page Template"
    
    global wbgcor
    global wfgcor
    set wbgcor white
    set wfgcor black
    
    frame .web.info -bd 2
    
    tk::label .web.info.name -text "Author:"
    tk::entry .web.info.auth -textvariable "author"
    tk::label .web.info.tit -text "Title" 
    tk::entry .web.info.titl -textvariable "title"
    tk::label .web.info.lang -text "Language:"
    tk::entry .web.info.lingua -textvariable "lang" -width 4
    
    pack .web.info.name -in .web.info -side left
    pack .web.info.auth -in .web.info -side left
    pack .web.info.tit -in .web.info -side left
    pack .web.info.titl -in .web.info -side left
    pack .web.info.lang -in .web.info -side left
    pack .web.info.lingua -in .web.info -side left
    
    frame .web.desc -bd 2
    
    tk::label .web.desc.des -text "Description:"
    tk::entry .web.desc.des2 -textvariable "descript" -width 50
    
    pack .web.desc.des -in .web.desc -side left
    pack .web.desc.des2 -in .web.desc -side left
    
    frame .web.keys -bd 2
    
    tk::label .web.keys.wrd -text "Keywords:"
    tk::entry .web.keys.wrds -textvariable "keywords" -width 50
    
    pack .web.keys.wrd -in .web.keys -side left
    pack .web.keys.wrds -in .web.keys -side left
    
    frame .web.colors -bd 2

    tk::button .web.colors.bgcolor -text "Background color:" -command {weback}
    tk::label .web.colors.bgcor -text "----------"
    
    tk::button .web.colors.fgcolor -text "Font color:" -command {webfront}
    tk::label .web.colors.fgcor -text "---------"
    
    tk::button .web.colors.lcolor -text "Link color:" -command {lncolor}
    tk::label .web.colors.lncor -text "---------"
    
    pack .web.colors.bgcolor -in .web.colors -side left
    pack .web.colors.bgcor -in .web.colors -side left
    
    pack .web.colors.fgcolor -in .web.colors -side left
    pack .web.colors.fgcor -in .web.colors -side left
    
    pack .web.colors.lcolor -in .web.colors -side left
    pack .web.colors.lncor -in .web.colors -side left
    
    frame .web.buttons
    
    tk::button .web.buttons.go -text "GO" -command {inweb}
    tk::button .web.buttons.stop -text "CANCEL" -command {destroy .web}
    
    pack .web.buttons.stop -in .web.buttons -side right
    pack .web.buttons.go -in .web.buttons -side right
    
    pack .web.info -in .web -fill x
    pack .web.desc -in .web -fill x
    pack .web.keys -in .web -fill x
    pack .web.colors -in .web -fill x
    pack .web.buttons -in .web -fill x
    
}

proc weback {} {

    set ::wbgcor [tk_chooseColor -initialcolor white]
    .web.colors.bgcor configure -bg $::wbgcor
}

proc webfront {} {
    set ::wfgcor [tk_chooseColor -initialcolor black]
    .web.colors.fgcor configure -bg $::wfgcor}

proc lncolor {} {
    set ::lcolor [tk_chooseColor -initialcolor black]
    .web.colors.lncor configure -bg $::lcolor
 }
    
### inserting html code      
############################

proc inweb {} {
    
    set date [clock format [clock seconds] -format "%D"]
   
    .txt.txt insert end "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n\n<html>
<head>
<title>$::title</title>
<meta name=\"description\" content=\"$::descript\">\n<meta name=\"keywords\" content=\"$::keywords\">
<meta name=\"Generator\" content=\"TickleText - by Anthony Baldwin\">
<meta name=\"author\" content=\"$::author\">
</head>

<body bgcolor=\"$::wbgcor\" text=\"$::wfgcor\" link=\"$::lcolor\">
<h2>$::title</h2>
<p>this is a paragraph</p>
<hr>
This page copyright $date by $::author <br>created with: <a href=\"http://tonyb.us/tcltext\">TclText</a>
</body>"
    
destroy .web

}

############################
#  Perl template
#  pretty simple

##  Perll script template #######################
## just inserts interpreter and GPL information.
##################################################

proc pltemp {} {
    
toplevel .perlt

wm title .perlt "Perl Template"

tk::label .perlt.tit -text "Title:"
tk::entry .perlt.tit2 -textvariable title
tk::label .perlt.aut -text "Author:"
tk::entry .perlt.anm -textvariable author
tk::label .perlt.acon -text "Contact:"
tk::entry .perlt.atco -textvariable emal
tk::button .perlt.btn -text "GO" -command {inperl}
tk::button .perlt.b2 -text "Cancel" -command {destroy .perlt}

pack .perlt.tit -in .perlt -side left
pack .perlt.tit2 -in .perlt -side left
pack .perlt.aut -in .perlt -side left
pack .perlt.anm -in .perlt -side left
pack .perlt.acon -in .perlt -side left
pack .perlt.atco -in .perlt -side left
pack .perlt.btn -in .perlt -side left
pack .perlt.b2 -in .perlt -side left
}

# tcl insertion
#########################

proc inperl {} {

.txt.txt insert end "#!/usr/bin/perl \n \n\# $::title copyright $::author - $::emal \nuse strict;\nuse warnings;\n\n content here \n \n# This program was written by $::author - $::emal \n# This program is free software; you can redistribute it and/or modify \n# it under the terms of the GNU General Public License as published by \n# the Free Software Foundation; either version 2 of the License, or \n# (at your option) any later version.\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU General Public License for more details.\n# You should have received a copy of the GNU General Public License\n# along with this program; if not, write to the Free Software\n# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA."

destroy .perlt
}

##  Python script template #######################
## just inserts interpreter and GPL information.
##################################################

proc pytemp {} {
    
toplevel .pyt

wm title .pyt "Flying Circus"

tk::label .pyt.tit -text "Title:"
tk::entry .pyt.tit2 -textvariable title
tk::label .pyt.aut -text "Author:"
tk::entry .pyt.anm -textvariable author
tk::label .pyt.acon -text "Contact:"
tk::entry .pyt.atco -textvariable emal
tk::button .pyt.btn -text "GO" -command {inpy}
tk::button .pyt.b2 -text "Cancel" -command {destroy .pyt}

pack .pyt.tit -in .pyt -side left
pack .pyt.tit2 -in .pyt -side left
pack .pyt.aut -in .pyt -side left
pack .pyt.anm -in .pyt -side left
pack .pyt.acon -in .pyt -side left
pack .pyt.atco -in .pyt -side left
pack .pyt.btn -in .pyt -side left
pack .pyt.b2 -in .pyt -side left
}

# tcl insertion
#########################

proc inpy {} {

.txt.txt insert end "#!/usr/bin/python \n \n\# $::title copyright $::author - $::emal \n \n content here \n \n# This program was written by $::author - $::emal \n# This program is free software; you can redistribute it and/or modify \n# it under the terms of the GNU General Public License as published by \n# the Free Software Foundation; either version 2 of the License, or \n# (at your option) any later version.\n# This program is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU General Public License for more details.\n# You should have received a copy of the GNU General Public License\n# along with this program; if not, write to the Free Software\n# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA."

destroy .pyt
}

####################3
#  to comment or uncomment lines:
# not ready yet...
# need to work on reading the selection
# 
proc Comment {} {

	# globalize
	
	global commentSymbolArray
	
	# initalize comment symbol
	
	set comment "#"

	# check to see if selection exits
	
	set text [selection get STRING]
	set return [.txt.txt tag nextrange sel 1.0 end]
	if {[string compare $return {}] == 0} then {
		tk_messageBox -type ok -icon info -message {No selection}
		return
	}
	
	# initalize first and last index and line
	
	set firstIndex [.txt.txt index sel.first]
	set lastIndex [.txt.txt index sel.last]
	regexp {^[0-9]+} $firstIndex firstLine
	regexp {^[0-9]+} $lastIndex lastLine

	# loop through lines and insert numbers rembering the undo stack

	for {set count $firstLine} {$count <= $lastLine} {incr count} {
	
		# insert number
		
		set insertIndex "$count.0"
		.txt.txt insert $insertIndex $comment
		set insertLength [string length $comment]
				
	}
	
}

proc Uncomment {} {

	# globalize
	
	global commentSymbolArray
	
	# initalize comment symbol
	
	set comment "#"

	# check to see if selection exits
	
	set text [selection get STRING]
	set return [.txt.txt tag nextrange sel 1.0 end]
	if {[string compare $return {}] == 0} then {
		tk_messageBox -type ok -icon info -message {No selection}
		return
	}
	
	# initalize first and last index and line
	
	set firstIndex [.txt.txt index sel.first]
	set lastIndex [.txt.txt index sel.last]
	regexp {^[0-9]+} $firstIndex firstLine
	regexp {^[0-9]+} $lastIndex lastLine

	# loop through lines and remove numbers rembering the undo stack

	for {set count $firstLine} {$count <= $lastLine} {incr count} {
	
		# search for number
		
		set lineStart $count.0
		set lineStop [.txt.txt index "$count.0 lineend"]
		set deleteIndex [.txt.txt search -count deleteLength -- $comment $lineStart $lineStop]
		
		# check somthing found
		
		if {[string compare $deleteIndex {}] == 0} then {
			continue
		}
		
		# take care of undo
		
		set commentStart $deleteIndex
		set commentStop [.txt.txt index "$deleteIndex + $deleteLength chars"]
		set comment [.txt.txt get $commentStart $commentStop]
#		AppendUndo .txt.txt insert $commentStart $comment
		
		# delete the characters
		
		.txt.txt delete $commentStart $commentStop
	}

}

proc sapro {} {
    
    set xanswer [tk_messageBox -message "This will save your color theme, browser preference, terminal preference, and ftp server settings, INCLUDING YOUR PASSWORD, unless you clear the field first.\n  Choose yes to change the password to 0000 and save, or no to save as is."\
 -title "Save Profile" -type yesno -icon question]
 	if {$xanswer eq "yes"} {
	set novar "cows"
	set password "0000"
	set header "#!/usr/bin/env wish8.5 "
   		set file_types {
     		{".config" {.conf}}
    		}
   set ~/.tcltext/tcltext.conf
   set fileid [open $filename w]
   puts $fileid $header
   foreach var $::allvars {puts $fileid [list set $var [set ::$var]]}
   close $fileid
   
  } else {
 	if {$xanswer eq "no"} {
	set novar "cows"
	set header "#!/usr/bin/env wish8.5 "
   		set file_types {
     		{"config" {.conf}}
    		}
   set filename [tk_getSaveFile -filetypes $file_types -initialdir ~/.tcltext]
   set fileid [open $filename w]
   puts $fileid $header
   foreach var $::allvars {puts $fileid [list set $var [set ::$var]]}
   close $fileid
   	}
	}   
} 

##############################333
#  Dialog to set FTP settings to upload/download files from a server.

proc setFTP {} {

toplevel .ftps

wm title .ftps  "FTP server settings."

frame .ftps.notes

tk::label .ftps.notes.lab -text "PROFILE:"

pack .ftps.notes -in .ftps -fill x

frame .ftps.fields

tk::label .ftps.fields.hq -text "Host:"
tk::entry .ftps.fields.host -textvariable host
tk::label .ftps.fields.pathq -text "Directory: "
tk::entry .ftps.fields.path -textvariable path
 
pack .ftps.fields.hq -in .ftps.fields -side left
pack .ftps.fields.host -in .ftps.fields -side left
pack .ftps.fields.pathq -in .ftps.fields -side left
pack .ftps.fields.path -in .ftps.fields -side left

pack .ftps.fields -in .ftps -fill x

frame .ftps.fields2

tk::label .ftps.fields2.unam -text "Username: "
tk::entry .ftps.fields2.uname -textvariable username
tk::label .ftps.fields2.pwrd -text "Password: "
tk::entry .ftps.fields2.pswrd -show * -textvariable password

pack .ftps.fields2.unam -in .ftps.fields2 -side left
pack .ftps.fields2.uname -in .ftps.fields2 -side left
pack .ftps.fields2.pwrd -in .ftps.fields2 -side left
pack .ftps.fields2.pswrd -in .ftps.fields2 -side left

pack .ftps.fields2 -in .ftps -fill x

frame .ftps.ubtns

tk::label .ftps.ubtns.lbl -text "UPLOADS:"
tk::button .ftps.ubtns.send -text "Upload" -command {upload}
tk::button .ftps.ubtns.browz -text "Browser" -command {setbro}
tk::entry .ftps.ubtns.bpx -textvariable brow

pack .ftps.ubtns.lbl -in .ftps.ubtns -side left
pack .ftps.ubtns.send -in .ftps.ubtns -side left
pack .ftps.ubtns.browz -in .ftps.ubtns -side left
pack .ftps.ubtns.bpx -in .ftps.ubtns -side left

pack .ftps.ubtns -in .ftps -fill x

frame .ftps.dbtns

tk::label .ftps.dbtns.lbl -text "DOWNLOADS:"
tk::button .ftps.dbtns.dlfilen -text "List" -command {dlist}
tk::entry .ftps.dbtns.file -textvariable rfile
tk::button .ftps.dbtns.ddn -text "Download" -command {down}
tk::button .ftps.dbtns.del -text "Delete" -command {deletefile}

pack .ftps.dbtns.lbl -in .ftps.dbtns -side left
pack .ftps.dbtns.dlfilen -in .ftps.dbtns -side left
pack .ftps.dbtns.file -in .ftps.dbtns -side left
pack .ftps.dbtns.ddn -in .ftps.dbtns -side left
pack .ftps.dbtns.del -in .ftps.dbtns -side left

pack .ftps.dbtns -in .ftps -fill x

frame .ftps.btns

grid [ttk::progressbar .ftps.btns.prog -mode indeterminate -length 333]\
[tk::button .ftps.btns.out -text "close" -command {destroy .ftps}]\
[tk::button .ftps.btns.help -text "Help" -command {fhelp}]

pack .ftps.btns -in .ftps -fill x

}


#######################3
# upload file to web server

proc upload {} {

	if {$::host eq " "} {
	
	tk_messagBox -type ok -message "You must configure your FTP settings first!"
	
	} elseif {$::filename eq " "} {
	
	tk_messagBox -type ok -message "You must open a file first!\n(or save if you are working on a new file\nto give the file a name.)"
	
	} else {
	
	.ftps.btns.prog start
	global fname
	set fname [file tail $::filename]
   
	set handle [::ftp::Open $::host $::username $::password]
   
	::ftp::Cd $handle $::path
  
	::ftp::Put $handle $::filename $::fname

	 ::ftp::Close $handle
	 .ftps.btns.prog stop
 

	toplevel .url
 

	text .url.lbl -height 2 -width 80 
	.url.lbl insert end "Your image is at http://www.$::host/$::path/$::fname"
	tk::button .url.btn -text "open in browser" -command {browse}
	tk::button .url.out -text "close" -command {destroy .url}

	pack .url.lbl -in .url -side top
	pack .url.btn -in .url -side bottom
	pack .url.out -in .url -side bottom

	}
	
}

#######
# grab a file to upload

proc grabfile {} {
	global filename
	set filename [tk_getOpenFile -filetypes $::file_types -initialdir ~]
	wm title . "Now Tickling: [file tail $::filename"]	
}

############################
# download file from server

proc down {} {
	.ftps.btns.prog start
    global dldir
    set dldir [tk_chooseDirectory]
    set handle [::ftp::Open $::host $::username $::password]
    ::ftp::Cd $handle $::path
    ::ftp::Get $handle $::rfile $::dldir/$::rfile
    ::ftp::Close $handle
    .ftps.btns.prog stop
    
    toplevel .down
    wm title .down "Success!"
    tk::message .down.loaded -text "Your file has been downloaded to $::dldir/$::rfile"
    tk::button .down.out -text "Okay" -command {destroy .down}
    pack .down.loaded -in .down -side top
    pack .down.out -in .down -side top
    
	set ::filename $::dldir/$::rfile
    
	wm title . "Now Tickling: $::filename"
	set data [open $::filename RDWR]
	.txt.txt delete 1.0 end
	while {![eof $data]} {
		.txt.txt insert end [read $data 1000]
		}
	close $data
	.txt.txt mark set insert 1.0
	    
}

proc setbro {} {
set filetypes " "
set ::brow [tk_getOpenFile -filetypes $filetypes -initialdir "/usr/bin"]
}

proc browse {} {
    if {$::brow eq " "} {
	set filetypes " "
	tk_messageBox -message "You have not chosen a browser.\
Open preferences and set the browser" -type ok -title "No browser?!"
	} else {
	    exec $::brow www.$::host/$::path/$::fname &
	    }
}

##################
# list files on the remote server

proc dlist {} {
    set handle [::ftp::Open $::host $::username $::password]
    set list [::ftp::NList $handle $::path]
    
toplevel .list
wm title .list "Remote File List"
text .list.l -width 30 -height 40 -wrap word
.list.l insert end "\n \n Copy the file name you wish to download and paste to the entry field.\n Then click \'download\' and choose the directory where to save it."

foreach i $list {.list.l insert end $i\n}
    
pack .list.l -in .list -fill x
    		
}

##########################333
# delete file from remote server

proc deletefile {} {
    set handle [::ftp::Open $::host $::username $::password]
    ::ftp::Cd $handle $::path
    ::ftp::Delete $handle $::rfile 
    ::ftp::Close $handle
    
    toplevel .mdel
    tk::message .mdel.done -text "File deleted from remote server"
    tk::button .mdel.ok -text "okay" -command {destroy .mdel}
    pack .mdel.done -in .mdel -side top
    pack .mdel.ok -in .mdel -side top
    
}

proc fhelp {} {
toplevel .fhelp
wm title .fhelp "FTP help"
text .fhelp.inf -width 70 -height 25
.fhelp.inf insert end "Profile: This is the information for your remote host.\nhost:  enter the url for your ftp server \n   (ie: the ip address, or, domain, such as myserver.com)\ndirectory: the path to the directory to/from which you wish to\n upload/download files\nusername:  your username for your ftp account\npassword:  the password for your ftp account\n\nButtons:\n\n-Uploads:\nLocal file:  opens a file selection dialog to choose a file on your\n local file system.\nupload: \ninitiates upload to the server\nBrowser:  choose a browser to preview files once they've been uploaded\n\n-Downloads:\nList: will show a list of files on the remote host\n(empty field):  enter the name of the file on the remote host\n  (you can copy/paste from the list using ctrl-c and ctrl-v)\nDownload: initiates download\nDelete: will delete the file from the remote host\n"
tk::button .fhelp.out -text "Okay" -command {destroy .fhelp}
pack .fhelp.out -in .fhelp -side top
pack .fhelp.inf -in .fhelp -side top
}

proc help {} {
toplevel .help
wm title .help "TclText help"
text .help.inf -width 80 -height 15
.help.inf insert end "TclText is FREE Software, released under the terms of the Gnu Public License\n\nMost of what this program does should be pretty self-explanatory.\nThe script templates will make your software GPL.\nIf you don't want to release your code to the FREE software community,\nuninstall TclText and go find some crappy proprietary text editor. Seriously.\n\nThe FTP tool has a distinct help window.\nIf you have questions about tcl, perl, python, LaTeX, html, or other code\ngoogle is your friend...\nIf you have questions about how TclText works, feel free to e-mail me at\ntony@tonybaldwin.org\n\ntony\nhttp://tonybaldwin.me"
tk::button .help.out -text "Okay" -command {destroy .help}
pack .help.out -in .help -side top
pack .help.inf -in .help -side top
}

######################
#  global preferences
proc prefs {} {

toplevel .pref

wm title .pref "TclText preferences"

grid [tk::label .pref.lbl -text "Set global prefernces here"]

grid [tk::button .pref.fc -text "Font Color" -command {tfore}]\
[tk::button .pref.bc -text "Text Background" -command {tback}]\
[tk::button .pref.wc -text "Window Color" -command {winback}]\
[tk::button .pref.wt -text "Window Text" -command {wintex}]

grid [tk::label .pref.aut -text "Your name:"]\
[tk::entry .pref.anm -textvariable author]\
[tk::label .pref.acon -text "Contact:"]\
[tk::entry .pref.atco -textvariable emal]

grid [tk::button .pref.bro -text "Set Browser" -command {setbro}]\
[tk::entry .pref.br0z -textvariable brow]

grid [tk::label .pref.f -text "FTP settings:"]

grid [tk::label .pref.hq -text "Host:"]\
[tk::entry .pref.host -textvariable host]\
[tk::label .pref.pathq -text "Directory: "]\
[tk::entry .pref.path -textvariable path]

grid [tk::label .pref.unam -text "Username: "]\
[tk::entry .pref.uname -textvariable username]\
[tk::label .pref.pwrd -text "Password: "]\
[tk::entry .pref.pswrd -show * -textvariable password]

grid [tk::button .pref.sv -text "Save Preferences" -command sapro]\
[tk::button .pref.ok -text "OK" -command {destroy .pref}]

}

# This program was written by Anthony Baldwin / tony@baldwinsoftware.com# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
