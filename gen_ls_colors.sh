#!/usr/bin/bash

# special type codes
# no: Normal: non-filename text, global default (unset by default)
# fi: File: normal file that doesn't have a color associated with it
# di: Directory
# ex: Executable
# ln: Symbolic link: can set to 'target' to make the color match the pointed to file
# mh: multihardlink: files with more than one link
# mi: Missing file: non-existent file pointed to by symlink (the file the link points to when using -l)
# or: orphaned: symlink pointing to an orphaned non-existent file
# bd: Block device: buffered special file (stuff in /dev)
# cd: Character device: unbuffered special file (stuff in /dev)
# pi: Named pipe (fifo file)
# so: Socket file
# do: Door: special file for inter-process communication between a client and server (currently implemented only in Solaris)
# su: setuid: file that is (u+s)
# sg: setgid: file that is (g+s)
# st: sticky: directory with sticky bit set (+t) and not other-writable
# ow: other-writeable: Directory that is other-writable (o+w) and not sticky
# tw: directory that is sticky w/ other-writable (+t,o+w)
# ca: capability: file with capability

# escape sequence (defaults seem to work fine)
# these might only apply if using dircolors
# lc: left code: opening terminal code (default '\e[' - escape)
# rc: right code: closing terminal code (default 'm' - end escape)
# ec: end code: none-filename text (replaces lc+no+rc) (default undefined)
# rs: Reset to ordinary colors (default '0')
# cl: clear to end of line (not sure how this works)
# default ls escape sequence looks something like this:
#     ${lc}${type_code}${rc}FILENAME${lc}${no}${rc}
#     if ec is defined: ${lc}${type_code}${rc}FILENAME${ec}
# typecode is the color sequence that depends on the type or name of file

# text attributes (applies to fg text)
NON="00" # default/normal
BLD="01" # bold
UDS="04" # underline
BLI="05" # blinking (requires terminal setting to be on)
REV="07" # reversed (reverse FG and BG colors)
CON="08" # concealed (hide text)

# foreground or background
FG="033;38;2"
BG="033;48;2"

# falcon terminal colors
BLK="0;0;2"             # rgb(0,0,2)        =   #000002
RED="255;64;0"          # rgb(255,64,0)     =   #ff4000
GRN="89;128;51"         # rgb(89,128,51)    =   #598033
YLW="255;191;0"         # rgb(255,191,0)    =   #ffbf00
BLU="48;108;191"        # rgb(48,108,191)   =   #306cbf
ORG="255;128;0"         # rgb(255,128,0)    =   #ff8000
CYN="48;191;167"        # rgb(48,191,167)   =   #30bfa7
GRY="212;212;217"       # rgb(212,212,217)  =   #d4d5d9
BBLK="11;11;26"         # rgb(11,11,26)     =   #0b0b1a
BRED="255;121;76"       # rgb(255,121,76)   =   #ff794c
BGRN="133;166;99"       # rgb(133,166,99)   =   #85a663
BYLW="255;217;102"      # rgb(255,217,102)  =   #ffd966
BBLU="143;163;191"      # rgb(143,163,191)  =   #8fa3bf
BORG="255;172;89"       # rgb(255,172,89)   =   #ffac59
BCYN="133;204;192"      # rgb(133,204,192)  =   #85ccc0
BWHT="253;253;255"      # rgb(253,253,255)  =   #fdfdff

# falcon standard colors (ones that are the same as terminal not repeated)
SGRN="119;153;84"       # rgb(119,153,84)   =   #779954
TAN="255;239;191"       # rgb(255,239,191)  =   #ffefbf
LGRN="223;255;191"      # rgb(223,255,191)  =   #dfffbf
LBLU="191;218;255"      # rgb(191,218,255)  =   #bfdaff
LGRY="175;175;178"      # rgb(175,175,178)  =   #afafb2
LLGRY="137;137;140"     # rgb(137,137,140)  =   #89898c
MGRY="100;100;102"      # rgb(100,100,102)  =   #646466
DGRY="62;62;64"         # rgb(62,62,64)     =   #3e3e40
DDGRY="37;37;39"        # rgb(37,37,39)     =   #252527

# falcon special colors
PRPL="255;95;255"       # rgb(255,95,255)   =   #ff5fff
BRWN="102;56;41"        # rgb(102,56,41)    =   #663829
LBRW="102;87;41"        # rgb(102,87,41)    =   #665729
DGRN="71;102;41"        # rgb(71,102,41)    =   #476629
SGRY="128;128;128"      # rgb(128,128,128)  =   #808080
SBLK="11;11;26"         # rgb(11,11,26)     =   #0b0b1a


