ARG EPARA_BASE_PATH=/workspace
ARG EPARA_PATH=$EPARA_BASE_PATH/epara
ARG EPARA_GIT_LINK=https://github.com/letusskate/epara.git
ARG EPARA_GIT_BRANCH=master

###########################################
## 官方镜像附带cuda和cudnn(装不了基础镜像)

# # 基础镜像，选择带有CUDA 11.8和cuDNN 8的Ubuntu 20.04镜像
# FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu20.04

# # 设置工作目录
# WORKDIR /workspace

# # 禁用交互式前端
# ENV DEBIAN_FRONTEND=noninteractive

# # 更新包列表并安装必要的软件包
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#     wget \
#     curl \
#     bzip2 \
#     ca-certificates \
#     libglib2.0-0 \
#     libxext6 \
#     libsm6 \
#     libxrender1 \
#     git && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# # 下载并安装Miniconda
# RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
#     /bin/bash /tmp/miniconda.sh -b -p /opt/conda && \
#     rm /tmp/miniconda.sh && \
#     /opt/conda/bin/conda clean -tipsy

# # 添加Conda到PATH环境变量
# ENV PATH /opt/conda/bin:$PATH

# # 创建并激活conda虚拟环境，然后安装PyTorch
# RUN conda create -y --name pytorch_env python=3.8 && \
#     echo "conda activate pytorch_env" >> ~/.bashrc && \
#     /bin/bash -c "source ~/.bashrc && conda activate pytorch_env && \
#     conda install -y pytorch torchvision torchaudio cudatoolkit=11.8 -c pytorch -c nvidia && \
#     conda clean -tipsy"

# # 设置Conda初始化
# RUN conda init bash

# # 复制当前目录内容到容器中
# COPY . .

# # 启动时运行bash
# CMD ["/bin/bash"]

#####################################################
# ### 官方镜像附带cuda和cudnn的特定版本(装不了基础镜像)

# FROM nvidia/cuda:10.1-devel-ubuntu18.04

# ARG https_proxy
# ARG http_proxy

# ARG DEBIAN_FRONTEND=noninteractive
# RUN apt-get update
# RUN apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
#         build-essential \
#         tzdata \
#         ca-certificates \
#         git \
#         curl \
#         wget \
#         vim \
#         cmake \
#         lsb-release \
#         libcudnn7=7.6.0.64-1+cuda10.1 \
#         libnuma-dev \
#         ibverbs-providers \
#         librdmacm-dev \
#         ibverbs-utils \
#         rdmacm-utils \
#         libibverbs-dev \
#         python3 \
#         python3-dev \
#         python3-pip \
#         python3-setuptools \
#         libnccl2=2.4.7-1+cuda10.1 \
#         libnccl-dev=2.4.7-1+cuda10.1 \
#         iputils-ping \
#         net-tools \
#         perftest 

# RUN apt-get install -y --no-install-recommends openssh-client openssh-server && \
#     mkdir -p /var/run/sshd

# RUN apt-get install -y --no-install-recommends libboost-all-dev=1.65.1.0ubuntu1

# RUN cd /usr/local && \
#     wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ./miniconda.sh && \
#     bash miniconda.sh -b -p /usr/local/conda && \
#     rm miniconda.sh
# ENV PATH $PATH:/usr/local/conda/bin

# RUN conda install -y -c conda-forge -c defaults -c pytorch magma-cuda101 mkl mkl-include ninja numpy=1.20.1 pyyaml scipy setuptools six=1.15.0 cffi typing_extensions future requests dataclasses

############################################
### 自己安装cuda和cudnn（不能保证正确性）

# # 使用官方的Ubuntu镜像
# FROM ubuntu:20.04

# # 设置工作目录
# WORKDIR /workspace

# # 禁用交互式前端
# ENV DEBIAN_FRONTEND=noninteractive

# # Switch to bash shell for consistent conda init usage
# SHELL ["/bin/bash", "-c"]

# # 更新包列表并安装必要的软件包
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#     wget \
#     curl \
#     bzip2 \
#     ca-certificates \
#     gnupg \
#     lsb-release && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# # 添加NVIDIA包存储库
# RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
#     mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
#     wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb && \
#     dpkg -i cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb && \
#     cp /var/cuda-repo-ubuntu2004-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/ && \
#     apt-get update && \
#     apt-get -y install cuda

# # 设置CUDA环境变量
# ENV PATH /usr/local/cuda-11.8/bin${PATH:+:${PATH}}
# ENV LD_LIBRARY_PATH /usr/local/cuda-11.8/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# # 下载并安装Miniconda
# RUN cd /usr/local && \
#     wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ./miniconda.sh && \
#     bash miniconda.sh -b -p /usr/local/conda && \
#     rm miniconda.sh

