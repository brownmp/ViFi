FROM ubuntu:18.04
MAINTAINER mbrown@broadinstitute.org
ENV DEBIAN_FRONTEND=noninteractive

#~~~~~~~~~~~~~~
# Install Preliminaries
#~~~~~~~~~~~~~~
RUN apt-get -qq update && apt-get -qq -y install --no-install-recommends \
    automake \
    build-essential \
    bzip2 \
    cmake \
    curl \
    default-jre \
    g++ \
    gcc \
    git \
    libbz2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libdb-dev \
    libjpeg-dev \
    liblzma-dev \
    libpng-dev \
    libreadline-dev \
    libssl-dev \
    libtbb-dev \
    libx11-dev \
    libxml2-dev \
    libxt-dev \
    make \
    pbzip2 \
    pigz \
    python \
    python-pip \
    python-dev \
    python-setuptools \
    r-base \
    unzip \
    wget \
    x11-common \
    zlib1g \
    zlib1g-dev \
    zlibc \
    samtools \
    hmmer

# make python3 be the default python
#RUN ln -sf /usr/bin/python3 /usr/bin/python


#~~~~~~~~~~~
# Python 
#~~~~~~~~~~~
RUN pip install --upgrade pip && pip install \
    pysam 


#~~~~~~~~~~~
# Environmental Variables 
#~~~~~~~~~~~
ENV SRC /usr/local/src
ENV BIN /usr/local/bin




#echo export VIFI_DIR=/path/to/ViFi >> ~/.bashrc
#echo export PYTHONPATH=/path/to/ViFi:/path/to/ViFi/src:$PYTHONPATH >> ~/.bashrc



#~~~~~~~~~~~
## Samtools
#~~~~~~~~~~~
WORKDIR $SRC
ENV SAMTOOLS_VERSION=1.12
RUN SAMTOOLS_URL="https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2" && \
    cd $SRC && \
    wget $SAMTOOLS_URL && \
    tar xf samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd samtools-${SAMTOOLS_VERSION}/htslib-${SAMTOOLS_VERSION} && ./configure && make && make install && \
    cd ../ && ./configure --without-curses && make && make install && \
    rm $SRC/samtools-${SAMTOOLS_VERSION}.tar.bz2 && rm -r $SRC/samtools-${SAMTOOLS_VERSION}


#~~~~~~~~~~~
## Bedtools
#~~~~~~~~~~~
RUN wget -q https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools-2.30.0.tar.gz && \
   tar xf bedtools-2.30.0.tar.gz && \
   cd bedtools2 && \
   make && \
   cp bin/* $BIN/ && \
   rm $SRC/bedtools-2.30.0.tar.gz && rm -r $SRC/bedtools2

#~~~~~~~~~~~~~~
# BWA
#~~~~~~~~~~~~~~
RUN git clone https://github.com/lh3/bwa.git && \
    cd bwa && \
    make && \
    cp -r * $BIN/ && \
    cd .. && \
    rm -r bwa



#  RUN git clone https://github.com/sara-javadzadeh/ViFi.git
ARG CACHEBUST=1
RUN git clone https://github.com/brownmp/ViFi.git


# RUN wget -q https://raw.githubusercontent.com/klarman-cell-observatory/cumulus/master/docker/monitor_script.sh -O $SRC/CTAT-VirusIntegrationFinder/WDL/monitor_script.sh
# RUN chmod a+rx $SRC/CTAT-VirusIntegrationFinder/WDL/monitor_script.sh


RUN apt-get -qq -y remove automake build-essential cmake curl git gcc g++ wget && \
    apt-get -qq -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/log/dpkg.log