# LS COLOR DEFINITIONS:
# each line should contain the following string separated by spaces:
#     "<extension or special type> <text attribute> <fg color> <bg color> <icon>"
#     set <bg color> to CLC for no background color
#     must use the above defined color and attribute strings (create new vars if needed)
# order matters e.g. if you want *README.md one color and other *.md files a different color
# then *README.md should be put AFTER *.md since it will be appplied over the top of *.md
# see https://nerdfonts.com/#cheat-sheet for icon lookup
# to type a unicode character in vim type ctrl-v+u<number> e.g. ctrl-v ue612
COLORS=(
    # special
    "fi NON BWHT CLC "             # file,             icon e612
    "di NON GRN CLC "              # directory,        icon e5fe
    "ex NON RED CLC "              # executable,       icon f135
    "ln NON BCYN CLC "             # symlink,          icon f178
    "mh BLD BCYN CLC "             # multi-hardlink,   icon f44c
    "mi NON BLK RED "              # missing link,     icon f837
    "or NON BLK BCYN "             # orphaned link,    icon f839
    "bd NON LGRN CLC "             # block device,     icon f0c8
    "cd NON LGRN CLC "             # character device, icon f096
    "pi NON LBRW CLC ﳣ"             # pipe,             icon fce3
    # "pi NON LBRW CLC "             # pipe,             icon f1a8
    "so NON LBRW CLC ﳦ"             # socket,           icon fce6
    "su NON BLK LBLU "             # setuid,           icon f007
    "sg NON BLK LBLU "             # setgid,           icon f0c0
    "st NON GRN CLC "              # sticky,           icon f249
    "ow NON GRN CLC "              # other-writable,   icon f044
    "tw NON GRN CLC "              # ow w/ sticky,     icon f14b

    # other special (haven't seen yet and couldn't figure out how to create)
    "do BLD PRPL BWHT ﴘ"            # door,             icon fd18
    "ca BLD PRPL BWHT "            # capability,       icon e7ad

    # extensions
    "*.pem NON CYN CLC "           # icon f084
    "*.txt NON BWHT CLC "          # icon f0f6
    "*.log NON LLGRY CLC "         # icon f02d

    # markdown
    "*.md NON YLW CLC "            # icon e609
    "*.mkdn NON YLW CLC "          # icon e609
    "*.markdown NON YLW CLC "      # icon e609

    # binary files
    "*.bin NON LGRY CLC "          # icon f471

    # source code
    "*.c NON GRY CLC "             # icon e61e
    "*.h NON GRY CLC "             # icon e61e
    "*.cpp NON GRY CLC ﭱ"           # icon fb71
    "*.hpp NON GRY CLC ﭱ"           # icon fb71
    "*.asm NON GRY CLC "           # icon e753
    "*.py NON GRY CLC "            # icon f820
    "*.pyc NON LGRY CLC "          # icon f81f
    "*.stackdump NON LGRY CLC "    # icon f6e4
    "*.json NON GRY CLC ﬥ"          # icon fb25

    # html
    "*.htm NON TAN CLC "           # icon e60e
    "*.html NON TAN CLC "          # icon e60e
    "*.css NON TAN CLC "           # icon e7b6
    "*.xml NON TAN CLC "           # icon f72d
    "*.xsd NON TAN CLC "           # icon f72d
    "*.js NON TAN CLC "            # icon e74e

    # vim
    "*viminfo NON SGRN CLC "       # icon e7c5
    "*.vim NON GRN CLC "           # icon e7c5

    # git
    "*.git NON GRN CLC "           # icon f7a1
    "*.gitignore NON ORG CLC "     # icon f7a1

    # documents
    "*.pdf NON BRED CLC "          # icon f1c1
    "*.doc NON BLU CLC "           # icon f1c2
    "*.docx NON BLU CLC "          # icon f1c2
    "*.ppt NON BORG CLC "          # icon f1c4
    "*.pptx NON BORG CLC "         # icon f1c4
    "*.xls NON BGRN CLC "          # icon f1c3
    "*.xlsx NON BGRN CLC "         # icon f1c3
    "*.vsdx NON BBLU CLC "         # icon f1c3
    "*.msg NON BBLU CLC "          # icon f6ee
    "*.accdb NON BRED CLC "        # icon f472
    "*.laccdb NON SGRY CLC "       # icon f023
    "*.mfd NON YLW CLC "           # icon f279
    "*.tmp NON SGRY CLC "          # icon f1b1

    # images
    "*.jpg NON PRPL CLC "          # icon f1c5
    "*.jpeg NON PRPL CLC "         # icon f1c5
    "*.JPG NON PRPL CLC "          # icon f1c5
    "*.png NON PRPL CLC "          # icon f1c5
    "*.PNG NON PRPL CLC "          # icon f1c5
    "*.bmp NON PRPL CLC "          # icon f1c5
    "*.BMP NON PRPL CLC "          # icon f1c5
    "*.gif NON PRPL CLC "          # icon f1c5
    "*.svg NON PRPL CLC "          # icon f1c5
    "*.ai NON PRPL CLC "           # icon f1c5
    "*.ico NON PRPL CLC "          # icon f1c5
    "*.tif NON PRPL CLC "          # icon f1c5
    "*.tiff NON PRPL CLC "         # icon f1c5
    "*.ps NON PRPL CLC "           # icon f1c5
    "*.psd NON PRPL CLC "          # icon f1c5

    # shell
    "*.sh NON RED CLC "            # icon f120
    "*.bat NON RED CLC "           # icon f120
    "*.cmd NON RED CLC "           # icon f120

    # Windows
    "*.lnk NON BCYN CLC "          # icon f482

    # compressed files
    "*.tar NON MGRY CLC "          # icon f0f6
    "*.xz NON MGRY CLC "           # icon f0f6
    "*.zip NON MGRY CLC "          # icon f0f6
    "*.7z NON MGRY CLC "           # icon f0f6
    "*.gz NON MGRY CLC "           # icon f0f6

    # config files
    "*vimrc NON BYLW CLC "         # icon e615
    "*bashrc NON BYLW CLC "        # icon e615
    "*bash_profile NON BYLW CLC "  # icon e615
    "*gitconfig NON BYLW CLC "     # icon e615
    "*minttyrc NON BYLW CLC "      # icon e615
    "*inputrc NON BYLW CLC "       # icon e615
    "*taskrc NON BYLW CLC "        # icon e615
    "*.conf NON BYLW CLC "         # icon e615

    # file/folder name specific (requires special build of ls for folders)
    "*README.md BLD YLW CLC "      # icon e714
    "*README.mkdn BLD YLW CLC "    # icon e714
    "*README-cn.md BLD YLW CLC "   # icon e714
    "*README BLD YLW CLC "         # icon e714
    "*LICENSE BLD YLW CLC "        # icon e714
    "*tags NON BGRN CLC "          # icon f02c
    "*PKG-INFO NON BGRN CLC "      # icon f05a
    "*Makefile NON CYN CLC "       # icon f0ad
)

