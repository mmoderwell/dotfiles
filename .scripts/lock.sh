#!/bin/bash

rectangles=" "

B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#d2d4d3ff'  # default
T='#d2d4d3ff'  # text
#W='#880000bb'  # wrong
W='#395088ff'  # wrong
V='#DEDEDEff'  # verifying

TMPBG=~/.wallpaper/pixelated.png
scrot $TMPBG && convert $TMPBG -scale 5% -scale 2000% $TMPBG
#-draw "fill black fill-opacity 0.4 $rectangles"

i3lock \
  -i $TMPBG \
  --insidevercolor=$C   \
  --ringvercolor=$V     \
  \
  --insidewrongcolor=$C \
  --ringwrongcolor=$W   \
  \
  --insidecolor=$B      \
  --ringcolor=$D        \
  --linecolor=$B        \
  --separatorcolor=$D   \
  \
  --verifcolor=$T       \
  --wrongcolor=$T       \
  --timecolor=$T        \
  --datecolor=$T        \
  --layoutcolor=$T      \
  --keyhlcolor=$W       \
  --bshlcolor=$W        \
  \
  --screen 1            \
  --blur 5              \
  --clock               \
  --indicator           \
  --timestr="%I:%M"  \
  --datestr="locked" \
  --veriftext=""        \
  --wrongtext=""        \


# --wrongtext="Nope!"
# 
# --timefont=comic-sans
# --datefont=monofur

#stop music before locking
#exec dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop
#&&

rm $TMPBG
