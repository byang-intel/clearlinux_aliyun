# Clearlinux development BKM

- [Install](#install)
	* [bare metal and virtual machine](#bare-metal-and-virtual-machine)
	* [Aliyun ECS](#aliyun-ecs)
- [One-time-setup](#one-time-setup)
	* [install bundles for clearlinux development](#install-bundles-for-clearlinux-development)
	* [setup user for clearlinux development](#setup-user-for-clearlinux-development)
	* [download clearlinux source](#download-clearlinux-source)
	* [Optional - local clearlinux repo mirror setup](#Optional---local-clearlinux-repo-mirror-setup)
- [Examples](#examples)
	* [Build pre-packaged Clear packages](#build-pre-packaged-clear-packages)
	* [Create new package with autospec](#create-new-package-with-autospec)
	* [Test package with Qemu](#test-package-with-qemu)
	* [Create clearlinux with mixer](#create-clearlinux-with-mixer)
		* [web server setup](#web-server-setup)
		* [create update and release image from scratch](#create-update-and-release-image-from-scratch)
		* [create update based on previous version](#create-update-based-on-previous-version)

## Install
### bare metal and virtual machine
Refer to the official [clearlinux get-started document](https://clearlinux.org/documentation/clear-linux/get-started)
### Aliyun ECS
Refer to [Clearlinux Aliyun](aliyun/README.md)

## One-time-setup
### install bundles for clearlinux development
```
swupd bundle-add os-clr-on-clr kvm-host
```
### setup user for clearlinux development
```
USER_NAME=clear
USER_ID=1000
USER_GID=1000
USER_PASSWD="intel@123"

echo 'Defaults env_keep += "HTTP_PROXY HTTPS_PROXY ftp_proxy http_proxy https_proxy no_proxy"' | EDITOR='tee -a' visudo

groupadd -o -g $USER_GID $USER_NAME
useradd -Nmo -g $USER_GID -G mock,wheelnopw -u $USER_ID $USER_NAME
echo -e "$USER_PASSWD\n$USER_PASSWD" | passwd clear

sed "s/PasswordAuthentication.*/PasswordAuthentication yes/g" -i /etc/ssh/sshd_config
systemctl restart sshd

git config --global user.name "$USER_NAME"
git config --global user.email "$USER_NAME@example.com"

# it needs docker for mixer
systemctl enable docker
systemctl start docker
usermod -G docker -a $USER_NAME
```
### download clearlinux source
Login as "clear" and download clearlinux source
```
cd ~/
curl -O https://raw.githubusercontent.com/clearlinux/common/master/user-setup.sh
chmod +x user-setup.sh
./user-setup.sh
cd clearlinux
make clone #To clone a single package repo with NAME, run "make clone_NAME"
```
## Optional - local clearlinux repo mirror setup
By default, both mock and mixer have local cache to speed up the build and mixing. If you have a team working on clearlinux and want to speed up team members build/mixing, it can setup a local mirror.

Download and setup clearlinux repo on a web server:
```
CLR_VER=25860

wget --mirror --convert-links --adjust-extension --page-requisites --no-parent --continue https://download.clearlinux.org/releases/$CLR_VER/clear/x86_64/os
```
Set the mirror url in mock config file:
```
# clearlinux/projects/common/conf/clear.cfg

baseurl=http://<mirror web server>/
```
Use the mirror in mixer:
```
sudo mixer repo set-url clear http://<mirror web server>/
```
## Examples
### Build pre-packaged Clear packages
[Example to build "joe"](examples/example01_build_joe.sh?raw=true).

If you did not run "make clone" to download all clearlinux packages, it can be download by below command.
```
make clone_joe
```
### Create new package with autospec
[helloclear example](examples/example02_autospec_helloclear.sh?raw=true)

[opae-sdk example](examples/example03_autospec_opae-sdk.sh?raw=true)
### Test package with Qemu
[helloclear quick test example](examples/example04_quick_test.sh?raw=true)
### Create clearlinux with mixer
#### web server setup
Refer to [mixer websetup example](examples/example05_mixer_step1_websetup.sh?raw=true) to setup web server for clearlinux update.
#### create update and release image from scratch
[create update and image example](examples/example06_mixer_step2.sh?raw=true)
After creating the release.img, it can test this image with qemu.
```
sudo ./start_qemu.sh release.img"
```
It can run swupd command to check version and bundles inside qemu.
```
swupd info
swupd check-update
swupd bundle-list
swupd bundle-list -a
swupd bundle-add joe-bundle
joe #CTRL+c to exit
poweroff #or press CTRL-a-x to exit qemu
```
#### create update based on previous version
[create delta update example](examples/example07_mixer_step3.sh?raw=true)
It can run swupd command to update and install new bundle inside qemu.
```
swupd check-update
swupd update
swupd bundle-list -a
swupd bundle-add helloclear-bundle
helloclear
poweroff #or press CTRL-a-x to exit qemu
```
