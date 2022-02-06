# Vim Files #
My Vim files are based on the environment in the book **Pro Vim** by Mark 
McDonnell, with a few of my own personal changes. The ProVim repo can be found 
at: https://github.com/Integralist/ProVim

Starting from the ProVim repo, I have converted many of the bundles and plugins
into git submodules so that they can be more easily kept up-to-date.

## Installing a Bundle ##
    cd ~/dotfiles/vim/bundle
    git submodule add https://github.com/username/bundlename.git 

## Updating a Bundle ##
    cd ~/dotfiles/vim/bundle
    git pull bundlename
      *OR*
    git submodule update bundlename
    
## Removing a Bundle ##
    cd ~/dotfiles/vim/bundle
    git submodule deinit -f bundlename
    git rm --cached bundlename
    git rm -rf bundlename
      Delete the relevant lines from the ~/dotfiles/.gitmodules file.
    rm -rf ~/dotfiles/.git/modules/vim/bundle/bundlename

## Fonts ##
If the vim status bar seems to be missing characters, install the Ubuntu fonts 
that are found in ~/dotfiles/fonts
