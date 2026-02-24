# ~/.bash_profile: executed by bash for login shells.
# Ensures .bashrc is always sourced, even when .profile is skipped.

# Source .profile first (PATH setup, system defaults)
[[ -f ~/.profile ]] && . ~/.profile

# Source .bashrc if .profile didn't already
# (handles the case where .profile doesn't exist or doesn't source .bashrc)
if [[ -z "$_SHELLRC_LOADED" && -f ~/.bashrc ]]; then
  . ~/.bashrc
fi
