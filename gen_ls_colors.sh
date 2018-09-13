#!/usr/bin/bash

# use 256 colors or 24 bit true color
COLOR_256=false

# whether or not to display icons
ICONS=true

# generate a file with LS_COLORS data
GEN_FILE=false

# text attributes (applies to fg text)
NON="0" # default/normal
BLD="1" # bold
ITL="3" # italic
UDS="4" # underline
BLI="5" # blinking (requires terminal setting to be on)
REV="7" # reversed (reverse FG and BG colors)
CON="8" # concealed (hide text)

# foreground or background
if [[ "$COLOR_256" == true ]]
then
    FG="38;5"
    BG="48;5"

else
    FG="38;2"
    BG="48;2"

    # base colors (from falcon colorscheme)
    B_RED1="178;77;54"      # rgb(178,77,54)
    B_RED2="255;54;0"       # rgb(255,54,0)
    B_RED3="255;142;120"    # rgb(255,142,120)
    B_ORG1="255;118;26"     # rgb(255,118,26)
    B_ORG2="255;176;123"    # rgb(255,176,123)
    B_ORG3="221;207;191"    # rgb(221,207,191)
    B_YLW1="255;197;82"     # rgb(255,197,82)
    B_YLW2="255;211;146"    # rgb(255,211,146)
    B_YLW3="255;232;192"    # rgb(255,232,192)
    B_GRN1="121;140;84"     # rgb(121,140,84)
    B_GRN2="113;142;63"     # rgb(113,142,63)
    B_GRN3="177;191;117"    # rgb(177,191,117)
    B_CYN1="139;204;191"    # rgb(139,204,191)
    B_CYN2="52;191;164"     # rgb(52,191,164)
    B_BLU1="116;126;140"    # rgb(116,126,140)
    B_BLU2="153;164;188"    # rgb(153,164,188)
    B_BLU3="191;218;255"    # rgb(191,218,255)
    B_BLU4="180;180;185"    # rgb(180,180,185)
    B_BLK1="0;0;4"          # rgb(0,0,4)
    B_BLK2="2;2;33"         # rgb(2,2,33)
    B_BLK3="21;21;33"       # rgb(21,21,33)
    B_GRY1="33;33;39"       # rgb(33,33,39)
    B_GRY2="40;40;45"       # rgb(40,40,45)
    B_GRY3="54;54;58"       # rgb(54,54,58)
    B_GRY4="47;47;58"       # rgb(47,47,58)
    B_GRY5="79;79;89"       # rgb(79,79,89)
    B_GRY6="87;87;94"       # rgb(87,87,94)
    B_GRY7="120;120;130"    # rgb(120,120,130)
    B_WHT1="223;223;229"    # rgb(223,223,229)
    B_WHT2="248;248;255"    # rgb(248,248,255)
    B_PRP1="63;58;89"       # rgb(63,58,89)
    B_PRP2="99;81;150"      # rgb(99,81,150)
    B_PRP3="159;151;204"    # rgb(159,151,204)
    B_PRP4="255;95;255"     # rgb(255,95,255)

    # other colors
    WORD_BLU="40;83;149"    # rgb(40,83,149)
    EXCL_GRN="32;112;68"    # rgb(32,112,68)
    ACCS_RED="164;54;57"    # rgb(164,54,57)
    NOTE_PRP="123;54;118"   # rgb(123,54,118)
    OUTL_BLU="0;111;196"    # rgb(0,111,196)
    PWRP_ORG="209;68;36"    # rgb(209,68,36)
    VISI_BLU="54;81;158"    # rgb(53,81,158)
    PDF_RED="207;10;10"     # rgb(207,10,10)
    MAPF_YLW="243;168;17"   # rgb(243,168,17)
    VISS_PRP="134;95;197"   # rgb(134,95,197)

