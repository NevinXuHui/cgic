
```
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo vi-mode colored-man-pages common-aliases cp extract rsync)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

if [ -x /usr/bin/dircolors ]; then
     test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias dir='dir --color=auto'
        alias vdir='vdir --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
fi

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true
MODE_INDICATOR="%F{white}+%f"
INSERT_MODE_INDICATOR="%F{yellow}+%f"
# defaults
VI_MODE_CURSOR_NORMAL=2
VI_MODE_CURSOR_VISUAL=6
VI_MODE_CURSOR_INSERT=6
VI_MODE_CURSOR_OPPEND=0
#0, 1 - Blinking block
#2 - Solid block
#3 - Blinking underline
#4 - Solid underline
#5 - Blinking line
#6 - Solid line

# alias vv='nvim'

# alias v='vim'

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh      ## 添加配置文件，使插件生效
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/autojump/autojump.zsh
```



## rsync
This plugin adds aliases for frequent rsync commands.

To use it add rsync to the plugins array in you zshrc file.

plugins=(... rsync)
```
Alias	Command
rsync-copy	rsync -avz --progress -h
rsync-move	rsync -avz --progress -h --remove-source-files
rsync-update	rsync -avzu --progress -h
rsync-synchronize	rsync -avzu --delete --progress -h

```



## cp plugin
This plugin defines a cpv function that uses rsync so that you get the features and security of this command.

To enable, add cp to your plugins array in your zshrc file:

plugins=(... cp)
Description
The enabled options for rsync are:

```
-p: preserves permissions.

-o: preserves owner.

-g: preserves group.

-b: make a backup of the original file instead of overwriting it, if it exists.

-r: recurse directories.

-hhh: outputs numbers in human-readable format, in units of 1024 (K, M, G, T).

--backup-dir="/tmp/rsync-$USERNAME": move backup copies to "/tmp/rsync-$USERNAME".

-e /dev/null: only work on local files (disable remote shells).

--progress: display progress.

```


##  git plugin


