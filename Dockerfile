FROM ubuntu

RUN apt-get update
RUN apt-get -y install build-essential libtool autotools-dev autoconf pkg-config libssl-dev libboost-all-dev wget bsdmainutils libevent-dev

RUN rm -fr /src

COPY ./ /src
WORKDIR /src

RUN rm -fr db4/
RUN mkdir db4/

#RUN wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
RUN tar -xzvf db-4.8.30.NC.tar.gz
WORKDIR /src/db-4.8.30.NC/build_unix/

RUN ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/src/db4/
RUN make install

WORKDIR /src

RUN ./autogen.sh
RUN ./configure LDFLAGS="-L/src/db4/lib/" CPPFLAGS="-I/src/db4/include/" --without-gui
RUN make
#RUN cp src/bitcoind /usr/bin
#RUN cp src/bitcoin-cli /usr/bin
#RUN cp src/bitcoin-tx /usr/bin
#RUN rm -fr /src
