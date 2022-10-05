FROM python:3.8-slim

RUN mkdir /etc/.pip
RUN echo "[global]" >> /etc/pip.conf
RUN echo "index-url = https://cae-artifactory.jpl.nasa.gov/artifactory/api/pypi/pypi-release-virtual/simple" >> /etc/pip.conf
RUN echo "trusted-host = cae-artifactory.jpl.nasa.gov pypi.org" >> /etc/pip.conf
RUN echo "extra-index-url = https://pypi.org/simple" >> /etc/pip.conf

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
    gcc \
    libnetcdf-dev \
    libhdf5-dev \
    hdf5-helpers \
    && apt-get -y install git \
    && apt-get -y install curl \
    && apt-get -y install jq \
    && pip3 install --upgrade pip \
    && pip3 install cython \
    && pip3 install papermill \
    && pip3 install xarray \
    && pip3 install jupyter \
    # && pip3 install black \
    && pip3 install matplotlib \
    && pip3 install netCDF4 \
    && pip3 install python-cmr \
    && pip3 install git+https://github.com/nasa/harmony-py.git \
    && pip3 install git+https://github.com/podaac/cmr-association-diff.git \
    && pip3 install git+https://github.com/podaac/cmr-umm-updater.git \
    # && pip3 install click --upgrade \
    && pip3 install git+https://github.com/podaac/l2ss-py.git \
    && pip3 install python-dateutil --upgrade \
    && apt-get clean

RUN adduser --quiet --disabled-password --shell /bin/sh --home /home/dockeruser --uid 300 dockeruser

USER dockeruser
WORKDIR "/home/dockeruser"

# Add artifactory as a trusted pip index
ENV HOME /home/dockeruser
ENV PYTHONPATH "${PYTHONPATH}:/home/dockeruser/.local/bin"
ENV PATH="/home/dockeruser/.local/bin:${PATH}"
    
CMD ["sh"]