LSC=""
for ix in ${!COLORS[*]}
do
    # separate the current string into individual elements
    IFS=' ' read -ra ARR <<< "${COLORS[$ix]}"

    # build the color sequence for the current item
    # index 0 = extension/filename/special
    # index 1 = text attribute
    # index 2 = FG color
    # index 3 = BG color
    # index 4 = icon
    if [[ "${ARR[3]}" == "CLC" ]]
    then
        # NOTE: no semicolon prior to last m<icon>
        LSC+=""${ARR[0]}"=\e["${!ARR[1]}";"$FG";"${!ARR[2]}"m"${ARR[4]}" \e:"
    else
        LSC+=""${ARR[0]}"=\e["${!ARR[1]}";"$BG";"${!ARR[3]}";"$FG";"${!ARR[2]}"m"${ARR[4]}" \e:"
    fi
done
export LS_COLORS=""
# export LS_COLORS="ec=\e[0m:rs=\e[0m:""$LSC"
export LS_COLORS="$LSC"
# export LS_COLORS="$LSC"
# export LS_COLORS=$(ls_colors_generator)

# format should be: <BG><COLOR><ATTR><FG><COLOR>
# <BG><COLOR> can be ommitted (if ommitting omit both)
# <ATTR> can be ommitted for normal text
# examples:
#   1) "$BLD";"$FG";"$RED"  bold red text
#   2) "$FG";"$GRN" regular green text
#   3) "$BG";"$GRN";"$BLD";"$FG";"$RED" green background with bold red text
#   4) "$BLI";"$FG";"$BLU" blinking blue text

# ls colors
# LSC=()
# LSC+=("di=m\e["$BG";"$CLC";"$FG";"$RED"m \e:")
# LSC+=("*README=m\e["$FG";"$BLU"m \e:")
# IFS="" # internal field separator
# echo -e "${LSC[*]}"

# useage: `export LS_COLORS=$(gen_ls_colors.sh)`
# limitations - without modifying ls.c need to use `-w$(expr $(tput cols) - 2)` in ls alias to handle the 2 extra characters (space and icon). Also, specific folders can't have a special color and/or icon.

# possible bashrc settings:
# source gen_ls_colors
#run_ls() {
#    ls --group-directories-first --color=always -N -w$(expr $(tput cols) - 2) "$@"
#}
#alias ls="run_ls"
