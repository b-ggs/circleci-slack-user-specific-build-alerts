FROM base

MAINTAINER boggs <hello@boggs.xyz>

RUN apt-get update
RUN apt-get install -y --force-yes build-essential wget git
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

RUN wget -P /root/src https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz
RUN cd /root/src
RUN tar xvf ruby-2.2.2.tar.gz
RUN cd /root/src/ruby-2.3.1
RUN ./configure
RUN make install

RUN gem update --system
RUN gem install bundler
