FROM centos:centos7

RUN yum -y install passwd initscripts openssh-server openssh-clients
RUN /usr/sbin/sshd-keygen
CMD exec /usr/sbin/sshd -D -e
EXPOSE 8100
RUN useradd -d /home/user1 \
            -m \
            -s /sshproxy/shell \
            user1 && \
    passwd -d user1 && \
    useradd -r authkey && \
    passwd -d authkey

ADD ./sshd_config /etc/ssh/
ADD ./get-authorized-keys /sshproxy/
RUN chown root /sshproxy/get-authorized-keys && \
    chmod 755 /sshproxy/get-authorized-keys
ADD ./shell /sshproxy/
