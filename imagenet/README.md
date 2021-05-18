# Benchmark of Training ResNet50 using ImageNet

| Software             | Version   |
| :------------------- | --------: |
| Singularity Pro      | 3.7       |
| NVIDIA PyTorch Image | 21.04-py3 |

Reference

- [NVIDIA PyTorch Image](https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel_21-04.html#rel_21-04)


## Prepare The Container Image

Download PyTorch container image from NGC Container Registry.

```Console
es1 $ cd programs
es1 $ module load singularitypro/3.7
es1 $ singularity pull docker://nvcr.io/nvidia/pytorch:21.04-py3
es1 $ ls -1
...
pytorch_21.04-py3.sif
...
```


## Prepare Benchmark Data

Use the ImageNet data sets already stored in ABCI public directory.

Procedure for data preparation.

```Console
es1 $ cd imagenet/data
es1 $ mkdir imagenet
es1 $ cd imagenet
es1 $ bash ../prepare_train.sh      (It takes long time)
es1 $ bash ../prepare_val.sh
es1 $ cd ..
es1 $ tar cf imagenet.tar imagenet  (It takes long time)
```

Reference

- [How to train CNNs on ImageNet](https://towardsdatascience.com/how-to-train-cnns-on-imagenet-ab8dd48202a9)


## Run Benchmarks

Go into each benchmark directory, like `a100x1`, and submit a job script in the directory.

```Console
es1 $ cd imagenet
es1 $ cd a100x1
es1 $ qsub -g GROUP a100x1.sh
```


## Benchmark Results

### ComputeNode(A) TF32 vs ComputeNode(V) FP32

The unit is images per second.

| Hardware        | GPU x Count  | Performance |
| :-------------- | -----------: | ----------: |
| ComputeNode(A)  | A100 x 1     | 771.79      |
| ComputeNode(A)  | A100 x 4     | 3160.13     |
| ComputeNode(A)  | A100 x 8     | 6102.28     |
| ComputeNode(V)  | V100 x 1     | 367.07      |
| ComputeNode(V)  | V100 x 4     | 1446.99     |


### ComputeNode(A) vs ComputeNode(V) using PyTorch AMP

The unit is images per second.

| Hardware        | GPU x Count  | Performance |
| :-------------- | -----------: | ----------: |
| ComputeNode(A)  | A100 x 1     | 1251.82     |
| ComputeNode(A)  | A100 x 4     | 4638.79     |
| ComputeNode(A)  | A100 x 8     | 8856.24     |
| ComputeNode(V)  | V100 x 1     | 804.69      |
| ComputeNode(V)  | V100 x 4     | 3243.58     |
