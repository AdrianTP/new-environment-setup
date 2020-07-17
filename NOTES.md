WSL loads as non-login shell, loads .bashrc
Mac loads as login shell, loads .bash_profile
.profile - non-bash, environment variables, PATH, etc.
.bashrc - config for interactive bash, prompt, etc.
.bash_profile - ensure .profile and .bashrc are loaded for login shells
$ su <user>
  loads .bashrc

$ su - <user>
  loads only .bash_profile if exists
  loads only .profile if not

wsl: loads .bash_profile if it exists
