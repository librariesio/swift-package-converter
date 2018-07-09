
FROM ubuntu:14.04

RUN apt-get -qq update

# Install swift run-time and build dependencies
RUN apt-get -qq -y install lsb-release curl git cmake ninja-build clang python uuid-dev libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython-dev libncurses5-dev pkg-config

# Install swiftenv
ENV SWIFTENV_ROOT /usr/local
ADD https://github.com/kylef/swiftenv/archive/1.2.0.tar.gz /tmp/swiftenv.tar.gz
RUN tar -xzf /tmp/swiftenv.tar.gz -C /usr/local/ --strip 1

# Add swiftenv shims to PATH
ENV PATH /usr/local/shims:$PATH
RUN swiftenv install --no-build DEVELOPMENT-SNAPSHOT-2016-09-06-a
COPY . /package
WORKDIR /package
RUN swift build

EXPOSE 8080

# mount in local sources via:  -v $(PWD):/package
CMD .build/debug/App
