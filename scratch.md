# command scratch pad
require '/home/b08x/Workspace/sonic-pi-3.2.2/app/server/ruby/lib/sonicpi/scale.rb'

# cleaning up file names

find . -name "*&*" -exec rename -v '&' and '{}' \+

find . -type d -execdir rename -v '_-_' _ '{}' \+
find . -type d -execdir rename -v '[' '' '{}' \+
find . -type d -execdir rename -v ']' '' '{}' \+
find . -type d -execdir rename -v ',' '' '{}' \+



find . -type f -exec chmod 0664 {} +
find . -type d -exec chmod 2775 {} +


# to convert to opus
for f in *.mp3; do ffmpeg -i "$f" -f wav - | opusenc --bitrate 140 - "${f%.flac}.opus"; done
avconv -i input.mp3 -f wav - | opusenc --bitrate 256 - output.opus


dhcp-option=6,192.168.41.2


----

hivel=(\d+)
hivel=$1 amp_velcurve_$1=1

Open the atom/atom project in Atom.
Open the README.md file.
Press Cmd+F to open the find-and-replace panel.
Ensure that Regular Expressions mode is turned on.
Enter (atom.io) in the find field.
Enter foo$1 in the replace field.
Click Find.
Click Replace
