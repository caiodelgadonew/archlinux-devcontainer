FROM	archlinux:base-devel AS builder

RUN	pacman -Syu --noconfirm git \
	&& mkdir -p /tmp/yay \
	&& useradd -mG wheel builder && passwd -d builder \
	&& chown -R builder:builder /tmp/yay \
	&& echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER	builder

RUN	git clone https://aur.archlinux.org/yay.git /tmp/yay \
	&& cd /tmp/yay \
	&& makepkg -si --noconfirm \
	&& which yay

FROM	archlinux:latest

COPY 	--from=builder /usr/sbin/yay /usr/sbin/yay

RUN	yay -Syu --noconfirm sudo yq which \
	&& curl -s https://raw.githubusercontent.com/caiodelgadonew/ansible-archlinux/refs/heads/main/roles/archlinux/vars/main.yml | yq '.yay_packages[]' | xargs yay -S --noconfirm \
	&& yay -S --noconfirm consul nomad terraform vault

