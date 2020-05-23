# NAME

bg-changer - Perl script for updating the Gnome background

# SYNOPSIS

```bash
./bg-changer
```

# DESCRIPTION

Downloads an image from Unsplash, save it into /var/tmp, and then uses
gsettings to update the Gnome background image.

# POC

This is a proof-of-concept based on some ideas I had after reading
[How To Set Random Wallpapers from Unsplash.com for Ubuntu](http://youness.net/linux/set-random-wallpapers-unsplash-com-ubuntu).

# TODO

* Create a Makefile that can spawn a crontab entry
* Add testing.
* Makefile should be able to install this into /usr/local/bin
* Figure out how to determine if this is a metered connection, to skip downloading
** See [StackOverflow: Detect if current connection is metered with NetworkManager
](https://stackoverflow.com/a/43287215/716443)
* Commandline, ENV, and config file options for file size and search keywords.
* Commandline, ENV, and config file options for caching a few past files so they can still rotate when there's no network connection.

# LICENSE

This software can be distributed under the terms of the artistic2 license.

# AUTHOR

David Oswald
[GitHub Repo: daoswald/bg-changer](https://github.com/daoswald/bg-changer) 
