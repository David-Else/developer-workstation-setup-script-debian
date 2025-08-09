# Developer Workstation Setup Script Debian Edition

![Debian_logo](./images/debian_logo.svg)

This guide provides instructions for setting up a developer workstation using Debian 13 "Trixie" (currently unreleased, but in hard freeze). The Ansible playbook automates the installation of software and configurations.

While the software and setup choices are mainly aimed towards developers, it is also suitable for general use.

## Installation

Before running the playbook, follow these steps to install Debian:

### Installing Debian 13

You can use the testing installer until Trixie is released this August:

https://cdimage.debian.org/images/daily-builds/daily/current/amd64/iso-cd/debian-testing-amd64-netinst.iso

> [!NOTE]
> - Do not provide any details for the root account; your user account will then have administrative rights.
> - Leave GNOME as the default desktop environment.
> - If you installed from a DVD ISO, use the Software & Updates application or the terminal to remove `cdrom` from `/etc/apt/sources.list`. Look in the Other Software tab:
> ![Software & Updates](./images/sources.png)

## Setting up Debian

1. Open the terminal and run the following command to install Ansible, Git, and Flatpak:
   ```sh
   sudo apt install ansible git flatpak
   ```

2. Clone this repository and navigate into it:
   ```sh
   git clone https://github.com/David-Else/developer-workstation-setup-script-debian
   cd developer-workstation-setup-script-debian
   ```

3. Customize the software selection by modifying `packages.yml` according to your preferences.

4. Run the main installation playbook:
   ```sh
   ansible-playbook ./install-playbook.yml -K
   ```

> [!NOTE]
> When prompted for the `BECOME` password in Ansible, enter your user password. Your account must have administrative privileges.
>
> You can add `--check` for a test run or `--diff -vv` to see more information.

5. To enable the preview feature in the `nnn` file manager, run it once with the `-a` flag to create the FIFO file. Install the plugins using:
   ```sh
   sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
   ```

6. Install showmethekey:
   ```sh
   cd extras
   unzip showmethekey-1.12.0-compiled.zip
   cd showmethekey-1.12.0
   sudo ./install-show-me-the-key.sh
   ```

7. Install Firefox extensions:
   ```sh
   firefox https://addons.mozilla.org/en-GB/firefox/addon/ublock-origin/ \
       https://addons.mozilla.org/en-US/firefox/addon/surfingkeys_ff/ \
       https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/ &
   ```

8. Compile the `tt` terminal typing test from source:
   ```sh
   git clone https://github.com/lemnos/tt
   cd tt
   make && sudo make install
   ```

9. Change the visudo editor to Vim:
   ```sh
   sudo update-alternatives --config editor
   ```

10. Install Rust and AIChat:
    ```sh
    set -o pipefail &&
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y &&
    . "$HOME/.cargo/env" &&
    rustup component add rust-analyzer &&
    cargo install aichat --version 0.30.0 &&
    sudo cp ./extras/_aichat /usr/share/zsh/vendor-completions/
    ```

11. Reboot the system:
    ```sh
    sudo reboot
    ```

## Optional Tweaks

Depending on your software selection, hardware, and personal preferences, you may want to make the following changes:

### Audio

Confirm that the allowed sample rate settings were changed by the playbook using:
```sh
pw-metadata -n settings
```

Monitor per-application sample rates dynamically with:
```sh
pw-top
```

> [!NOTE]
> More information can be found at: [docs.pipewire.org configuration-file-pipewireconf](https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-PipeWire#configuration-file-pipewireconf)

### General

To perform general tweaks, follow these steps:

- Set Helix to open in Kitty by editing the desktop entry:
  ```sh
  sudoedit /usr/share/applications/Helix.desktop
  ```

  To open Helix in a standalone Kitty instance:
  ```ini
  Exec=kitty --single-instance hx %F
  Terminal=false
  ```

  Or to open Helix in a tab of an existing Kitty instance:
  ```ini
  Exec=open-in-kitty-helix %F
  Terminal=false
  ```

  Create the script `open-in-kitty-helix`:
  ```sh
  #!/bin/bash

  FILE="$1"

  # If no file is given, treat it as a "new file" with no path
  if [ -z "$FILE" ]; then
      FILE=""
      TITLE="New File"
  else
      TITLE="${FILE##*/}" # basename only
  fi

  # Find the first kitty socket in /tmp
  SOCKET_PATH=$(ls /tmp/kitty-* 2>/dev/null | head -1)

  # If no socket found, start kitty with hx
  if [ -z "$SOCKET_PATH" ]; then
      kitty hx "$FILE" &
      exit 0
  fi

  SOCKET="unix:$SOCKET_PATH"

  # Check if kitty is responsive
  if kitty @ --to "$SOCKET" ls >/dev/null 2>&1; then
      # Only check for duplicates if a real file is given
      if [ -n "$FILE" ]; then
          if kitty @ --to "$SOCKET" ls | grep -qF "$FILE"; then
              notify-send "File Already Open" "The file '$FILE' is already open."
              exit 1
          fi
          # Launch hx with the file
          kitty @ --to "$SOCKET" launch --type=tab --title="$TITLE" hx "$FILE"
      else
          # No file: launch hx with no arguments (so it doesn't open '.')
          kitty @ --to "$SOCKET" launch --type=tab --title="$TITLE" hx
      fi
  else
      # Stale socket, remove and start fresh
      rm -f "$SOCKET_PATH"
      if [ -n "$FILE" ]; then
          kitty hx "$FILE" &
      else
          kitty hx &
      fi
  fi
  ```

  Make the script executable:
  ```sh
  sudo cp open-in-kitty-helix /usr/local/bin/
  sudo chmod +x /usr/local/bin/open-in-kitty-helix
  ```

- Configure Git user details:
  ```sh
  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"
  ```

  Enable GPG signing for commits:
  ```sh
  git config --global user.signingkey key
  git config --global commit.gpgsign true
  ```

- Install GitHub CLI extensions:
  ```sh
  gh extension install yusukebe/gh-markdown-preview
  gh extension install dlvhdr/gh-dash
  hx ~/.config/gh-dash/config.yml  # Set diff: "delta"
  ```

- Install virtual video device support:
  ```sh
  sudo apt install v4l2loopback-dkms v4l2loopback-utils
  ```

## FAQ

If you encounter a "no bootable device found" error after installing Debian, refer to: https://itsfoss.com/no-bootable-device-found-ubuntu/. In short, add `shimx64.efi` as a trusted EFI file to be executed.

> [!NOTE]
> **Bonus**: If you are using Debian as a virtual machine, install `spice-vdagent` and restart to enable copy and paste functionality. It should be installed by default on a Debian 13 guest. Verify it is running with:
> ```sh
> sudo systemctl status spice-vdagent
> ```
> Enable it at boot if necessary:
> ```sh
> sudo systemctl enable spice-vdagent
> ```
