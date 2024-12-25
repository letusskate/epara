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


## 自己安装cuda和cudnn

# 使用官方的Ubuntu镜像
FROM ubuntu:20.04

# 设置工作目录
WORKDIR /workspace

# 禁用交互式前端
ENV DEBIAN_FRONTEND=noninteractive

# 更新包列表并安装必要的软件包
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    curl \
    bzip2 \
    ca-certificates \
    gnupg \
    lsb-release && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 添加NVIDIA包存储库
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
    mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-ubuntu2004-11-8-local_11.8.0-1_amd64.deb && \
    dpkg -i cuda-repo-ubuntu2004-11-8-local_11.8.0-1_amd64.deb && \
    apt-key add /var/cuda-repo-ubuntu2004-11-8-local/7fa2af80.pub && \
    apt-get update && \
    apt-get -y install cuda

# 设置CUDA环境变量
ENV PATH /usr/local/cuda-11.8/bin${PATH:+:${PATH}}
ENV LD_LIBRARY_PATH /usr/local/cuda-11.8/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# 下载并安装Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy

# 添加Conda到PATH环境变量
ENV PATH /opt/conda/bin:$PATH

# 创建并激活conda虚拟环境，然后安装PyTorch
RUN conda create -y --name pytorch_env python=3.8 && \
    echo "conda activate pytorch_env" >> ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc && conda activate pytorch_env && \
    conda install -y pytorch torchvision torchaudio cudatoolkit=11.8 -c pytorch -c nvidia && \
    conda clean -tipsy"

# 设置Conda初始化
RUN conda init bash

# 复制当前目录内容到容器中
COPY . .

# 启动时运行bash
CMD ["/bin/bash"]