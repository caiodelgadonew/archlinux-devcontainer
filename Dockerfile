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

ARG	REPO_OWNER
ARG	REPO_NAME
ARG	VERSION
ARG	GIT_COMMIT_SHA
ARG	BUILD_DATE

LABEL org.opencontainers.image.title="Arch Linux Development Container"
LABEL org.opencontainers.image.description="Archlinux Dev Container with AUR Support"
LABEL org.opencontainers.image.authors="Caio Delgado <github.com/caiodelgadonew> (@caiodelgadonew)"
LABEL org.opencontainers.image.url="https://github.com/${REPO_OWNER}/${REPO_NAME}"
LABEL org.opencontainers.image.documentation="https://github.com/${REPO_OWNER}/${REPO_NAME}#readme"
LABEL org.opencontainers.image.source="https://github.com/${REPO_OWNER}/${REPO_NAME}"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.revision="${GIT_COMMIT_SHA}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"

COPY 	--from=builder /usr/sbin/yay /usr/sbin/yay

RUN	yay -Syu --noconfirm sudo yq which unzip \
	&& curl -s https://raw.githubusercontent.com/caiodelgadonew/ansible-archlinux/refs/heads/main/roles/archlinux/vars/main.yml | yq '.yay_packages[]' | xargs yay -S --noconfirm \
	&& yay -S --noconfirm consul nomad vault \
	&& git clone https://github.com/tfutils/tfenv.git /opt/tfenv \
	&& ln -s /opt/tfenv/bin/* /usr/local/bin \
	&& pacman -Sc --noconfirm \
	&& rm -rf /var/cache/pacman/pkg/* /tmp/*

