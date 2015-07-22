if [[ -f ~/.dir_colors ]]; then
   eval $(dircolors -b ~/.dir_colors)
elif [[ -f /etc/DIR_COLORS ]]; then
   eval $(dircolors -b /etc/DIR_COLORS)
else
   eval $(dircolors)
fi

if [ "${HOSTNAME}" == "itiner" ]; then
    export GNUPGHOME="/nfshomes/barry/.gnupg_itiner"
    exec zsh
fi

