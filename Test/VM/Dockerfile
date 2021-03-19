FROM ubuntu

RUN apt-get update -y
RUN apt-get install git -y
RUN apt-get install llvm -y
RUN apt-get install clang -y
RUN git clone https://github.com/odin-lang/Odin.git /usr/share/odin
WORKDIR /usr/share/odin
RUN ./build.sh
RUN mkdir /var/bvm
RUN mkdir /var/bvmasm

CMD /usr/share/odin/odin build /var/bvm/Source/BreezeVM -collection:breeze=/var/bvm/Source/BreezeVM -collection:assembler=/var/bvm/Source/Assembler -out:/var/bvm/bin/bvm \
    && /usr/share/odin/odin build /var/bvm/Source/Assembler -collection:breeze=/var/bvm/Source/BreezeVM -collection:assembler=/var/bvm/Source/Assembler -out:/var/bvm/bin/bvmasm \
    && cd /var/bvmasm \
    && rm -f *.bbc \
    && find /var/bvmasm -type f | xargs /var/bvm/bin/bvmasm \
    && /var/bvm/bin/bvm program.bbc