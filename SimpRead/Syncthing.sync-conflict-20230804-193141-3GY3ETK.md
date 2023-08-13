---
url: https://apt.syncthing.net/
title: Syncthing
date: 2023-08-04 11:16:17
tag: 
banner: "https://images.unsplash.com/photo-1688821999533-b0b719348555?crop=entropy&cs=srgb&fm=jpg&ixid=M3w0Njc1ODd8MHwxfHJhbmRvbXx8fHx8fHwxfHwxNjkxMTE4OTcyfA&ixlib=rb-4.0.3&q=85&fit=crop&w=1786&max-h=540"
banner_icon: 🔖
---
To allow the system to check the packages authenticity, you need to provide the release key.

```
# Add the release PGP keys:
sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg

```

The `stable` channel is updated with stable release builds, usually every first Tuesday of the month.

```
# Add the "stable" channel to your APT sources:
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

```

The `candidate` channel is updated with release candidate builds, usually every second Tuesday of the month. These predate the corresponding stable builds by about three weeks.

```
# Add the "candidate" channel to your APT sources:
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing candidate" | sudo tee /etc/apt/sources.list.d/syncthing.list

```

And finally.

```
# Update and install syncthing:
sudo apt-get update
sudo apt-get install syncthing

```

* * *

## Distribution Package Preferred Over This Version

To make sure the system packages do not take preference over those in this repository, you need to adjust the priority/preference.

```
# Increase preference of Syncthing's packages ("pinning")
printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | sudo tee /etc/apt/preferences.d/syncthing

```

## HTTPS Method Driver Missing

Depending on your distribution, you may see an error similar to the following when running `apt-get`:

```
E: The method driver /usr/lib/apt/methods/https could not be found.
N: Is the package apt-transport-https installed?
E: Failed to fetch https://apt.syncthing.net/dists/syncthing/InRelease


```

If so, please install the `apt-transport-https` package and try again:

```
sudo apt-get install apt-transport-https

```

## Server Certificate Verification Failed

Especially for older distributions, your system TLS certificate store might be outdated. Since October 2021, a newer Let's Encrypt root certificate must be installed, or you may see an error similar to the following when running `apt-get`:

```
E: Failed to fetch https://apt.syncthing.net/dists/syncthing/stable/binary-armhf/Packages
server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
E: Some index files failed to download. They have been ignored, or old ones used instead.

```

Please make sure you have the latest version of the `ca-certificates` package and try again:

```
sudo apt-get update
sudo apt-get install ca-certificates

```

* * *

If you insist, you can also use the above URLs with `http` instead of `https`.