# rofi-scripts

A collection of `rofi`-related scripts I use to make things simpler for myself.

To find them useful, you'll at leat need a Linux-based system with `rofi`,
`perl`, `xsel` and a few other things. Each is (mostly) self-contained, so if
you're insterested in one of them only feel free to pick it and use it. Chances
are it won't need much more than its prerequisites.

If you wnat to use them all, you'll want those scripts in your `$PATH`, too.
Run `./install.sh` to do that, assuming your `$PATH` contains either
`$HOME/bin` or `$HOME/.local/bin`.

Most of the scripts are to be used using something like:

    rofi -modi foo:rofi-foo -modi foo

… where `rofi-foo` is the name of the script, and `foo` is the thing it does.

Some of them interact in some way with i3blocks. Those which do take an
optional `--i3blocks` parameter, in which case they'll display text about
whatever it is they do, and possibly support being clicked with the mouse to
perform some additional action.

## rofi-config

Displays a list of configuration files in `~/.config`. When picked, it launches
a new instance of `kitty` with `nvim` (or `vim`, depending on which it finds)
ready to edit that picked file.

Use it with i3 with something like:

    bindsym $mod+Shift+c exec --no-startup-id rofi -modi config:rofi-config -show config

## rofi-gopass

I'm *not* using this script directly, as "for some reason" it doesn't work.

Use the following instead:

    bindsym $mod+Shift+g exec /home/marco/go/bin/gopass ls --flat | rofi -dmenu -p gopass | xargs --no-run-if-empty /home/marco/go/bin/gopass show -f | head -n 1 | xsel --clipboard --input --selectionTimeout 20000

## rofi-htmlentity

Displays an HTML entity (by name, decimal, and hex) picker.

Requires the `HTML::Entities` and `HTML::HTML5::Entities` Perl modules.
On Debian, you can install the `libhtml-parser-perl` and the
`libhtml-html5-entities-perl` packages to get those.

Use it with i3 with something like:

    bindsym $mod+Shift+u exec --no-startup-id rofi -modi htmlentitiespick:rofi-htmlentity -show htmlentitiespick

Find the character you're looking for by searching for it, or by its HTML name,
or by part of its decimal or hex notation.

## rofi-lpass

I've probably lifted this from somewhere else, and can't remember from where.

Displays a list of `lpass` credentials, and allows you to pick which, and once
picked which, to pick what to copy to clipboard using `xsel`.

Use it with i3 with something like:

    bindsym $mod+Shift+p exec --no-startup-id rofi -modi lpass:rofi-lpass -show lpass

## rofi-pahwah

I use this script to choose from a number of power-related options which may
make the battery life on my ThinkPad a bit better: a lower backlight
brightness, running `powertop --auto-tune`, and things like that.

I bind it to the "fn+f12" or "star" button on the thinkpad, which is neatly
available as `XF86Launch1` in i3, i.e.:

    bindsym XF86Launch1 exec rofi -modi pahwah:rofi-pahwah -show pahwah

## rofi-scratchpad

This script requires the `Cpanel::JSON::XS` Perl module to work. On Debian, you
can install the `libcpanel-json-xs` package and you'll have it.

This script works both as an i3 block script (when called with `--i3blocks`),
and as a rofi script in its own right. As an i3blocks script, you can add:

    [scratchpad]
    command=$HOME/.local/bin/rofi-scratchpad --i3blocks
    label=S:

As an i3block, it displays the amount of windows currently in the scratchpad.

If you left click on the block, it will pop up a rofi picker for which window
to `scratchpad show`.

Useful when you have more than one window in the scratchpad and you want to
bring one back but can't remember which was the last one you brought there.

## rofi-screenlayout

I use this script to choose from a number of pre-configured screen layouts
(i.e. only laptop; laptop + 4k external; 4k external only, etc) and bind it to
the ThinkPad's "fn+f7" or "screens" button, i.e.:

    bindsym XF86Display exec rofi -modi 'ScreenLayout:rofi-screenlayout' -show ScreenLayout

To make this work, you should have a `~/.screenlayout/` directory, containing
*executable scripts* named after the "screen layout" you'd like to be able to
pick from. As an example, i've a `¹ JUST LAPTOP` script, containing:

    #!/bin/bash
    xrandr \
        --output HDMI2    --off \
        --output HDMI1    --off \
        --output VIRTUAL1 --off \
        --output eDP1     --mode 2560x1440 --scale 1x1 --pos 0x0 --rotate normal --primary

... and a `² ONLY HDMI 3840x2160` script, containing:

    #!/bin/sh
    xrandr \
        --output VIRTUAL1 --off \
        --output eDP1     --off \
        --output HDMI1    --off \
        --output DP1      --off \
        --output DP2      --off \
        --output HDMI2 --primary --mode 3840x2160 --pos 0x0 --rotate normal

