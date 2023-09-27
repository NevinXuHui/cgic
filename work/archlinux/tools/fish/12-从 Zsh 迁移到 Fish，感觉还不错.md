---
banner: "https://picx.zhimg.com/v2-b911764c2cd9d4ab027298104785a4e1_720w.jpg?source=172ae18b"
---
---
url: https://zhuanlan.zhihu.com/p/441328829
title: 从 Zsh 迁移到 Fish，感觉还不错
date: 2023-04-26 12:32:54
tag: 
banner: "https://picx.zhimg.com/v2-b911764c2cd9d4ab027298104785a4e1_720w.jpg?source=172ae18b"
banner_icon: 🔖
---
用 zsh 有七八年了，开始用的是 oh my zsh，后来从 skywind3k 大佬的配置文件里抄来了 antigen，用起来还算不错。不过，也有一个问题困扰了好久，antigen 每加载一个插件，就会往 `PATH` 中塞一个路径，导致路径一大坨，需要改动的时候很难分辨。如下所示：

```
# 可以左右滑动看看有多长
-> % echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/ubuntu/.antigen/bundles/robbyrussell/oh-my-zsh/lib:/home/ubuntu/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/tmux:/home/ubuntu/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/ansible:/home/ubuntu/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git:/home/ubuntu/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/pip:/home/ubuntu/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/colored-man-pages:/home/ubuntu/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/django:/home/ubuntu/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/docker:/home/ubuntu/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/fzf:/home/ubuntu/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/history:/home/ubuntu/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/kubectl:/home/ubuntu/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/colorize:/home/ubuntu/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/github:/home/ubuntu/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/python:/home/ubuntu/.antigen/bundles/zsh-users/zsh-completions:/home/ubuntu/.antigen/bundles/zsh-users/zsh-autosuggestions:/home/ubuntu/.antigen/bundles/Vifon/deer:/home/ubuntu/.antigen/bundles/nojhan/liquidprompt:/home/ubuntu/.antigen/bundles/willghatch/zsh-cdr:/home/ubuntu/.antigen/bundles/zsh-users/zaw:/home/ubuntu/.antigen/bundles/zsh-users/zaw/functions:/home/ubuntu/.antigen/bundles/wfxr/forgit:/home/ubuntu/.antigen/bundles/zsh-users/zsh-syntax-highlighting:/home/ubuntu/.fzf/bin:/home/ubuntu/.local/bin:/home/ubuntu/.dotfiles/bin:/home/ubuntu/repos/lib/go:/home/ubuntu/repos/unity/go/bin


```

不知道是不是因为换了 M1 芯片的 Mac 有什么不兼容的地方（并不是），最近 zsh 的加载速度从 1s 涨到了 4s，以前的速度还勉强可以忍，现在想敲个命令都得等 shell 加载半天，实在受不了了。一开始是打算精简下自己的 zshrc 文件，后来看了看发现完全看不懂这个文件，瞎改一通高亮补全都不见了，要啥啥没有，于是索性换个 shell 了。

第一次用 fish 还是刚去头条实习的时候。记得当时看到 fish 眼前一亮，但是因为 bash 用得都不熟练，而 fish 又和 bash 不兼容就暂时放弃了。当时的 fish 为了特立独行，有些 bash 中受欢迎的地方也删掉了，比如说 `&&` 和 `||` 条件执行两个命令，直到最近才补上。没想到和 fish 一别就是六年，今天再次 `brew install fish` 还真有些一见如故的感觉。

安装好之后还要 `sudo echo $(which fish) >> /etc/shells`(zsh)，然后就可以 `chsh $(which fish)`(zsh)，把 fish 扶到正宫位置了～

虽然 chsh 把 bash/zsh 打入冷宫了，但并不是彻底把她们卸载了。当你需要执行一些 bash 脚本的时候，直接 `bash my_script.sh` 就好了。

## **开箱即用的补全和高亮**

这是原来的 zsh，自动补全和高亮一应俱全，就是启动慢了点。

