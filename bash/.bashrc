# .bashrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

#PS1='\[\033[01;31m\][\[\033[33m\]\u\[\033[32m\]@\[\033[34m\]\H \[\033[35m\]\w\[\033[31m\]]\[\033[00;37m\]$ '
export PS1="\[\e[31m\][\[\e[m\]\[\e[33m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[34m\]\h\[\e[m\] \[\e[35m\]\w\[\e[m\]\[\e[31m\]]\[\e[m\] \[\e[36m\]\A\[\e[m\] \[\e[32m\]\\$\[\e[m\] "

# enable color support of ls
CLICOLOR=1
LS_COLORS="di=1;34:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

