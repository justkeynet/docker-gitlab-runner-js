FROM node:slim

ADD https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 /usr/bin/dumb-init
RUN chmod +x /usr/bin/dumb-init

RUN apt-get update -y && \
    apt-get install -y curl && \
    curl -s https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.deb.sh | bash && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y gitlab-ci-multi-runner && \
    apt-get clean && \
    apt-get autoremove -y

RUN npm install -g grunt-cli

# Install chrome to run grunt test 
RUN apt-get update -y && \
    apt-get install libxss1 libappindicator1 libindicator7 fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 libatspi2.0-0 libgtk-3-0 libnspr4 libnss3 libx11-xcb1 libxtst6 lsb-release xdg-utils -y && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    mkdir chrome && mv google-chrome-stable_current_amd64.deb chrome &&  cd chrome && \
    dpkg -i google-chrome*.deb && \
    apt-get install -f && \
    cd .. && rm -rf chrome && \
    apt-get clean && \
    apt-get autoremove -y

# Install docker
RUN apt-get install -y \
      gnupg2 \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" && \
    apt-get update -y && \
    apt-get install -y docker-ce && \
    apt-get clean && \
    apt-get autoremove -y
    
VOLUME ["/etc/gitlab-runner", "/etc/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "gitlab-runner"]
CMD ["run", "--user=root", "--working-directory=/home/gitlab-runner"]