The git plugin provides many [aliases](#aliases) and a few useful [functions](#functions).

To use it, add `git` to the plugins array in your zshrc file:

```zsh
plugins=(... git)
```

#### Aliases

| Alias                | Command                                                                                                                                                                                  |
| :------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| g                    | git                                                                                                                                                                                      |
| ga                   | git add                                                                                                                                                                                  |
| gaa                  | git add --all                                                                                                                                                                            |
| gapa                 | git add --patch                                                                                                                                                                          |
| gau                  | git add --update                                                                                                                                                                         |
| gav                  | git add --verbose                                                                                                                                                                        |
| gap                  | git apply                                                                                                                                                                                |
| gapt                 | git apply --3way                                                                                                                                                                         |
| gb                   | git branch                                                                                                                                                                               |
| gba                  | git branch --all                                                                                                                                                                         |
| gbd                  | git branch --delete                                                                                                                                                                      |
| gbda                 | git branch --no-color --merged \| grep -vE "^([+*]\|\s*(<span>$</span>(git_main_branch)\|<span>$</span>(git_develop_branch))\s*<span>$</span>)" \| xargs git branch --delete 2>/dev/null |
| gbD                  | git branch --delete --force                                                                                                                                                              |
| gbg                  | git branch -vv | grep ": gone\]"                                                                                                                                                         |
| gbgd                 | local res=$(git branch -vv | grep ": gone\]" | awk '{print $1}') && [[ $res ]] && echo $res | xargs git branch -d                                                                        |
| gbgD                 | local res=$(git branch -vv | grep ": gone\]" | awk '{print $1}') && [[ $res ]] && echo $res | xargs git branch -D                                                                        |
| gbl                  | git blame -b -w                                                                                                                                                                          |
| gbnm                 | git branch --no-merged                                                                                                                                                                   |
| gbr                  | git branch --remote                                                                                                                                                                      |
| gbs                  | git bisect                                                                                                                                                                               |
| gbsb                 | git bisect bad                                                                                                                                                                           |
| gbsg                 | git bisect good                                                                                                                                                                          |
| gbsr                 | git bisect reset                                                                                                                                                                         |
| gbss                 | git bisect start                                                                                                                                                                         |
| gc                   | git commit --verbose                                                                                                                                                                     |
| gc!                  | git commit --verbose --amend                                                                                                                                                             |
| gcn!                 | git commit --verbose --no-edit --amend                                                                                                                                                   |
| gca                  | git commit --verbose --all                                                                                                                                                               |
| gca!                 | git commit --verbose --all --amend                                                                                                                                                       |
| gcan!                | git commit --verbose --all --no-edit --amend                                                                                                                                             |
| gcans!               | git commit --verbose --all --signoff --no-edit --amend                                                                                                                                   |
| gcam                 | git commit --all --message                                                                                                                                                               |
| gcas                 | git commit --all --signoff                                                                                                                                                               |
| gcasm                | git commit --all --signoff --message                                                                                                                                                     |
| gcsm                 | git commit --signoff --message                                                                                                                                                           |
| gcb                  | git checkout -b                                                                                                                                                                          |
| gcf                  | git config --list                                                                                                                                                                        |
| gcl                  | git clone --recurse-submodules                                                                                                                                                           |
| gccd                 | git clone --recurse-submodules "<span>$</span>@" && cd "<span>$</span>(basename <span>$</span>\_ .git)"                                                                                  |
| gclean               | git clean --interactive -d                                                                                                                                                               |
| gpristine            | git reset --hard && git clean -dffx                                                                                                                                                      |
| gcm                  | git checkout $(git_main_branch)                                                                                                                                                          |
| gcd                  | git checkout $(git_develop_branch)                                                                                                                                                       |
| gcmsg                | git commit --message                                                                                                                                                                     |
| gco                  | git checkout                                                                                                                                                                             |
| gcor                 | git checkout --recurse-submodules                                                                                                                                                        |
| gcount               | git shortlog --summary -n                                                                                                                                                                |
| gcp                  | git cherry-pick                                                                                                                                                                          |
| gcpa                 | git cherry-pick --abort                                                                                                                                                                  |
| gcpc                 | git cherry-pick --continue                                                                                                                                                               |
| gcs                  | git commit -S                                                                                                                                                                            |
| gcss                 | git commit -S -s                                                                                                                                                                         |
| gcssm                | git commit -S -s -m                                                                                                                                                                      |
| gd                   | git diff                                                                                                                                                                                 |
| gdca                 | git diff --cached                                                                                                                                                                        |
| gdcw                 | git diff --cached --word-diff                                                                                                                                                            |
| gdct                 | git describe --tags $(git rev-list --tags --max-count=1)                                                                                                                                 |
| gds                  | git diff --staged                                                                                                                                                                        |
| gdt                  | git diff-tree --no-commit-id --name-only -r                                                                                                                                              |
| gdnolock             | git diff $@ ":(exclude)package-lock.json" ":(exclude)\*.lock"                                                                                                                            |
| gdup                 | git diff @{upstream}                                                                                                                                                                     |
| gdv                  | git diff -w $@ \| view -                                                                                                                                                                 |
| gdw                  | git diff --word-diff                                                                                                                                                                     |
| gf                   | git fetch                                                                                                                                                                                |
| gfa                  | git fetch --all --prune                                                                                                                                                                  |
| gfg                  | git ls-files \| grep                                                                                                                                                                     |
| gfo                  | git fetch origin                                                                                                                                                                         |
| gg                   | git gui citool                                                                                                                                                                           |
| gga                  | git gui citool --amend                                                                                                                                                                   |
| ggf                  | git push --force origin $(current_branch)                                                                                                                                                |
| ggfl                 | git push --force-with-lease origin $(current_branch)                                                                                                                                     |
| ggl                  | git pull origin $(current_branch)                                                                                                                                                        |
| ggp                  | git push origin $(current_branch)                                                                                                                                                        |
| ggpnp                | ggl && ggp                                                                                                                                                                               |
| ggpull               | git pull origin "$(git_current_branch)"                                                                                                                                                  |
| ggpur                | ggu                                                                                                                                                                                      |
| ggpush               | git push origin "$(git_current_branch)"                                                                                                                                                  |
| ggsup                | git branch --set-upstream-to=origin/$(git_current_branch)                                                                                                                                |
| ggu                  | git pull --rebase origin $(current_branch)                                                                                                                                               |
| gpsup                | git push --set-upstream origin $(git_current_branch)                                                                                                                                     |
| gpsupf               | git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes (git version >= 2.30)                                                                        |
| gpsupf               | git push --set-upstream origin $(git_current_branch) --force-with-lease (git version < 2.30)                                                                                             |
| ghh                  | git help                                                                                                                                                                                 |
| gignore              | git update-index --assume-unchanged                                                                                                                                                      |
| gignored             | git ls-files -v \| grep "^[[:lower:]]"                                                                                                                                                   |
| git-svn-dcommit-push | git svn dcommit && git push github $(git_main_branch):svntrunk                                                                                                                           |
| gk                   | gitk --all --branches &!                                                                                                                                                                 |
| gke                  | gitk --all $(git log --walk-reflogs --pretty=%h) &!                                                                                                                                      |
| gl                   | git pull                                                                                                                                                                                 |
| glg                  | git log --stat                                                                                                                                                                           |
| glgp                 | git log --stat --patch                                                                                                                                                                   |
| glgg                 | git log --graph                                                                                                                                                                          |
| glgga                | git log --graph --decorate --all                                                                                                                                                         |
| glgm                 | git log --graph --max-count=10                                                                                                                                                           |
| glo                  | git log --oneline --decorate                                                                                                                                                             |
| glol                 | git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)                                                                                 |



