HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000

#
# Example .zshrc file for zsh 4.0
#
# .zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#

# THIS FILE IS NOT INTENDED TO BE USED AS /etc/zshrc, NOR WITHOUT EDITING

umask 022

# Set up aliases
alias mv='nocorrect mv -i'       # no spelling correction on mv
alias cp='nocorrect cp -i'       # no spelling correction on cp
alias rm='rm -i'
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias ll='ls -l'
alias la='ls -A'
alias ls='ls --color=auto '



eval $(dircolors)



# Shell functions
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }


# Where to look for autoloaded function definitions
fpath=(~/.config/zsh/zfunc $fpath)

# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
for func in $^fpath/*(N-.x:t); autoload $func

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# manpath=($X11HOME/man /usr/man /usr/lang/man /usr/local/man)
# export MANPATH

# Hosts to use for completion (see later zstyle)
hosts=(`hostname` ftp.math.gatech.edu prep.ai.mit.edu wuarchive.wustl.edu)

typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

setopt prompt_subst

autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f'
zstyle ':vcs_info:*' formats '%F{0}(%B%s%%b%F{0})%%b-[%B%b%%b]'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git svn

precmd() {
    vcs_info
}

setopt prompt_subst


# Set prompts
PS1='%n@%m${SCHROOT_SESSION_ID%%-*}'    # default prompt
[[ -n $VCSH_DIRECTORY ]] && PS1+="! "
PS1+="%# "

RPS1=''                         # prompt for right side of screen
[[ -n $VCSH_DIRECTORY ]] && RPS1+="[${VCSH_DIRECTORY}]"
RPS1+='${vcs_info_msg_0_}-%B%F{2}%~%b'



# Some environment variables
export MAIL=/var/spool/mail/$USERNAME
export HELPDIR=/usr/share/zsh/help/  # directory for run-help function to find docs

MAILCHECK=300
HISTSIZE=2000
DIRSTACKSIZE=20

# Watch for my friends
#watch=( $(<~/.friends) )       # watch for people in .friends file
watch=(notme)                   # watch for everybody but me
LOGCHECK=300                    # check every 5 min for login/logout activity
WATCHFMT='%n %a %l from %m at %t.'

# Set/unset  shell options
setopt   notify noglobdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignorealldups histignorespace pushdsilent noclobber
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash
setopt nonomatch

# Autoload zsh modules when they are referenced
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

# Some nice key bindings
#bindkey '^X^Z' universal-argument ' ' magic-space
#bindkey '^X^A' vi-find-prev-char-skip
#bindkey '^Xa' _expand_alias
#bindkey '^Z' accept-and-hold
#bindkey -s '\M-/' \\\\
#bindkey -s '\M-=' \|

# bindkey -v               # vi key bindings

bindkey -e                 # emacs key bindings
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand

# Setup new style completion system. To see examples of the old style (compctl
# based) programmable completion, check Misc/compctl-examples in the zsh
# distribution.
# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _expand  _ignored _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/moi/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Completion Styles

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
zstyle '*' hosts $hosts

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'

typeset -U PATH
typeset -U path

path ()
{
    if [ -d $1 ]; then
        path=($1 $path)
    fi
}

endpath ()
{
    if [ -d $1 ]; then
        path=($path $1)
    fi
}

path ~/bin
endpath /sbin
endpath /usr/sbin

sshtmp () {
  ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null" "$@"
}

sshnew () {
  ssh -o "StrictHostKeyChecking no" "$@"
}

export ORG_HOME="/home/moi/lang/elisp/org-mode/"


# Set the xterm/tmux title.
print -nP "\e]2;%l %n@%m: %~\a"

[ $TERM = "dumb" ] && unsetopt zle && PS1='$ '

###-tns-completion-start-###
if [ -f /home/moi/.tnsrc ]; then 
    source /home/moi/.tnsrc 
fi
###-tns-completion-end-###

export ANDROID_HOME=/home/moi/Android/Sdk
path /home/moi/prog/jdk1.8.0_231/bin
path /home/moi/prog/node/bin
export JAVA_HOME=/home/moi/prog/jdk1.8.0_231
endpath $ANDROID_HOME/tools
endpath $ANDROID_HOME/tools/bin
endpath $ANDROID_HOME/platform-tools
endpath $ANDROID_HOME/emulator
