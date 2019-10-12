# VLC Live Production
A simple script which lets you use VLC as a simple live production software, keeping the
controls and the playlist on the main monitor and the fullscreen video on the secondary
monitor.

The script is just really a collection of the right command line options for VLC plus some 
simple code to manage drag and drop and resolution detection to position the video on the
right monitor.

## Setup

The script is available in various forms:

- a batch script (`.bat`)
- a Powershell script (`.ps1`)
- a bash script (`.sh`) (COMING SOON)

The different forms are simply implementations of the same script in different scripting
languages, for maximum efficacy. You can choose the most useful one for your use case and
stick with it.  
The script operates under the assumption that the computer is setup with a primary monitor
(which will host the VLC window with the playlist and the controls) and _at least_ a
secondary monitor (which will host the fullscreen video output) in extended mode. If more
than a secondary monitor is detected the first secondary monitor will be used and the
others will be ignored.

### Dependencies

The Windows-based implementations (namely batch and Powershell) depend on the MultiMonitorTool
program to retrieve some required info regarding the monitor setup; this program is part of
the NirSoft package: you will have to [download][MultiMonitorTool] it (scroll down until the
"Feedback" section and look for the download links) and place the executable in the same
folder of the script in order for it to work.

The batch implementation has an optional dependency: SetConsole.exe. This program is used
to automatically hide the command window. If you want to use it you will have to
[download][Setconsole] it and place it in the same folder of the script. If the program is
not found the console will remain visible and a message will be shown to the user stating
that they are free to close it whenever they want.

## Usage

The script is extremely easy to use: just download the implementation you want to use,
place it in a folder (together with any dependecy it might need), connect your secondary
monitor, put it in extended mode and run the script. VLC will launch and the control
interface will pop up in the primary monitor. You can then load a playlist or various files,
streams or devices in the playlist view, then double click on one of them to play it
fullscreen on the secondary monitor.  
While the media is being played you can control it (play/pause, volume up/down, skip etc.)
from the control window. Once the playback is terminated the video will close itself, while
the control window will remain open, ready to play another element.

## VLC parameters

Here is an explaination of each parameter passed to VLC in the script. You can have a look
at the [official documentation][vlc command line help] for further details.

- `--quiet`: disable any console output
- `--disable-screensaver`: disable any screensaver during playback
- `--no-random --no-loop --no-repeat`: disable randomization, looping and repeating in the playlist playback
- `--no-playlist-autostart`: do not autostart a playlist when loaded
- `--play-and-stop`: when the reproduction of an element ends close the video window and do not start the reproduction of the next element
- `--no-video-title-show`: do not show the title of the element at the beginning of the reproduction
- `--image-duration=-1`: show images for an unlimited amount of time (until another element of the playlist is played instead of only 10 seconds)
- `--no-embedded-video`: show the video in a separate window fro mthe controls
- `--fullscreen`: play the elements in fullscreen mode
- `--no-qt-fs-controller`: hide the controls on the fullscreen video
- `--video-x=X --video-y=Y`: show the video at this position on the screen

## License

This program is released under the [MIT license][License file].

[MultiMonitorTool]: https://www.nirsoft.net/utils/multi_monitor_tool.html
[Setconsole]: http://prozandcoms.stefanoz.com/setconsole-exe-console-window-control/
[vlc command line help]: https://wiki.videolan.org/VLC_command-line_help
[License file]: LICENSE
