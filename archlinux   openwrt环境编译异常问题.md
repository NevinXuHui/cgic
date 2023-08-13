```
pacman -S base-devel
```

```
pacman -S [--needed] asciidoc b43-fwcutter bash bc bin86 boost binutils bzip2 cdrkit fastjar flex gawk gettext git gtk2 intltool jdk7-openjdk libusb libxslt ncurses openssl patch perl python2 rsync ruby sdcc sharutils unzip util-linux wget zlib gcc make perl-extutils-makemaker findutils libstdc++5 lib32-libstdc++5 gperf
// 根据wiki，ArchLinux部分必选包在AUR里面
// 从 2015-12-11 开始，bcc和jikes貌似从AUR里消失了，可能是 C++ ABI 更新的缘故，不安装这两个貌似也可以
$ yaourt -S bcc jikes
// ArchLinux 可选
# pacman -S subversion
```
