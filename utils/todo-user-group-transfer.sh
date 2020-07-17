# Change owner of all files belonging to a user/group
# sudo find . -user old_user -group old_group -exec chown new_user:new_group "{}" \;
# add `-h` flag to chown to make it work on symlinks, too!
