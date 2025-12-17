FROM manjarolinux/base:latest AS base-system
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    SHELL=/bin/zsh \
    TERM=xterm-256color \
    MAKEFLAGS=-j$(nproc)

ARG USERNAME=dev
ARG USER_UID=${DEV_USER_ID:-1001}
ARG USER_GID=${DEV_GROUP_ID:-1001}

RUN --mount=type=cache,target=/var/cache/pacman/pkg \
    --mount=type=cache,target=/tmp \
    sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 20/' /etc/pacman.conf && \
    sed -i 's/#Color/Color/' /etc/pacman.conf && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    pacman -Syyu --noconfirm && \
    pacman -S --noconfirm \
    base-devel \
    yay && \
    pacman -Scc --noconfirm && \
    groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/zsh && \
    chmod 750 /home/$USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/yay, /usr/bin/mkdir, /usr/bin/chmod, /usr/bin/usermod, /usr/bin/groupadd, /usr/bin/groupmod" >> /etc/sudoers


USER $USERNAME
WORKDIR /home/$USERNAME

FROM base-system AS tools

COPY --chown=$USERNAME:$USERNAME scripts/install-pacman-tools.sh /tmp/
RUN --mount=type=cache,target=/var/cache/pacman/pkg \
    chmod +x /tmp/install-pacman-tools.sh && \
    /tmp/install-pacman-tools.sh && \
    rm /tmp/install-pacman-tools.sh

COPY --chown=$USERNAME:$USERNAME scripts/install-aur-tools.sh /tmp/
RUN --mount=type=cache,target=/home/$USERNAME/.cache/yay,uid=$USER_UID,gid=$USER_GID \
    chmod +x /tmp/install-aur-tools.sh && \
    /tmp/install-aur-tools.sh && \
    rm /tmp/install-aur-tools.sh

COPY --chown=$USERNAME:$USERNAME scripts/install-go-tools.sh /tmp/
RUN --mount=type=cache,target=/home/$USERNAME/go,uid=$USER_UID,gid=$USER_GID \
    --mount=type=cache,target=/home/$USERNAME/.cache/go-build,uid=$USER_UID,gid=$USER_GID \
    chmod +x /tmp/install-go-tools.sh && \
    /tmp/install-go-tools.sh && \
    rm /tmp/install-go-tools.sh

COPY --chown=$USERNAME:$USERNAME scripts/install-zsh-plugins.sh /tmp/
RUN --mount=type=cache,target=/home/$USERNAME/.cache/zsh,uid=$USER_UID,gid=$USER_GID \
    chmod +x /tmp/install-zsh-plugins.sh && \
    /tmp/install-zsh-plugins.sh && \
    rm /tmp/install-zsh-plugins.sh

COPY --chown=$USERNAME:$USERNAME scripts/install-tmux-plugins.sh /tmp/
RUN chmod +x /tmp/install-tmux-plugins.sh && \
    /tmp/install-tmux-plugins.sh && \
    rm /tmp/install-tmux-plugins.sh

FROM tools AS final

COPY --chown=$USERNAME:$USERNAME scripts/setup-directories.sh /usr/local/bin/setup-directories.sh
RUN chmod +x /usr/local/bin/setup-directories.sh && /usr/local/bin/setup-directories.sh

USER root
RUN sed -i "s|$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/yay, /usr/bin/mkdir, /usr/bin/chmod, /usr/bin/usermod, /usr/bin/groupadd, /usr/bin/groupmod|$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/yay|" /etc/sudoers

# Embed sudo-wrapper for runtime updates (must do as root)
COPY scripts/sudo-wrapper.sh /usr/local/bin/sudo-wrapper
RUN chmod 755 /usr/local/bin/sudo-wrapper

COPY scripts/start-sshd.sh /tmp/start-sshd.sh
RUN echo "$USERNAME:$USERNAME" | chpasswd
RUN install -o root -g root -m 755 /tmp/start-sshd.sh /usr/local/bin/start-sshd.sh && \
    rm /tmp/start-sshd.sh

EXPOSE 2222
WORKDIR /workspace
CMD ["/usr/local/bin/start-sshd.sh"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
    CMD pgrep sshd || exit 1


