FROM centos:centos7

RUN yum -y install passwd initscripts openssh-server git
RUN /usr/sbin/sshd-keygen
CMD exec /usr/sbin/sshd -D -e
EXPOSE 8200
RUN mkdir -p /var/lib/git && \
    useradd -d /var/lib/git/repo1 \
            -m \
            -s /usr/bin/git-shell \
            repo1 && \
    passwd -d repo1 && \
    useradd -r authkey && \
    passwd -d authkey && \
    mkdir -p /var/lib/git/repo1/repo1 && \
    cd /var/lib/git/repo1/repo1 && \
    git init --bare && \
    chown -R repo1 /var/lib/git/repo1

ADD ./sshd_config /etc/ssh/
ADD ./get-authorized-keys /gitssh/
RUN chown root /gitssh/get-authorized-keys && \
    chmod 755 /gitssh/get-authorized-keys