![](https://pic2.zhimg.com/v2-23c1cc632c06e18cff51ac5d7f66c1b5_r.jpg)

这是新安装的 fish，自动补全和高亮开箱即用，没有装任何插件，只是切换了一个原生主题，**启动飞快**。

![](https://pic2.zhimg.com/v2-03dd05eae1632397f8da6e5ecaa1318d_r.jpg)

更妙的两点是，fish 的自动补全是基于上下文的，在不同的位置会有不同的补全；而且 fish 还会自动解析 man page，智能补全命令。

## **更简单易记的语法**

前面提到 fish 和 bash 是不兼容的，更准确得说，fish 不是一个 posix compatible 的 shell，虽然有些和以前的习惯用法不一样的地方，但是这也意味着 fish 可以摆脱一些历史上的设计错误，从而拨乱反正。

比如说，fish 中不使用 `$(cmd)` 或者 `` `cmd` `` 来执行命令替换，直接使用 `(cmd)`。

fish 中的 for 循环也更像现代编程语言 (Ruby）：

```
for i in *.pdf
    echo $i
end


```

而在 bash/zsh 中需要：

```
for i in *.pdf; do
    echo $i;
done


```

至少对我而言，for 后面的那个分号是特别容易忘记的。

fish 中不需要 heredoc，因为字符串直接是可以跨行的。当然也可以在每行结尾处加上 `\` 转义换行。

```
echo "some string
some more string"


```

相当于 bash 中的：

```
cat <<EOF
some string
some more string
EOF


```

如果你装的新版本的 fish，那么是支持浮点数的，以前在命令行做个简单运算还得打开 python，现在直接：

```
math 2/5  # 0.4 


```

就可以了。不过老版本的 fish 貌似并不支持浮点数，至少 fish 2.7 是这样的。

bash 中最混乱的部分要数字符串了，比如说 `${foo%bar}`（从后向前删除）, `${foo#bar}`（从前向后删除）， 还有 `${foo/bar/baz}`（正则替换），这个 `%` 和 `#` 我从来都不知道是干吗的。在 fish 中全部都替换成了内置命令 string 的方法，和其他语言比较接近，不再是加密代码了。

```
# 替换字符串 ${var/pattern/replacement}
bash -c 'export name=Apple; echo ${name/pp/qq}'
name=Apple string replace pp qq $name

# ${foo#bar}
bash -c 'export name=Apple; echo ${name#App}'
name=Apple string replace App '' $name

# ${foo%bar}
bash -c 'export name=Apple; echo ${name%le}'
name=Apple string replace --regex 'le$' '' $name


```

还有，bash 中的特殊变量也挺难记的，fish 中也都改成了单词：

```
$*, $@, $1 ...: $argv  # 函数或者脚本的参数
$0: status filename  # 函数或者脚本的名字
$#: 使用 $argv 的长度
$?: $status  # 上一个命令的返回值
$$: $fish_pid  # shell 的 pid
$!: $last_pid  # 上一个命令的 pid
$-: 大多数使用是 status is-interactive 和 status is-login


```

fish 中还有一个比较花哨的地方，可以打开浏览器选择主题和各种配置。直接执行 `fish_config` 就打开了。

另一个需要配置的一些地方就是我自己常用的两个函数了：

*   `proxy`, 打开关闭命令行代理
*   `auto_venv`，自动激活和关闭 Python 虚拟环境

以 proxy 来看一下，fish 的函数还是很直观的。

```
function proxy
  if test "$argv[1]" = "on"
    if test "$argv[2]" = ""
      echo "No port provided"
      return 2
    end
    # proxy offered by local shadowsocks
    export http_proxy="http://127.0.0.1:$argv[2]"
    export https_proxy="http://127.0.0.1:$argv[2]"
  else if test "$argv[1]" = "off"
    set -e http_proxy  # set --erase
    set -e https_proxy
  else if test "$argv[1]" != ""
    echo "Usage: 
        proxy          - view current proxy
        proxy on PORT  - turn on proxy at localhost:PORT
        proxy off      - turn off proxy"
    return 1
  end
  echo "Current: http_proxy=$http_proxy https_proxy=$https_proxy"
end


```

最后，还可以把 zsh 的 history 迁移到 fish 中来。令人没想到的是，这都有现成的脚本：

```
pip install zsh-history-to-fish
zsh-history-to-fish -n  # -n 不要转化 && 和 ||


```

fish 需要一段时间才会重新读取 history 文件。至此，迁移完毕啦。

## **后记**

在切换到 fish 之后我还是对 zsh 为什么这么慢念念不忘，在对 `.zshrc` 做了一番 profile 和二分查找之后终于找到了罪魁祸首，和新电脑的硬件并没有什么关系，而是这样一行：

```
[ -d /home/linuxbrew/.linuxbrew/bin ] && path+=(/home/linuxbrew/.linuxbrew/bin)


```

这行人畜无害的命令意思是：如果机器上有 linuxbrew 就把它添加到路径里。而在我的 M1 MacBook，不知道为啥 `/home` 被挂载到了一个网络目录，所以每次打开一个 shell 的时候都会执行一个网络操作，而且这个服务器还可能在美国，能不慢么…… 删除了这行后，zsh 启动又恢复到正常水平。

```
┬─[yifei@bogon:~]─[21:45:06]
╰─>$ ll /home
lrwxr-xr-x  1 root  wheel    25B Dec  4 14:46 /home -> /some/network/volume


```

不过即便如此，切换到 fish 还是值得的，一则简化并看懂了自己的配置，二则对于 shell 启动时间也是有优化的：

```
┬─[yifei@bogon:~]─[19:05:15]
╰─>$ time  zsh -i -c exit

________________________________________________________
Executed in  254.61 millis    fish           external
   usr time  148.16 millis    0.07 millis  148.10 millis
   sys time   98.99 millis    1.59 millis   97.40 millis

┬─[yifei@bogon:~]─[19:07:44]
╰─>$ time fish -i -c exit

________________________________________________________
Executed in   44.84 millis    fish           external
   usr time   16.57 millis    0.08 millis   16.49 millis
   sys time   21.33 millis    1.67 millis   19.66 millis


```

可以看到在我的配置下，fish 比 zsh 还是快多了。

最后贴上自己的配置文件供参考：

```
###### .dotfiles/fishrc ######

# vi:ft=fish
set DISABLE_FZF_AUTO_COMPLETION true
export TERM="xterm-256color"
export EDITOR="vi"

# PATH settings
set PATH $HOME/.local/bin $HOME/.cargo/bin $HOME/.dotfiles/bin $PATH

# Load HomeBrew
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
test -f /opt/homebrew/bin/brew && eval (/opt/homebrew/bin/brew shellenv)
test -f /usr/local/bin/brew && eval (/usr/local/bin/brew shellenv)

if uname | grep Linux
  set PATH /home/linuxbrew/.linuxbrew/bin $PATH
end

# Aliases
alias dc=docker-compose
alias pc=podman-compose
alias t='tmux -2'
alias tmux='tmux -2'
alias cd..='cd ..'
alias py=python
alias ipy='python -m IPython'
alias g='git'
alias ll='ls -alh'
alias :q='exit'
alias :wq='exit'
alias mkdirp='mkdir -p'
alias shn='sudo shutdown -h now'
alias mirror='wget -E -H -k -K -p'
alias sudo='sudo ' # magic trick to bring aliases to sudo
alias px="proxychains4"
alias lcurl='curl --noproxy localhost'
alias save-last-command='history | tail -n 2 | head -n 1 >> ~/.dotfiles/useful_commands'
alias topcpu='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head'
alias topmem='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head'

# Venv auto actiavation
function __auto_source_venv --on-variable PWD --description "Activate/Deactivate virtualenv on directory change"
  status --is-command-substitution; and return

  # Check if we are inside a git directory
  if git rev-parse --show-toplevel &>/dev/null
    set gitdir (realpath (git rev-parse --show-toplevel))
  else
    set gitdir ""
  end

  # If venv is not activated or a different venv is activated and venv exist.
  if test "$VIRTUAL_ENV" != "$gitdir/.venv" -a -e "$gitdir/.venv/bin/activate.fish"
    source $gitdir/.venv/bin/activate.fish
  # If venv activated but the current (git) dir has no venv.
  else if not test -z "$VIRTUAL_ENV" -o -e "$gitdir/.venv"
    deactivate
  end
end

# Proxy switcher
function proxy
  if test "$argv[1]" = "on"
    if test "$argv[2]" = ""
      echo "No port provided"
      return 2
    end
    # proxy offered by local shadowsocks
    export http_proxy="http://127.0.0.1:$argv[2]"
    export https_proxy="http://127.0.0.1:$argv[2]"
  else if test "$argv[1]" = "off"
    set -e http_proxy
    set -e https_proxy
  else if test "$argv[1]" != ""
    echo "Usage: 
        proxy          - view current proxy
        proxy on PORT  - turn on proxy at localhost:PORT
        proxy off      - turn off proxy"
    return 1
  end
  echo "Current: http_proxy=$http_proxy https_proxy=$https_proxy"
end

# Load fzf config
test -f ~/.dotfiles/fzf.fish && source ~/.dotfiles/fzf.fish

###### .config/fish/config.fish ######
if status is-interactive
    # Commands to run in interactive sessions can go here
end

test -f ~/.dotfiles/fishrc && source ~/.dotfiles/fishrc

###### .dotfiles/fzf.fish ######
# vi:syntax=sh

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND='fd --type f'
export FZF_ALT_C_COMMAND='fd --type d'
export FZF_COMPLETION_TRIGGER=''
export FZF_DEFAULT_OPTS="--height 40% --reverse --border --prompt '>>> ' \
    --bind 'alt-j:preview-down,alt-k:preview-up,alt-v:execute(vi {})+abort,ctrl-y:execute-silent(cat {} | pbcopy)+abort,?:toggle-preview' \
    --header 'A-j/k: preview down/up, A-v: open in vim, C-y: copy, ?: toggle preview, C-x: split, C-v: vsplit, C-t: tabopen' \
    --preview 'test (du -k {} | cut -f1) -gt 1024 && echo too big || highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {} 2> /dev/null'"
export FZF_CTRL_T_OPTS=$FZF_DEFAULT_OPTS
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window hidden:wrap --bind '?:toggle-preview'"
export FZF_ALT_C_OPTS="--height 40% --reverse --border --prompt '>>> ' \
    --bind 'alt-j:preview-down,alt-k:preview-up,?:toggle-preview' \
    --header 'A-j/k: preview down/up, ?: toggle preview' \
    --preview 'tree -C {}'"
bind \cr 'commandline --replace -- (history | fzf) || commandline --function repaint'


```

附：Ubuntu 上安装 fish3

```
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish


```

## **参考**

1.  [https://github.com/fish-shell/fish-shell/issues/989](https://github.com/fish-shell/fish-shell/issues/989)
2.  [https://rmpr.xyz/the-fish-shell-is-amazing/](https://rmpr.xyz/the-fish-shell-is-amazing/)
3.  Fish for bash users tutorial
4.  **[Venv auto activate](https://gist.github.com/tommyip/cf9099fa6053e30247e5d0318de2fb9e)**
5.  [https://jvns.ca/blog/2017/04/23/the-fish-shell-is-awesome/](https://jvns.ca/blog/2017/04/23/the-fish-shell-is-awesome/)
6.  [https://launchpad.net/~fish-shell/+archive/ubuntu/release-3?field.series_filter=bionic](https://launchpad.net/~fish-shell/+archive/ubuntu/release-3?field.series_filter=bionic)
7.  [https://fishshell.com/docs/current/cmds/bind.html](https://fishshell.com/docs/current/cmds/bind.html)
8.  [https://stevenvanbael.com/profiling-zsh-startup](https://stevenvanbael.com/profiling-zsh-startup)