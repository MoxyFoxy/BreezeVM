FROM ubuntu

RUN apt-get update -y
RUN apt-get install git -y
RUN apt-get install llvm -y
RUN apt-get install clang -y
RUN git clone https://github.com/odin-lang/Odin.git /usr/share/odin
RUN cd /usr/share/odin
RUN ./build.sh
RUN cd /usr/bin
RUN ln -s /usr/bin /usr/share/odin/odin odin
RUN mkdir /var/BreezeVM_Test

ADD source /var/BreezeVM_Test

CMD cd /var/BreezeVM_Test && odin run .