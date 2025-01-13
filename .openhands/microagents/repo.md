Repository: MixEval
Description: MixEval is an approach that bridges the gap between real-world user queries and efficient, reproducible evaluation by leveraging user queries mined from the web and matching them with similar queries from existing benchmarks. MixEval is also the proposed benchmark built with this approach.

Directory Structure:
- mix_eval/: models and datasets
- docs/: Documentation

Setup:
- Run 
```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b
~/miniconda3/bin/conda init
source ~/.bashrc
conda --version
```
to install miniconda
then 
- Run
```
conda create -n MixEval python=3.11 --yes
conda activate MixEval
bash setup.sh
```
to install dependencies
Setup the Azure OpenAI API key for model parser. Create .env file under root dir (MixEval/) and add the below line to it:
```
OPENAI_API_TYPE=azure
OPENAI_API_KEY=kPPNwc8BAytKQJ7qkj4JC02QaDP4kGF3
OPENAI_API_BASE=https://search.bytedance.net/gpt/openapi/online/v2/crawl
OPENAI_API_VERSION=2024-03-01-preview
```

I want to evaluate models that are not included in mixeval.models.__init__, see here for the simple steps of new model registration：
```
Step1: Add your model file to `mixeval/models/` with name `gpt-4o-2024-05-13.py` and write the model class in it with the name `Model_Class_Name`. 
- Proprietary models are inherited from `mixeval.models.base_api.APIModelBase` (example file: `gpt_4_turbo_2024_04_09.py`, add your api key in `.env`). 
- In most cases, all you need to do is write a simple model class with a single `__init__` function. However, if your model needs more setup, e.g., it requires a different build_model() function, you should override the corresponding function or variable of the parent model.
- The model file name should be the same with the name you pass to the `@register_model()` decorator on top of the model class.

Step2: Add your model to `mixeval.models.__init__.AVAILABLE_MODELS`. 
- The entry you add should be in the form of `gpt-4o-2024-05-13: GPT_4o_0513`. See other models in `AVAILABLE_MODELS` as a reference.
```

The content in `gpt-4o-2024-05-13.py`may be as follows:

```
import os
from dotenv import load_dotenv

from openai import OpenAI,AzureOpenAI
from httpx import Timeout

from mix_eval.models.base_api import APIModelBase
from mix_eval.api.registry import register_model

@register_model("gpt-4o-2024-05-13")
class GPT_4o_0513(APIModelBase):
    def __init__(self, args):
        super().__init__(args)
        self.args = args
        self.model_name = 'gpt-4o-2024-05-13'
        
        load_dotenv()
        self.client = AzureOpenAI(
        azure_endpoint="https://search.bytedance.net/gpt/openapi/online/v2/crawl",
        api_version="2024-03-01-preview",
        api_key="kPPNwc8BAytKQJ7qkj4JC02QaDP4kGF3",
    )

```


Run evaluation and get results. 
```
python -m mix_eval.evaluate \
    --model_name gpt-4o-2024-05-13 \
    --benchmark mixeval_hard \
    --version 2024-06-01 \
    --batch_size 20 \
    --max_gpu_memory 5GiB \
    --output_dir mix_eval/data/model_responses/ \
    --api_parallel_num 20
```


Guidelines:
- Configure the environment first.
- Note that the file "gpt-4o-2024-05-13.py" needs to be added to "mixeval/models/", and "gpt-4o-2024-05-13: GPT_4o_0513" should be added to "mixeval.models.init.AVAILABLE_MODELS".