... and a `¶ DUAL HDMI 1920x1080` script, containing:

    #!/bin/bash
    xrandr \
        --output HDMI1 --off \
        --output HDMI2 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
        --output eDP1            --mode 1920x1080 --pos 0x0 --rotate normal

The idea is: create a script with your favourite layout(s), then use Fn+F7 to
pick from them.  I don't often need more than four or five, so those are the
ones I have in that directory.

The script leaves a log of which layout was picked in `~/.screen-log`. It then
makes use of that file to sort the list shown on rofi so that the last picked
item is NOT displayed as the first item on the list.

In other words, if you often switch between two layouts (as I do) the topmost
item -- and therefore the one that will be shown topmost and readily available
to press enter on -- will very likely be the one you want.

Fn+F7, enter, done.

## rofi-spt

This script needs `spt` from https://github.com/Rigellute/spotify-tui, as well
as Perl's `Mojo` module, which you can get on Debian installing
`libmojolicious-perl`.

On my desk, I often work on my laptop/4k screen and listen to music via the
desktop.  This script helps me control the playback on the desktop.

Use it with i3 with something like:

    bindsym $mod+Control+Shift+s exec --no-startup-id rofi -modi spt:rofi-spt -show spt

It will allow you to skip to next song, play/pause; things like that. It also
has a pickable option for searching for the currently running song's lyrics
using `qutebrowser` and duckduckgo.

## rofi-sshagent

I use https://github.com/ccontavalli/ssh-ident to manage my ssh identities: I
have one SSH identity for each "cluster" of systems I need to log on into, and
more often than not I end up with a system-specific ssh key, too. `ssh-ident`
helps ensure that each identity is only assigned to *one* ssh agent, and that
the "correct" agent is picked when connecting to a box.  In other words, when I
connect to GitHub the SSH agent that gets used to connect there has no
knowledge of any other key.  In yet other words, if I ssh to a compromised box
which uses my forwarded identity to attempt something nefarious, the blast
radius will be whatever that ssh key grants access to, which more often than
not is very little.

I have sometimes a need to see which current identities are loaded, and if I'm
done for the day with a project I may as well just kill the agent so that
attempting to do any further ssh related work with that project will cause the
key passphrase request to pop up again.

I bind it as follows:

    bindsym $mod+s exec --no-startup-id rofi -modi sshagent:rofi-sshagent -show sshagent

... but it also works as an i3block, with something like:

    [ssh-agent-status]
    command=$HOME/.local/bin/rofi-sshagent --i3blocks
    label=👮

In i3 blocks mode, it shows the amount of loaded, live and dead
currently-available SSH agents. Clicking on it runs itself same as the above
`bindsym`.

When used as a rofi picker, it allows to unload/kill a given ssh agent, and has
an option to kill all "stale" agents, as well as "all" agents.

## rofi-sshuttle

I use `sshuttle` as a poor man's VPN/proxy as required.

This script is my attempt at somewhat automating the creation/teardown of
`sshuttle` tunnels, but I've not completed it and I'm not yet using it.

## rofi-tmux

I use a lot of tmux sessions on the laptop. This script works as an i3block
when ran with `--i3blocks`, and displays the amount of total and
currently-attached tmux sessions.

When ran as a rofi picker, it allows one to pick from one of the tmux sessions
and attach to it using `kitty`.

I've bound it in i3 with:

    bindsym $mod+t exec --no-startup-id rofi -modi tmux:rofi-tmux -show tmux

The i3blocks config looks like:

    [tmux]
    command=$HOME/.local/bin/rofi-tmux --i3blocks
    label=T:

## rofi-unipick

Displays a Unicode, NerdFont, and emoji character picker. Requires a recent
Perl, and will (mostly) only know about the Unicode character names that Perl
knows about.

Use it with i3 with something like:

    bindsym $mod+u exec --no-startup-id rofi -modi unipick:rofi-unipick -show unipick

Find the character you're looking for by searching for its name, and hit enter
to have it copied into your X clipboard via `xsel`.

## rofi-vbox

I use VirtualBox to run a few VMs with, and I often want to start one or
another, usually headless. Not very often, I might want to stop them forcibly
as a `sudo shutdown -h` in them hasn't yet completed, or whatever the case.

This script lists all available VMs and their state. Picking a `powered off`
machine starts it up headless; picking a `running` machine asks VirtualBox to
press its ACPI power button, killing it forcibly.

Bind it using:

    bindsym $mod+shift+v exec --no-startup-id rofi -modi vbox:rofi-vbox -show vbox

# Author

Marco Fontani - <MFONTANI@cpan.org> - https://marcofontani.it/ - https://blog.darkpan.com/

# License

Copyright 2021 Marco Fontani <MFONTANI@cpan.org>

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
