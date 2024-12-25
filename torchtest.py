import torch

print("PyTorch version:", torch.__version__)

if torch.cuda.is_available():
    print("CUDA is available. Using GPU")
else:
    print("CUDA is not available. Using CPU")

import torchvision

print("Torchvision version:", torchvision.__version__)
