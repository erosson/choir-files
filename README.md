# choir-files

Generate consistently-formatted files for my choir practice. Used for Youtubeifying music of various formats.

I like practicing music with the piano/the rest of the choir in the background. Youtube's a surprisingly good music player for this:

* You can easily link to chapter markers, instead of guessing what minute/second each section starts
* You can use the create-clip interface to loop one section, to drill it repeatedly (without actually creating a clip)
* It's easy to share with others in the choir; everyone uses Youtube and it's free

This repository deliberately does not name the choir I use it for. Hopefully this makes the tool more reusable, and also this repository is public and I like my privacy.

# Usage 

A Linux system with `ffmpeg` and `timidity` are required. (I should really provide these in a docker container...)

One-time setup:

* Move the image to use for videos to `assets/youtube.png`.

To add new music:

* Drop new music into `./input`
* Run `./build.sh`
* In `output`, you'll find an `ogg` music file, and a youtube-compatible single-image `mp4` file for each input.

This tool just converts the files. Go to https://studio.youtube.com/ and upload the unlisted videos yourself.

I use https://mp3chapters.github.io/ to create chapter markers.
