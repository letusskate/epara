## 官方镜像附带cuda和cudnn

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


# ## 自己安装cuda和cudnn

# # 使用官方的Ubuntu镜像
# FROM ubuntu:20.04

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
#     gnupg \
#     lsb-release && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# # 添加NVIDIA包存储库
# RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
#     mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
#     wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-ubuntu2004-11-8-local_11.8.0-1_amd64.deb && \
#     dpkg -i cuda-repo-ubuntu2004-11-8-local_11.8.0-1_amd64.deb && \
#     apt-key add /var/cuda-repo-ubuntu2004-11-8-local/7fa2af80.pub && \
#     apt-get update && \
#     apt-get -y install cuda

# # 设置CUDA环境变量
# ENV PATH /usr/local/cuda-11.8/bin${PATH:+:${PATH}}
# ENV LD_LIBRARY_PATH /usr/local/cuda-11.8/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

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

### 官方镜像附带cuda和cudnn的特定版本
FROM nvidia/cuda:10.1-devel-ubuntu18.04

ARG https_proxy
ARG http_proxy

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        tzdata \
        ca-certificates \
        git \
        curl \
        wget \
        vim \
        cmake \
        lsb-release \
        libcudnn7=7.6.0.64-1+cuda10.1 \
        libnuma-dev \
        ibverbs-providers \
        librdmacm-dev \
        ibverbs-utils \
        rdmacm-utils \
        libibverbs-dev \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        libnccl2=2.4.7-1+cuda10.1 \
        libnccl-dev=2.4.7-1+cuda10.1 \
        iputils-ping \
        net-tools \
        perftest 

RUN apt-get install -y --no-install-recommends openssh-client openssh-server && \
    mkdir -p /var/run/sshd

RUN apt-get install -y --no-install-recommends libboost-all-dev=1.65.1.0ubuntu1

RUN cd /usr/local && \
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ./miniconda.sh && \
    bash miniconda.sh -b -p /usr/local/conda && \
    rm miniconda.sh
ENV PATH $PATH:/usr/local/conda/bin

RUN conda install -y -c conda-forge -c defaults -c pytorch magma-cuda101 mkl mkl-include ninja numpy=1.20.1 pyyaml scipy setuptools six=1.15.0 cffi typing_extensions future requests dataclasses