fi

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
    "fi NON B_BLU4 CLC "               #x file,             icon e612
    "di NON B_GRN2 CLC "               #x directory,        icon e5fe
    "ex NON B_RED2 CLC "               #x executable,       icon f135
    "ln NON B_CYN2 CLC "               #x symlink,          icon f178
    "mh BLD B_CYN2 CLC "               #x multi-hardlink,   icon f44c
    "mi NON B_BLK1 B_RED2 "            #x missing link,     icon f837
    "or NON B_BLK1 B_CYN2 "            #x orphaned link,    icon f839
    "bd NON B_YLW2 CLC "               #x block device,     icon f0c8
    "cd NON B_YLW2 CLC "               #x character device, icon f096
    "pi NON B_RED1 CLC "               #x pipe,             icon f1a8
    "so NON B_RED1 CLC "               #x socket,           icon f2da
    "su NON B_BLK1 B_BLU3 "            #x setuid,           icon f007
    "sg NON B_BLK1 B_BLU3 "            #x setgid,           icon f0c0
    "st ITL B_GRN2 CLC "               #x sticky,           icon f249
    "ow ITL B_GRN2 CLC "               #x other-writable,   icon f044
    "tw ITL B_GRN2 CLC "               #x ow w/ sticky,     icon f14b

    # other special (haven't seen yet and couldn't figure out how to create)
    "do BLD B_PRP4 B_WHT2 "            # door,             icon f7a8
    "ca BLD B_PRP4 B_WHT2 "            # capability,       icon e7ad

    # extensions
    "*.pem NON B_CYN1 CLC "            #x icon f084
    "*.txt NON B_BLU4 CLC "            #x icon f0f6
    "*.log NON B_GRY7 CLC "            #x icon f02d

    # markdown
    "*.md NON B_YLW1 CLC "             #x icon e609
    "*.mkdn NON B_YLW1 CLC "           #x icon e609
    "*.markdown NON B_YLW1 CLC "       #x icon e609

    # binary files
    "*.bin NON B_GRY7 CLC "            #x icon f471

    # source code
    "*.c NON B_WHT1 CLC "              #x icon e61e
    "*.h NON B_WHT1 CLC "              #x icon e61e
    "*.cpp NON B_WHT1 CLC "            #x icon e61d
    "*.hpp NON B_WHT1 CLC "            #x icon e61d
    "*.cs NON B_WHT1 CLC "             #x icon f81a
    "*.pdb NON B_GRY7 CLC "            #x icon e7a7
    "*.asm NON B_WHT1 CLC "            #x icon e753
    "*.py NON B_WHT1 CLC "             #x icon f820
    "*.pyc NON B_GRY7 CLC "            #x icon f81f
    "*.prl NON B_WHT1 CLC "            #x icon e769
    "*.cgi NON B_WHT1 CLC "            #x icon e769
    "*.pl NON B_WHT1 CLC "             #x icon e769
    "*.stackdump NON B_GRY7 CLC "      #x icon f6e4
    "*.json NON B_WHT1 CLC "           #x icon e60b

    # libraries
    "*.dll NON B_GRY6 CLC "            #x icon f830
    "*.a NON B_GRY6 CLC "              #x icon f830
    "*.so NON B_GRY6 CLC "             #x icon f830

    # html
    "*.htm NON B_ORG3 CLC "            #x icon e60e
    "*.html NON B_ORG3 CLC "           #x icon e60e
    "*.css NON B_ORG3 CLC "            #x icon e7b6
    "*.xml NON B_ORG3 CLC "            #x icon f72d
    "*.xsd NON B_ORG3 CLC "            #x icon f72d
    "*.js NON B_ORG3 CLC "             #x icon e74e

    # vim
    "*viminfo NON B_GRN1 CLC "         #x icon e7c5
    "*.vim NON B_GRN2 CLC "            #x icon e7c5

    # git
    "*.git NON B_GRN2 CLC "            #x icon f7a1
    "*.gitignore NON B_ORG2 CLC "      #x icon f7a1

    # documents
    "*.pdf NON PDF_RED CLC "           #x icon f1c1
    "*.mfd NON MAPF_YLW CLC "          #x icon f279
    "*.tmp NON B_GRY7 CLC "            #x icon f1b1
    "*.wiki NON B_PRP2 CLC "           #x icon f266

    # Microsoft
    "*.doc NON WORD_BLU CLC "          #x icon f1c2
    "*.docx NON WORD_BLU CLC "         #x icon f1c2
    "*.ppt NON PWRP_ORG CLC "          #x icon f1c4
    "*.pptx NON PWRP_ORG CLC "         #x icon f1c4
    "*.xls NON EXCL_GRN CLC "          #x icon f1c3
    "*.xlsx NON EXCL_GRN CLC "         #x icon f1c3
    "*.vsd NON VISI_BLU CLC "          #x icon e716
    "*.vsdx NON VISI_BLU CLC "         #x icon e716
    "*.msg NON OUTL_BLU CLC "          #x icon f6ee
    "*.one NON NOTE_PRP CLC "          #x icon f89d
    "*.onetoc2 NON NOTE_PRP CLC "      #x icon f89d
    "*.accdb NON ACCS_RED CLC "        #x icon f472
    "*.laccdb NON B_GRY7 CLC "         #x icon f023
    "*.lnk NON B_CYN2 CLC "            #x icon f482
    "*.sln NON VISS_PRP CLC "          #x icon e70c
    "*.csproj NON VISS_PRP CLC "       #x icon e70c
    "*.suo NON B_GRY7 CLC "            #x icon e70c
    "*.resx NON B_GRY7 CLC "           #x icon e70c
    "*.db NON B_PRP3 CLC "             #x icon f08d
    "*.chm NON B_BLU2 CLC "            # icon f00a

    # images
    "*.jpg NON B_PRP3 CLC "            #x icon f1c5
    "*.jpeg NON B_PRP3 CLC "           #x icon f1c5
    "*.JPG NON B_PRP3 CLC "            #x icon f1c5
    "*.png NON B_PRP3 CLC "            #x icon f1c5
    "*.PNG NON B_PRP3 CLC "            #x icon f1c5
    "*.bmp NON B_PRP3 CLC "            #x icon f1c5
    "*.BMP NON B_PRP3 CLC "            #x icon f1c5
    "*.gif NON B_PRP3 CLC "            #x icon f1c5
    "*.svg NON B_PRP3 CLC "            #x icon f1c5
    "*.ai NON B_PRP3 CLC "             #x icon f1c5
    "*.ico NON B_PRP3 CLC "            #x icon f1c5
    "*.tif NON B_PRP3 CLC "            #x icon f1c5
    "*.tiff NON B_PRP3 CLC "           #x icon f1c5
    "*.ps NON B_PRP3 CLC "             #x icon f1c5
    "*.psd NON B_PRP3 CLC "            #x icon f1c5

    # shell
    "*.sh NON B_RED2 CLC "             #x icon f120
    "*.bat NON B_RED2 CLC "            #x icon f120
    "*.cmd NON B_RED2 CLC "            #x icon f120

    # compressed files
    "*.tar NON B_GRY3 CLC "            #x icon f0f6
    "*.xz NON B_GRY3 CLC "             #x icon f0f6
    "*.zip NON B_GRY3 CLC "            #x icon f0f6
    "*.7z NON B_GRY3 CLC "             #x icon f0f6
    "*.gz NON B_GRY3 CLC "             #x icon f0f6
    "*.bz2 NON B_GRY3 CLC "            #x icon f0f6
    "*.iso NON B_GRY3 CLC "            #x icon f0f6

    # config files
    "*vimrc NON B_YLW2 CLC "           #x icon e615
    "*bashrc NON B_YLW2 CLC "          #x icon e615
    "*bash_profile NON B_YLW2 CLC "    #x icon e615
    "*gitconfig NON B_YLW2 CLC "       #x icon e615
    "*minttyrc NON B_YLW2 CLC "        #x icon e615
    "*inputrc NON B_YLW2 CLC "         #x icon e615
    "*taskrc NON B_YLW2 CLC "          #x icon e615
    "*.conf NON B_YLW2 CLC "           #x icon e615
    "*.config NON B_YLW2 CLC "         #x icon e615
    "*.cfg NON B_YLW2 CLC "            #x icon e615

    # file/folder name specific (requires special build of ls for folders)
    "*README.md BLD B_YLW1 CLC "       #x icon e714
    "*README.mkdn BLD B_YLW1 CLC "     #x icon e714
    "*README-cn.md BLD B_YLW1 CLC "    #x icon e714
    "*README BLD B_YLW1 CLC "          #x icon e714
    "*LICENSE BLD B_YLW1 CLC "         #x icon e714
    "*tags NON B_GRN3 CLC "            #x icon f02c
    "*PKG-INFO NON B_GRN3 CLC "        #x icon f05a
    "*Makefile NON B_ORG1 CLC "        #x icon f0ad
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

    # turn icons on/off
    if [[ "$ICONS" == true ]]
    then
        ICN=""${ARR[4]}" "
    else
        ICN=""
    fi

    if [[ "${ARR[3]}" == "CLC" ]]
    then
        # no background color
        LSC+=""${ARR[0]}"=\e["${!ARR[1]}";"$FG";"${!ARR[2]}"m"$ICN":"
    else
        # with background color
        LSC+=""${ARR[0]}"=\e["${!ARR[1]}";"$FG";"${!ARR[2]}";"$BG";"${!ARR[3]}"m"$ICN":"
    fi
done

if [[ "$GEN_FILE" == true ]]
then
    # write LS_COLORS contents to a file
    echo "rs=:ec=\e[0m:lc=:rc=:""$LSC" > ls_colors.txt
else
    # set LS_COLORS directly
    export LS_COLORS=""
    export LS_COLORS="rs=:ec=\e[0m:lc=:rc=:""$LSC"
fi