# Common Aliases Plugin

This plugin creates helpful shortcut aliases for many commonly used commands.

To use it add `common-aliases` to the plugins array in your zshrc file:

```zsh
plugins=(... common-aliases)
```

## Aliases

### ls command

| Alias | Command      | Description                                                                 |
| ----- | ------------ | --------------------------------------------------------------------------- |
| l     | `ls -lFh`    | List files as a long list, show size, type, human-readable                  |
| la    | `ls -lAFh`   | List almost all files as a long list show size, type, human-readable        |
| lr    | `ls -tRFh`   | List files recursively sorted by date, show type, human-readable            |
| lt    | `ls -ltFh`   | List files as a long list sorted by date, show type, human-readable         |
| ll    | `ls -l`      | List files as a long list                                                   |
| ldot  | `ls -ld .*`  | List dot files as a long list                                               |
| lS    | `ls -1FSsh`  | List files showing only size and name sorted by size                        |
| lart  | `ls -1Fcart` | List all files sorted in reverse of create/modification time (oldest first) |
| lrt   | `ls -1Fcrt`  | List files sorted in reverse of create/modification time(oldest first)      |
| lsr   | `ls -lARFh`  | List all files and directories recursively                                  |
| lsn   | `ls -1`      | List files and directories in a single column                               |

### File handling

| Alias | Command               | Description                                                                     |
| ----- | --------------------- | ------------------------------------------------------------------------------- |
| rm    | `rm -i`               | Remove a file                                                                   |
| cp    | `cp -i`               | Copy a file                                                                     |
| mv    | `mv -i`               | Move a file                                                                     |
| zshrc | `${=EDITOR} ~/.zshrc` | Quickly access the ~/.zshrc file                                                |
| dud   | `du -d 1 -h`          | Display the size of files at depth 1 in current location in human-readable form |
| duf\* | `du -sh`              | Display the size of files in current location in human-readable form            |
| t     | `tail -f`             | Shorthand for tail which outputs the last part of a file                        |

