# dotfiles
Personal environment preferences and settings, mostly for Ubuntu, Cygwin, and WSL.


## Getting Started 
Install the dotfiles by cloning the Git repository and running the install script:

    git clone https://github.com/jamesb/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ./install

When running the install script, optional targets can be added, if a YAML config file exists for them. That is, for target **foo**, a **foo.config.yaml** file must exist in the base directory. (Platform-specific YAML configs will be automatically run by the install script if the platform is detected.)

    ./install foo

### Configuration Management
If this is a new machine and requires software installation, then let Chef do some magic: 

    cd config_mgmt
    sudo ./config.sh
    cd cookbooks/base
    # (may need to remove Berksfile.lock and metadata.json if this is a reinstall/update)
    berks vendor ..
    sudo chef-client -z --runlist "recipe[base::default]"

This will install ChefDK on the machine, along with the software and configuration defined in the base cookbook.

### And Then Manually Install (ugh) ###
These items (for now) require a manual check to see if they are installed, and if not, to install them.

#### On Most Platforms
* [Kakoune](https://kakoune.org)
  - Ubuntu: sudo apt install libncursesw5-dev pkg-config && git clone https://github.com/mawww/kakoune.git && cd kakoune/src && make && PREFIX=$HOME/local make install
* [jq](https://stedolan.github.io/jq/)
  - Ubuntu: sudo apt-get install jq
  - Windows (cmd): curl -L -o %USERPROFILE%/bin/jq.exe https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe
  - Windows (psh): Invoke-WebRequest -MaximumRedirection 1 -OutFile $Env:UserProfile/bin/jq.exe https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe
* [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
* [Universal Ctags](https://github.com/universal-ctags/ctags)

#### On Ubuntu
* Manually select the Droid Sans Mono for Powerline font in Gnome terminal. (Otherwise, we should still get the symbol font, but the patched font looks better.)
  - Edit > Profile Preferences
  - General tab
  - Custom Font: Droid Sans Mono for Powerline 

#### On Windows Subsystem for Linux (WSL):
* [Wsltty](https://github.com/mintty/wsltty)

#### On Windows platforms (WSL and Cygwin):
* Deja Vu Sans Mono for Powerline fonts [(in dotfiles/fonts/deja-vu-sans-mono-ttf)](fonts/deja-vu-sans-mono-ttf)
  - Open in Explorer
  - Right-click on each font file and choose Install

#### Credentials, Keys, and Other Secrets
Security concerns prevent these items from residing in the repo:
* SSH keys
* AWS credentials file

## Structure
Summary of significant directories in these dotfiles
```
├── config_mgmt       Chef cookbooks for configuration management
├── dotbot            Dotfiles bootstrapper
├── extra             For machine-specific startup files not committed to this repo
├── fonts             Monospaced terminal fonts
├── git               Configuration, templates, and hooks for git
├── platforms         Platform-detection script and platform-specific directories
├── runcom            Shell, tmux, and vim rc files
├── system            CLI artifacts - aliases, env vars, path, prompt, shell functions, etc.
├── tmux              Tmux plugins and directories
└── vim               Vim plugins and directories
```

## Additional References
* [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
* [Bash prompt](https://wiki.archlinux.org/index.php/Color_Bash_Prompt)
* [Solarized Color Theme for GNU ls](https://github.com/seebi/dircolors-solarized)

## Credits
This would have been much more difficult without these fine folks and their tools:
* [Dotbot](https://git.io/dotbot) - A tool that bootstraps your dotfiles
* [Chef](https://chef.io/chef) - Configuration management
* File structure and content largely borrowed from [Lars Kappert's dotfiles](https://github.com/webpro/dotfiles)
* Many thanks to the [dotfiles community](https://dotfiles.github.io/).

