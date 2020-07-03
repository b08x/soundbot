# command scratch pad


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
