
# .dotfiles

This repository contains my configurations for various applications.
It uses [dotter](https://github.com/SuperCuber/dotter) to manage templating and symlinking.
I include a x86_64 binary for dotter in the project root.

#### Setting up a new machine:

Dotter uses TOML files to define a machine-specific configuration that may contain many application level configuration files.
Application level configuration files are organized into _packages_ that define where to put configuration files on the target machine.
Each machine specifies which packages to include in a TOML file at `.dotter/local.toml` which is not included in the repository.

On my Ubuntu X11 desktop I include three packages:
```
includes = [".dotter/include/ubuntu.toml"]
packages = ["i3", "nvim", "xdg"]

[files]

[variables]
```

A package can define dependencies which are automatically included along with the dependent.
For example, the `i3` package depends on `alacritty` since I have it configured as my default terminal emulator.
Start the configuration of a new machine by defining a `.dotter/local.toml` file.

To _deploy_ the configuration files according to the `.dotter/local.toml` file:
```
./dotter deploy --dry-run
./dotter deploy -v
```

### Configurations
The following briefly describe what configurations are included in the repository.

#### bash
Default bashrc provided by Fedora Linux.

- Add `cargo` to PATH

#### fish
Pretty nice shell.

- Set abbreviations
- Set vi keybindings mode
- Remove greeting

#### foot
Foot is a terminal emulator that comes with sway. I have adjusted the 
configuration slightly e.g., increase default font size (8 >> 12).

- Make fish default shell

#### nvim
I have added a few configurations to my init.lua.

- Set tab behaviour
- Use `vim-plug` as plugin manager
- Install gitgutter
- Install rust.vim plugin
- Install tex-fmt for formatting tex files
    - Use with conform.nvim for \<leader\>f 

#### sway
Sway is a window manager which aims to replicate the i3 experience on Wayland.
Most of my configuration remains default, but I have added a few things. Most
importantly, I use [waybar](#waybar). Other than that, I think it's basically
just modifications to things like `gaps inner 5`.

- Use waybar
- Mouse pointer speed
- Make capslock be escape
- Add gaps
- Add mod+< and mod+> for moving workspaces
- Add clamshell script for disabling laptop screen with extern monitors

> [!NOTE]
> Sway uses the `dmenu` package for easy access to GUI applications.
> Install via `sudo dnf install dmenu` on Fedora.

#### waybar
Waybar is a third-party extension to sway. It is a command-line instruction
that is invoked by the sway manager during `bar` draws. In my sway config,
this happens at `bar swaybar_command waybar` or something. I prefer a
drastically simplified status bar, so my waybar configuration reflects that.

 - Add battery, with current status indicator (^, v, -)
 - Add network
 - Add date and time
 - Add volume
 - Add CPU usage

#### xdg
I like using lowercase directory names. This clashes with the default 
xdg-user-dir directory names. This configuration changes all of
the default directories to use lowercase. It also disables the execution
of xdg-user-dir-update at login. This prevents my user configuration from
being overwritten by /etc/xdg/user-dirs.dirs at each new login session.

