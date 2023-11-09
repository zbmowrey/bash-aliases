# Bash Aliases I Really Enjoy

You can do this a few ways: 

1. Copy what you like from .aliases into your own .aliases or .bashrc or .bash_profile. 
2. . install.sh (this will backup your current .aliases if it exists, then install mine).
3. source install.sh (just another way to do step 2). 

## What install.sh

1. Snapshots your current .aliases file in the .alias_storage/previous/(timestamp) file.
2. Installs .aliases from this repo to $HOME/.aliases. 
3. Sources the $HOME/.aliases file (loads code into the current shell). 

## Some safety features have been included...

If it seems unsafe for us to proceed, you should be presented with an option to confirm: 

- ~/.alias_storage/latest doesn't exist. This could happen if you've never run the tool before. 
- Hash mismatch between ~/.alias_storage/latest and ~/.aliases. This makes it seem like you've manually changed
something in ~/.aliases, and those changes would be lost if we proceed. 

## Break Glass in Case of Emergency

In all cases, we copy your ~/.aliases file to ~/.alias_storage/previous/(timestamp) as a historical
record before we make any other changes. This means you should have a full history of file contents
from each time the install.sh has been run. 
