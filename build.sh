#!/bin/bash
#set -eux
set -eu
cd "`dirname "$0"`"

main() {
	TMP="./.tmp"
	rm -rf "$TMP"
	mkdir -p "$TMP"
	mkdir -p "./output"
	ls ./input > ./output/input.txt
	for IN in ./input/*; do
		# bash sorcery. https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
		BASE="${IN%.*}"
		FILE="`basename "$BASE"`"
		EXT="${IN##*.}"
		OGG="./output/$FILE.ogg"
		MP4="./output/$FILE.mp4"
		#echo $IN - $BASE - $FILE - $EXT
		if [ -f "$OGG" -a -f "$MP4" ]; then
			echo $IN: already built, skipping
		else
			case "$EXT" in
				mid)
					echo $IN: building midi...
					WAV="./tmp/$FILE.wav"
					mid2wav "$IN" "$WAV"
					wav2ogg "$WAV" "$OGG"
					ogg2mp4 "$OGG" "$MP4"
					rm -f "$WAV"
					;;
				wav)
					echo $IN: building wav...
					wav2ogg "$IN" "$OGG"
					ogg2mp4 "$OGG" "$MP4"
					;;
				ogg)
					echo $IN: building ogg...
					cp -f "$IN" "$OGG"
					ogg2mp4 "$OGG" "$MP4"
					;;
				mp3)
					echo $IN: building mp3...
					mp32ogg "$IN" "$OGG"
					ogg2mp4 "$OGG" "$MP4"
					;;
				*)
					echo $IN: oops, unrecognized file type: $EXT
					exit 1
					;;
			esac
		fi
	done
	rm -rf "$TMP"
}

mid2wav() {
	# https://www.reddit.com/r/Ubuntu/comments/1dfbyyh/convert_many_midi_files_in_mp3/
	timidity "$1" -Ow -o "$2"
}

wav2ogg() {
	# https://superuser.com/questions/1121334/how-to-use-ffmpeg-to-encode-ogg-audio-files
	ffmpeg -i "$1" -c:a libvorbis -b:a 64k "$2"
}

ogg2mp4() {
	IMG="assets/youtube.png"
	# https://stackoverflow.com/questions/25381086/convert-mp3-video-with-static-image-ffmpeg-libav-bash
	#ffmpeg -loop 1 -i "$IMG" -i "$1" -c:a copy -c:v libx264 -shortest "$2"
	# https://askubuntu.com/questions/1315697/could-not-find-tag-for-codec-pcm-s16le-in-stream-1-codec-not-currently-support
	ffmpeg -loop 1 -i "$IMG" -i "$1" -c:a aac -c:v libx264 -shortest "$2"
}

mp32ogg() {
	# mp3s are just as good as oggs, but I insist on consistency
	# https://superuser.com/questions/273797/convert-mp3-to-ogg-vorbis
	ffmpeg -i "$1" -c:a libvorbis -q:a 4 "$2"
}

main
