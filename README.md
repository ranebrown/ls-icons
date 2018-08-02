# How to create special file types
ln: `ln -s source_file link_name`
mh: `ln source_file link_name`
or: delete the file pointed to by a symbolic link
mi: this is the deleted file pointed to by the symbolic link (only visible with `-l` option)
cd: `mknod dcharacter 1 5` (1 5 is major minor rev which is required)
bd: `mknod dblock b 1 5` (1 5 is major minor rev which is required)
pi: `mkfifo pipe_name`
so: `python -c "import socket as s; sock = s.socket(s.AF_UNIX); sock.bind('dsocket')"`
su: create file and run `chmod 4750 file_name`
sg: create file and run `chmod 2750 file_name`
st: create directory then run `chmod +t dir_name`
ow: create directory then run `chmod o+w dir_name`
tw: create directory then run `chmod +t,o+w dir_name`

## Unable to create
do: ??? Solaris only
ca: use `setcap` http://www.andy-pearce.com/blog/posts/2013/Mar/file-capabilities-in-linux/
