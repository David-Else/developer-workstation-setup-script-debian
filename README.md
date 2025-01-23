# Developer Workstation Setup Script Debian Edition

TODO:

- debian 12 needs kitty installing from the web
- the rust task should probably be run as user?

- ditch zsh and use https://stackoverflow.com/questions/15883416/adding-git-branch-on-the-bash-command-prompt
- alter the helix deb to run kitty as the default terminal
- See if nerd fonts gets into Debian and remove your install if it does
- Recompile nnn with nerd fonts flag
- Recompile showmethekey
- Use upcomiing keyd package and redone installing config
- Use upcoming Blender package
- Consider hugo package if it gets updates to >=134.3 or Helix allows changing .bak filename
- Use the built in go and remove references to downloading it in the readme
- Un-comment android-sdk-platform-tools-common when/if it is out if you still need it
- 14th dec after playbook run gnome-extensions list shows nothing inc non of the apt installed extensions, the extensions gui shows nothing. wait for fix.
- Fix mpv gamepad now you removed file browser script

![Debian_logo](./images/debian_logo.svg)

This guide provides instructions for setting up a developer workstation using Debian 13 "Trixie". The setup scripts automate the installation of necessary software and configurations.

While the software and setup choices are mainly aimed towards developers, it is also suitable for general use.

## Installation

Before running the setup scripts, follow these steps to install Debian 13:

1. Install a fresh copy of Debian 13 from the ISO.

> [!NOTE]
> - Do not provide any details for the root account, your user account will then have administrative rights.
> - Leave Gnome as the default desktop environment.
> - You may need to remove `cdrom` from `/etc/apt/sources.list` after installation.

2. Open the terminal and run the following command to install Ansible and Flatpak:

   ```
   sudo apt install ansible flatpak
   ```

3. Clone this repository and navigate to it:

   ```sh
   git clone https://github.com/David-Else/developer-workstation-setup-script-debian
   cd developer-workstation-setup-script-debian
   ```

4. Customize the software selection by modifying `packages.yml` according to your preferences.

5. Run the main installation playbook:

> [!NOTE]
> When prompted for the `BECOME` password in Ansible, enter your user password. Your account must have administrative privileges.

   ```sh
   ansible-playbook ./install-playbook.yml -K
   ```

6. Log out and in, then run the Gnome and Helix setup:

   ```sh
   ansible-playbook ./gnome-setup-playbook.yml -K
   ```

   ```sh
   ansible-playbook ./compile-helix-playbook.yml -K
   ```

7. To enable the preview feature in the `nnn` file manager, run it once with the `-a` flag to create the FIFO file.

8. Install keyd:

   ```sh
   cd keyd
   make && sudo make install
   sudo systemctl enable keyd && sudo systemctl start keyd
   ```

9. Install showmethekey:

   ```sh
   cd extras
   unzip showmethekey-1.12.0-compiled.zip
   cd showmethekey-1.12.0
   sudo ./install-show-me-the-key.sh
   ```

10. Install Firefox extensions:

```sh

firefox https://addons.mozilla.org/en-GB/firefox/addon/ublock-origin/ \
    https://addons.mozilla.org/en-US/firefox/addon/surfingkeys_ff/ \
    https://addons.mozilla.org/en-US/firefox/addon/leechblock-ng/ \
    https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/ &
```

12. Compile tt from source (`/usr/local/go/bin` is already added to the `$PATH`):

```sh
# download go1.22.4.linux-amd64.tar.gz
# add the language server if needed: go install golang.org/x/tools/gopls@latest
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz
git clone https://github.com/lemnos/tt
cd tt
make && sudo make install
```

13. Setup Hugo completions and man page:

```sh
hugo completion zsh > "${fpath[1]}/_hugo"
sudo hugo gen man --dir /usr/share/man/man1 && sudo mandb
```

## Optional Tweaks

Depending on your software selection, hardware, and personal preferences, you may want to make the following changes:

### Audio

You can confirm the allowed sample rate settings were changed by the playbook with:

```sh
systemctl --user restart pipewire.service
pw-metadata -n settings
```

Watch the sample rates change per application running `pw-top`.

> [!NOTE]
> More info can be found at: [docs.pipewire.org configuration-file-pipewireconf](https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-PipeWire#configuration-file-pipewireconf)

### General

To perform general tweaks, follow these steps:

- Configure Git by setting your email and name. Run the following commands:

  ```sh
  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"
  ```

  If you want to enable GPG signing for commits, use the following commands:

  ```sh
  git config --global user.signingkey key
  git config --global commit.gpgsign true
  ```

- Install extras:

  ```sh
  gh extension install yusukebe/gh-markdown-preview
  gh extension install dlvhdr/gh-dash
  hx ~/.config/gh-dash/config.yml # diff: "delta"
  ```

  `sudo apt install v4l2loopback-dkms v4l2loopback-utils` for virtual video devices

# FAQ

If you would like to use Code for things that Helix still struggles with (like debugging), and still use all the modal keyboard shortcuts, I suggest installing `silverquark.dancehelix` or `asvetliakov.vscode-neovim` and using these settings:

`settings.json`

```jsonc
{
  // font size
  "editor.fontSize": 15,
  "markdown.preview.fontSize": 15,
  "terminal.integrated.fontSize": 15,
  // asvetliakov.vscode-neovim
  "editor.scrollBeyondLastLine": false,
  "vscode-neovim.neovimExecutablePaths.linux": "/usr/local/bin/nvim", // for el9 clones, or "/usr/bin/nvim" for Fedora
  "workbench.list.automaticKeyboardNavigation": false,
  // various
  "window.titleBarStyle": "custom", // adjust the appearance of the window title bar for linux
  "editor.minimap.enabled": false, // controls whether the minimap is shown
  "workbench.activityBar.visible": false, // controls the visibility of the activity bar in the workbench
  "window.menuBarVisibility": "hidden", // control the visibility of the menu bar
  "files.restoreUndoStack": false, // don't restore the undo stack when a file is reopened
  "editor.dragAndDrop": false, // controls whether the editor should allow moving selections via drag and drop
  "telemetry.enableTelemetry": false, // disable diagnostic data collection
}
```

You might also like to install `ms-vscode.live-server` for live debugging in Code or the browser.

If you get no bootable device found after installing Debian, try https://itsfoss.com/no-bootable-device-found-ubuntu/

> [!NOTE]
> Bonus: If you are using gnome-boxes don't forget to install `spice-vdagent` only on the guest AND restart the virtual machine to get copy and paste working. You can check it is running with `sudo systemctl status spice-vdagent` and enable at boot if needed with `sudo systemctl enable spice-vdagent`.
