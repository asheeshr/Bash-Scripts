Bash-Scripts
============

Some useful shell scripts.

<h3>notify-highload.sh </h3>

This script generates a notifcation whenever the CPU load increases beyond a specified limit. There are many customization options available via command line parameters.
- Use `-a` to enable for audio notifications (Disabled by default)
- Use `-g` to enable for desktop notifications (Disabled by default)
- Use `-v` for terminal notifications (Disabled by default)
- Set frequency of check using `-p <seconds>`
- Set the limit for high CPU usage using `-l <number>`. This could be any number greater than 0. The scale is a percentage scale, so ideally it should be between 90-100.
- Choose which load average to use with the `-t <minutes>` option. This can be either 1,5 or 15.
- Set gap between notifications using `-n <seconds>`
- Add initial delay to load checking using `-b <seconds>`

These options will last only throughout that specific run of the script. You should use these options to test and figure out what settings work out for you. 
once you know what changes you need to make, you can directly edit the configuration file `~/.highload.cfg` using any editor.

To use this script:
- Create a file called `notify-highload.sh` and paste the code or simply git clone this repository.
- Give the script execution privileges using `chmod +x ./notify-highload.sh`
- Run from terminal or add it to your startup applications. Use atleast one of `-a` or `-g` to enable notifications.

<h5>Tested On</h5>

- Ubuntu 12.04 LTS

<h3>Work in Progress</h3>

- notify-hdspace.sh

<h3>Planned Scripts</h3>
- notify-hdusage.sh
- notify-wifinew.sh
- notify-bluenew.sh
