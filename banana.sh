# TinyOS and bash util commands for the projects
# Simple invoker of frequently-asked commands:
# it uses some keywords matching commands,
# whose parameters must be passed after the keyword.

# Example 1: banana telosb reset /dev/ttyUSB0
# Example 2: banana telosb install 13 /dev/ttyUSB1  DEST=12

# Syntax:
#
# banana COMMAND 
#
# <mote_arch>		choose the mote architecture of the device to which
#					issue the COMMAND

# --version			displays the banana command version
# --help			displays the banana man page

# Bash completion script for banana command.
# Code skeleton found on AskUbuntu website:
# http://askubuntu.com/questions/68175/how-to-create-script-with-auto-complete

banana_comp() 
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="--help --version"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}
complete -F banana_comp banana