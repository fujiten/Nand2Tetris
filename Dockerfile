FROM openjdk:8
RUN apt-get update -qq &&  apt-get install -y libxrender1 libxtst6 libxi6
RUN mkdir /Nand2Tetris
WORKDIR /Nand2Tetris
ADD . /Nand2Tetris
ENV DISPLAY=:0.0