# # 添加Conda到PATH环境变量
# ENV PATH /usr/local/conda/bin:$PATH

# # 配置 Conda 使用国内的镜像源，这里使用的是清华大学的镜像源
# RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
#     conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
#     conda config --set show_channel_urls yes

# # 设置Conda初始化
# RUN conda init bash &&\
#     echo "source ~/.bashrc" >> ~/.bash_profile && \
#     source ~/.bashrc

# # 创建并激活conda虚拟环境，然后安装PyTorch
# RUN conda create -y --name pytorch_env python=3.8

# # 安装pytorch
# RUN source activate pytorch_env && \
#     conda install -y pytorch torchvision torchaudio cudatoolkit=11.8 -c pytorch -c nvidia && \
#     conda clean -tipsy
# # 复制当前目录内容到容器中
# COPY . .

# # 启动时运行bash
# CMD ["/bin/bash"]

################################
### 本地安装（推荐）
# Dockerfile Example
#
# Before building this image, make sure to load your local tar file:
#   docker load -i ../cuda_1180_ubuntu2004_image.tar
# This will import an image into your local Docker environment.
# Adjust the FROM line below to match the loaded image name and tag.

# Replace 'cuda_1180_ubuntu2004_image:latest' with the actual
# repository:tag from the image you loaded
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

# Use bash shell in Docker for conda compatibility
SHELL ["/bin/bash", "-c"]


# Update and install prerequisites (if needed)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    git && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda in /usr/local/conda
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && /bin/bash /tmp/miniconda.sh -b -p /usr/local/conda \
    && rm -f /tmp/miniconda.sh \
    && /usr/local/conda/bin/conda clean --all -y

# Update PATH so conda is directly accessible
ENV PATH="/usr/local/conda/bin:${PATH}"

# Combine conda init, environment creation, and package installs in a single RUN
RUN conda init bash \
    && echo "source ~/.bashrc" >> ~/.bash_profile \
    && source ~/.bashrc 

RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ \
    && conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ \
    && conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/ \
    && conda config --set show_channel_urls yes \
    && conda create -y --name pytorch_env python=3.8 \
    # && conda activate pytorch_env \
    && source activate pytorch_env \
    && conda install -y pytorch torchvision torchaudio cudatoolkit=11.8 \
    && conda clean --all -y

# Set a default working directory
WORKDIR /workspace

# Default command to keep container in bash
CMD ["/bin/bash"]

# git clone
RUN cd $EPARA_BASE_PATH && git clone $EPARA_GIT_LINK

#############################
# ### mamba提高安装库的容错率
# # 基于你加载的本地 CUDA 镜像
# FROM cuda_1180_ubuntu2004_image:latest

# # 使用 bash 作为默认的 shell
# SHELL ["/bin/bash", "-c"]

# # 设置环境变量，避免交互式提示
# ENV DEBIAN_FRONTEND=noninteractive

# # 安装系统依赖
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     wget \
#     curl \
#     bzip2 \
#     ca-certificates \
#     libglib2.0-0 \
#     libxext6 \
#     libsm6 \
#     libxrender1 \
#     git \
#     && rm -rf /var/lib/apt/lists/*

# # 配置 Conda 使用清华镜像源并安装 Mamba
# RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
#     && /bin/bash /tmp/miniconda.sh -b -p /opt/conda \
#     && rm -f /tmp/miniconda.sh \
#     && /opt/conda/bin/conda clean --all -y \
#     && /opt/conda/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main \
#     && /opt/conda/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free \
#     && /opt/conda/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r \
#     && /opt/conda/bin/conda config --set show_channel_urls yes \
#     && /opt/conda/bin/conda install -y mamba -n base -c conda-forge

# # 更新 PATH 环境变量以使用 Conda 和 Mamba
# ENV PATH="/opt/conda/bin:${PATH}"

# # 初始化 Conda 并创建 Python 环境
# RUN conda init bash \
#     && echo "source ~/.bashrc" >> ~/.bash_profile \
#     && source ~/.bashrc \
#     && mamba create -y -n pytorch_env python=3.8 \
#     && mamba activate pytorch_env \
#     && mamba install -y pytorch torchvision torchaudio cudatoolkit=11.8 -c pytorch -c nvidia \
#     && conda clean --all -y

# # 设置工作目录
# WORKDIR /workspace

# # 默认启动 bash
# CMD ["/bin/bash"]