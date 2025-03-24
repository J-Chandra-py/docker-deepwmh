# Use a lightweight Python 3.9 base image
FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget unzip bc python3-pip \
    openssh-server rs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip, setuptools, and install wheel
RUN python3 -m pip install -U pip
RUN python3 -m pip install -U setuptools
RUN python3 -m pip install wheel

# Download and install ANTs (Advanced Normalization Tools)
RUN wget https://github.com/ANTsX/ANTs/releases/download/v2.5.4/ants-2.5.4-ubuntu-22.04-X64-gcc.zip && \
    unzip ants-2.5.4-ubuntu-22.04-X64-gcc.zip -d /opt && \
    rm ants-2.5.4-ubuntu-22.04-X64-gcc.zip
ENV PATH="$PATH:/opt/ants-2.5.4/bin"
ENV ANTS_RANDOM_SEED=0

# Install PyTorch (must be <2.6) and related libraries (compatible with CUDA 11.8)
RUN python3 -m pip install torch==2.5.0 torchvision==0.20.0 torchaudio==2.5.0 --index-url https://download.pytorch.org/whl/cu118

# Copy and run the installation script for required services
COPY ./install_services.sh /install_services.sh
COPY verify_install.sh /verify_install.sh
RUN /install_services.sh

# Set the ROBEX directory environment variable
ENV ROBEX_DIR="/opt/ROBEX"

# Copy and install the DeepWMH model
RUN mkdir model
COPY ./model_v1.0.tar.gz /model/model_v1.0.tar.gz
RUN DeepWMH_install -m /model/model_v1.0.tar.gz -o /model/ -f

# Set the default entrypoint to DeepWMH_predict
ENTRYPOINT [ "DeepWMH_predict" ]
