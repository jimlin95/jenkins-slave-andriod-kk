#
# Minimum Docker image to build Android AOSP
#
FROM evarga/jenkins-slave:latest
MAINTAINER jim_lin <jim_lin@quantatw.com> 


RUN mkdir /home/jenkins/.ssh -p
ADD apt.conf /etc/apt/
ADD .ssh/ /home/jenkins/.ssh
ADD gitconfig /home/jenkins/.gitconfig

RUN echo "export USE_CCACHE=1" >> /home/jenkins/.bashrc
RUN echo "export CCACHE_DIR=/tmp/ccache" >> /home/jenkins/.bashrc
RUN mkdir /home/jenkins/workspace
RUN chown -R jenkins:jenkins /home/jenkins/workspace
RUN chown -R jenkins:jenkins /home/jenkins/.ssh 
RUN chown -R jenkins:jenkins /home/jenkins/.gitconfig 
# Keep the dependency list as short as reasonable
RUN apt-get update && \
    apt-get install -y bc bison bsdmainutils build-essential curl \
        flex g++-multilib gcc-multilib git gnupg gperf lib32ncurses5-dev \
        lib32readline-gplv2-dev lib32z1-dev libesd0-dev libncurses5-dev \
        libsdl1.2-dev libwxgtk2.8-dev libxml2-utils lzop mingw32 tofrodos\
        pngcrush schedtool xsltproc zip zlib1g-dev openjdk-7-jdk python-lxml && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://storage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

# Improve rebuild performance by enabling compiler cache
ENV USE_CCACHE 1
ENV CCACHE_DIR /tmp/ccache
ENV http_proxy="http://10.241.104.240:5678/"
ENV https_proxy="http://10.241.104.240:5678/"
