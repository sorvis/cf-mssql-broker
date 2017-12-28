From golang AS base

RUN apt update && apt install -y vim less file \
&& rm -rf /var/lib/apt/lists/*

WORKDIR unixODBC
RUN wget ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.1.tar.gz
RUN tar xf unixODBC-2.3.1.tar.gz

RUN ln -s /usr/local/lib/libodbc.so.2.0.0 /usr/local/lib/libodbc.so.1
RUN ln -s /usr/local/lib/libodbcinst.so.2.0.0 /usr/local/lib/libodbcinst.so.1

RUN ./unixODBC-2.3.1/configure --disable-gui --disable-drivers --enable-iconv --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE
RUN (cd unixODBC-2.3.1) && make
RUN (cd unixODBC-2.3.1) && make install

RUN echo '/usr/local/lib/' >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf

From base as build

RUN go get -u -v github.com/tools/godep
RUN go get github.com/sorvis/cf-mssql-broker
