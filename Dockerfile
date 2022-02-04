FROM ubuntu:16.04
RUN apt-get update
RUN apt-get -y install curl
RUN curl https://github.com/Codehunter-py/Shell-scripting.git