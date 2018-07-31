#!/usr/bin/bash

# bd = (BLOCK, BLK)   Block device (buffered) special file
# cd = (CHAR, CHR)    Character device (unbuffered) special file
# di = (DIR)  Directory
# do = (DOOR) [Door][1]
# ex = (EXEC) Executable file (ie. has 'x' set in permissions)
# fi = (FILE) Normal file
# ln = (SYMLINK, LINK, LNK)   Symbolic link. If you set this to ‘target’ instead of a numerical value, the color is as for the file pointed to.
# mi = (MISSING)  Non-existent file pointed to by a symbolic link (visible when you type ls -l)
# no = (NORMAL, NORM) Normal (non-filename) text. Global default
# or = (ORPHAN)   Symbolic link pointing to an orphaned non-existent file
# ow = (OTHER_WRITABLE)   Directory that is other-writable (o+w) and not sticky
# pi = (FIFO, PIPE)   Named pipe (fifo file)
# sg = (SETGID)   File that is setgid (g+s)
# so = (SOCK) Socket file
# st = (STICKY)   Directory with the sticky bit set (+t) and not other-writable
# su = (SETUID)   File that is setuid (u+s)
# tw = (STICKY_OTHER_WRITABLE)    Directory that is sticky and other-writable (+t,o+w)
# *.extension =   Every file using this extension e.g. *.rpm = files with the ending .rpm
# rs=[0m: = reset
# ec=[0m:

#   /* lc: Left of color sequence */
#   /* rc: Right of color sequence */
#   /* ec: End color (replaces lc+no+rc) */
#   /* rs: Reset to ordinary colors */
#   /* no: Normal */
#   /* fi: File: default */
#   /* di: Directory: bright blue */
#   /* ln: Symlink: bright cyan */
#   /* pi: Pipe: yellow/brown */
#   /* so: Socket: bright magenta */
#   /* bd: Block device: bright yellow */
#   /* cd: Char device: bright yellow */
#   /* mi: Missing file: undefined */
#   /* or: Orphaned symlink: undefined */
#   /* ex: Executable: bright green */
#   /* do: Door: bright magenta */
#   /* su: setuid: white on red */
#   /* sg: setgid: black on yellow */
#   /* st: sticky: black on blue */
#   /* ow: other-writable: blue on green */
#   /* tw: ow w/ sticky: black on green */
#   /* ca: black on red */
#   /* mh: disabled by default */
#   /* cl: clear to end of line */

# foreground text attributes
NON="00" # none (normal text, clears previous applied values such as BG color)
BLD="01" # bold
UDS="04" # underline
BLI="05" # blinking (requires terminal setting to be on)
REV="07" # reversed (reverse FG and BG colors)
CON="08" # concealed (nothing is shown ie hides listing)

# foreground or background
FG="033;38;2"
BG="033;48;2"

# color definitions
BLK="0;0;2"             # colour 0: black                       rgb(0,0,2)       = #000002
RED="255;64;0"          # colour 1: red                         rgb(255,64,0)    = #ff4000
GRN="89;128;51"         # colour 2: green                       rgb(89,128,51)   = #598033
YLW="255;191;0"         # colour 3: yellow                      rgb(255,191,0)   = #ffbf00
BLU="48;108;191"        # colour 4: blue                        rgb(48,108,191)  = #306cbf
ORG="255;128;0"         # colour 5: orange (magenta)            rgb(255,128,0)   = #ff8000
CYN="48;191;167"        # colour 6: cyan                        rgb(48,191,167)  = #30bfa7
GRY="212;212;217"       # colour 7: light gray                  rgb(212,212,217) = #d4d5d9
BBLK="11;11;26"         # colour 8: bright black / bg colour    rgb(11,11,26)    = #0b0b1a
BRED="255;121;76"       # colour 9: bright red                  rgb(255,121,76)  = #ff794c
BGRN="133;166;99"       # colour 10: bright green               rgb(133,166,99)  = #85a663
BYLW="255;217;102"      # colour 11: bright yellow              rgb(255,217,102) = #ffd966
BBLU="143;163;191"      # colour 12: bright blue / blue gray    rgb(143,163,191) = #8fa3bf
BORG="255;172;89"       # colour 13: bright orange (magenta)    rgb(255,172,89)  = #ffac59
BCYN="133;204;192"      # colour 14: bright cyan                rgb(133,204,192) = #85ccc0
BWHT="253;253;255"      # colour 15: white                      rgb(253,253,255) = #fdfdff
MGRY="100;100;102"      # rgb(100,100,102)  = #646466
DGRY="62;62;64"         # rgb(62,62,64)     = #3e3e40

# LS COLOR DEFINITIONS:
# each line should contain the following string separated by spaces:
#     <extension or special type> <text attribute> <fg color> <bg color> <icon>
#     set <bg color> to CLC for no background color
#     e.g. "di RED CLC NON "
#     must use the above defined color and attribute strings (create new vars if needed)
# order matters e.g. if you want *README.md one color and other *.md files a different color
# then *README.md should be put AFTER *.md since it will be appplied over the top of *.md
# see https://nerdfonts.com/#cheat-sheet for icon lookup
COLORS=(
    # special
    "di NON GRN CLC "          # directories, icon e5fe
    "ex BLD ORG CLC "          # executable,  icon f135

    # extensions
    "*.md NON YLW CLC "        # icon e609
    "*.markdown NON YLW CLC "  # icon e609
    "*tags NON BGRN CLC "      # icon f02c
    "*.sh NON ORG CLC "        # icon f120
    "*.pem NON CYN CLC "       # icon f084
    "*.txt NON BWHT CLC "      # icon f0f6

    # source code

    # MS office

    # Windows
    "*.lnk NON BCYN CLC "      # icon f482

    # compressed files
    "*.tar NON MGRY CLC "      # icon f0f6
    "*.xz NON MGRY CLC "       # icon f0f6
    "*.zip NON MGRY CLC "      # icon f0f6
    "*.7z NON MGRY CLC "       # icon f0f6

    # file/folder name specific
    "*README.md BLD YLW CLC "  # icon e714
    "*README BLD YLW CLC "     # icon e714
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
        LSC+=""${ARR[0]}"=m\e["${!ARR[1]}";"$FG";"${!ARR[2]}"m"${ARR[4]}" \e:"
    else
        LSC+=""${ARR[0]}"=m\e["${!ARR[1]}";"$BG";"${!ARR[3]}";"$FG";"${!ARR[2]}"m"${ARR[4]}" \e:"
    fi
done
export LS_COLORS=""
export LS_COLORS="$LSC"

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
# limitations - without modifying ls.c need to use `-w$(expr $(tput cols) - 2)` in ls alias to handle the 2 extra characters (space and icon). Also, specific filenames or folders can't have a special color and/or icon.

# possible bashrc settings:
# source gen_ls_colors
#run_ls() {
#    ls --group-directories-first --color=always -N -w$(expr $(tput cols) - 2) "$@"
#}
#alias ls="run_ls"
