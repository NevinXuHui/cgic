---
url: https://www.chezmoi.io/#i-like-chezmoi-how-do-i-say-thanks
title: chezmoi - chezmoi
date: 2023-06-09 18:43:04
tag: 
banner: "undefined"
banner_icon: 🔖
---
Manage your dotfiles across multiple diverse machines, securely.

The latest version of chezmoi is 2.34.0 ([release notes](https://github.com/twpayne/chezmoi/releases/tag/v2.34.0), [release history](https://www.chezmoi.io/reference/release-history)).

chezmoi helps you manage your personal configuration files (dotfiles, like `~/.gitconfig`) across multiple machines.

chezmoi provides many features beyond symlinking or using a bare git repo including: templates (to handle small differences between machines), password manager support (to store your secrets securely), importing files from archives (great for shell and editor plugins), full file encryption (using gpg or age), and running scripts (to handle everything else).

With chezmoi, pronounced /ʃeɪ mwa/ (shay-moi), you can install chezmoi and your dotfiles from your GitHub dotfiles repo on a new, empty machine with a single command:

```
$ sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME


```

As well as the `curl | sh` installation, you can [install chezmoi with your favorite package manager](https://www.chezmoi.io/install/).

Updating your dotfiles on any machine is a single command:

## How do I start with chezmoi?

[Install chezmoi](https://www.chezmoi.io/install/) then read the [quick start guide](https://www.chezmoi.io/quick-start/). The [user guide](https://www.chezmoi.io/user-guide/setup/) covers most common tasks. For a full description, consult the [reference](https://www.chezmoi.io/reference/).

## Should I use chezmoi?

See what other people think about chezmoi by reading [articles](https://www.chezmoi.io/links/articles), listening to [podcasts](https://www.chezmoi.io/links/podcasts), and watching [videos](https://www.chezmoi.io/links/videos) about chezmoi. Read how [chezmoi compares to other dotfile managers](https://www.chezmoi.io/comparison-table/). Explore other people's [dotfile repos that use chezmoi](https://www.chezmoi.io/links/dotfile-repos/).

## I like chezmoi. How do I say thanks?

Please [give chezmoi a star on GitHub](https://github.com/twpayne/chezmoi/stargazers).

[Share chezmoi](https://www.chezmoi.io/links/social-media/) and, if you're happy to share your public dotfiles repo, then [tag your repo with `chezmoi`](https://www.chezmoi.io/links/dotfile-repos/).

[Contributions are very welcome](https://www.chezmoi.io/developer/contributing-changes/) and every [bug report, support request, and feature request](https://github.com/twpayne/chezmoi/issues/new/choose) helps make chezmoi better. Thank you :)

chezmoi does not accept financial contributions. Instead, please make a donation to a charity or cause of your choice.