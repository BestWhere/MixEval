#!/bin/bash

pip install torch==2.5.0 torchvision==0.20.0 torchaudio==2.5.0 --index-url https://download.pytorch.org/whl/cpu
pip install -e .
# pip install flash-attn==2.5.8 --no-build-isolation