\* Only if the [`duf`](https://github.com/muesli/duf) command isn't installed.

### find and grep

| Alias | Command                                            | Description                          |
| ----- | -------------------------------------------------- | ------------------------------------ |
| fd\*  | `find . -type d -name`                             | Find a directory with the given name |
| ff    | `find . -type f -name`                             | Find a file with the given name      |
| grep  | `grep --color`                                     | Searches for a query string          |
| sgrep | `grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}` | Useful for searching within files    |

\* Only if the [`fd`](https://github.com/sharkdp/fd) command isn't installed.

### Other Aliases

| Alias    | Command            | Description                                                 |
| -------- | ------------------ | ----------------------------------------------------------- |
| h        | `history`          | Lists all recently used commands                            |
| hgrep    | `fc -El 0 \| grep` | Searches for a word in the list of previously used commands |
| help     | `man`              | Opens up the man page for a command                         |
| p        | `ps -f`            | Displays currently executing processes                      |
| sortnr   | `sort -n -r`       | Used to sort the lines of a text file                       |
| unexport | `unset`            | Used to unset an environment variable                       |

## Global aliases

These aliases are expanded in any position in the command line, meaning you can use them even at the
end of the command you've typed. Examples:

Quickly pipe to less:

```zsh
$ ls -l /var/log L
# will run
$ ls -l /var/log | less
```

Silences stderr output:

```zsh
$ find . -type f NE
# will run
$ find . -type f 2>/dev/null
```

| Alias | Command                     | Description                                                 |
| ----- | --------------------------- | ----------------------------------------------------------- |
| H     | `\| head`                   | Pipes output to head which outputs the first part of a file |
| T     | `\| tail`                   | Pipes output to tail which outputs the last part of a file  |
| G     | `\| grep`                   | Pipes output to grep to search for some word                |
| L     | `\| less`                   | Pipes output to less, useful for paging                     |
| M     | `\| most`                   | Pipes output to more, useful for paging                     |
| LL    | `2>&1 \| less`              | Writes stderr to stdout and passes it to less               |
| CA    | `2>&1 \| cat -A`            | Writes stderr to stdout and passes it to cat                |
| NE    | `2 > /dev/null`             | Silences stderr                                             |
| NUL   | `> /dev/null 2>&1`          | Silences both stdout and stderr                             |
| P     | `2>&1\| pygmentize -l pytb` | Writes stderr to stdout and passes it to pygmentize         |

### File extension aliases

These are special aliases that are triggered when a file name is passed as the command. For example,
if the pdf file extension is aliased to `acroread` (a popular Linux pdf reader), when running `file.pdf`
that file will be open with `acroread`.

### Reading Docs

| Alias | Command    | Description                        |
| ----- | ---------- | ---------------------------------- |
| pdf   | `acroread` | Opens up a document using acroread |
| ps    | `gv`       | Opens up a .ps file using gv       |
| dvi   | `xdvi`     | Opens up a .dvi file using xdvi    |
| chm   | `xchm`     | Opens up a .chm file using xchm    |
| djvu  | `djview`   | Opens up a .djvu file using djview |

### Listing files inside a packed file

| Alias  | Command    | Description                       |
| ------ | ---------- | --------------------------------- |
| zip    | `unzip -l` | Lists files inside a .zip file    |
| rar    | `unrar l`  | Lists files inside a .rar file    |
| tar    | `tar tf`   | Lists files inside a .tar file    |
| tar.gz | `echo`     | Lists files inside a .tar.gz file |
| ace    | `unace l`  | Lists files inside a .ace file    |

### Some other features

- Opens urls in terminal using browser specified by the variable `$BROWSER`
- Opens C, C++, Tex and text files using editor specified by the variable `$EDITOR`
- Opens images using image viewer specified by the variable `$XIVIEWER`
- Opens videos and other media using mplayer




