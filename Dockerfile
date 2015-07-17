FROM ubuntu:15.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade && apt-get -y dist-upgrade

RUN apt-get install -y git python build-essential xorg

WORKDIR /
RUN git clone https://github.com/pybombs/pybombs.git
WORKDIR /pybombs
ADD pybombs/config.dat /pybombs/config.dat

RUN ./pybombs inv
# Fix version
RUN sed -i '/^depends: /a gitrev: tags/v3.7.7.1' /pybombs/recipes/gnuradio.lwr
# Temporary fix - didn't compile with 'uhd' depdency
RUN sed -i "/^depends: /c\depends: make boost fftw cppunit swig gsl alsa git python cheetah wxpython numpy lxml pygtk pycairo cmake pyqt4 pyqwt5 gcc apache-thrift liblog4cpp" /pybombs/recipes/gnuradio.lwr
RUN ./pybombs install gnuradio gr-osmosdr gr-adsb

WORKDIR /pybombs/src/gr-adsb/examples
RUN grcc -d . flowgraph.grc
CMD ./run.sh
