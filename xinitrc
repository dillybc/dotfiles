[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
setxkbmap -layout gb
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x191970 --height 12 &
xscreensaver -no-splash &
xrandr --output HDMI1 --auto --output HDMI2 --auto --rotate normal --right-of HDMI1
udiskie &
exec xmonad

