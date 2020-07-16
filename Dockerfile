FROM python:3.5

ADD bashrc /home/user/.bashrc
ADD start.sh /home/user/start.sh 
ENV PROJETO=
ENV USER=
ENV SENHA=
ENV PROJECT=
ENV VERSION_CHROMEDRIVER=

RUN wget -q -O -  https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
	sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
 	apt-get -y update && \
	apt-get install -y google-chrome-beta && \
	apt-get install -yqq unzip && \
	apt-get install -y sudo && \
	wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/${VERSION_CHROMEDRIVER}/chromedriver_linux64.zip && \
	pip install virtualenv && \
	mkdir -p /usr/src/app/ && \
	git clone https://${USER}:${SENHA}@bitbucket.org/${PROJECT} /usr/src/app/ && \
 	virtualenv /usr/src/app/env -p python3 && \
	. /usr/src/app/env/bin/activate && \
	cd /usr/src/app/ && pip install --no-cache-dir -r requirements.req && \
	mkdir /home/user/Downloads && \
    	echo "user  ALL = ( ALL ) NOPASSWD: ALL" >> /etc/sudoers && \
        unzip /tmp/chromedriver.zip chromedriver -d /usr/src/app/ &&\
        chmod +x /usr/src/app/chromedriver && \
	chmod +x /home/user/start.sh && \	
        useradd -s /bin/bash -u 1000 user && \
        chown -R user:user /home/user &&\
        chown -R user:user /usr/src

VOLUME ["/dev/shm/"]

ADD config.py /usr/src/app/config/config.py	
USER user
WORKDIR /usr/src/app


CMD ["/home/user/start.sh"]
