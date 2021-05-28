# Benchmark of Training ResNet50 using ImageNet

| Software                | Version       |
| :---------------------- | ------------: |
| Singularity Pro         | 3.7           |
| NVIDIA PyTorch Image    | 21.04-py3     |
| NVIDIA TensorFlow Image | 21.04-tf2-py3 |
| Horovod                 | 0.22.0        |

Reference

- [NVIDIA PyTorch Image](https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel_21-04.html#rel_21-04)


## Prepare The Container Image

Download PyTorch and TensorFlow container images from NGC Container Registry.

```Console
es1 $ cd programs
es1 $ module load singularitypro/3.7
es1 $ singularity pull docker://nvcr.io/nvidia/pytorch:21.04-py3
es1 $ singularity pull docker://nvcr.io/nvidia/tensorflow:21.04-tf2-py3
es1 $ ls -1
...
pytorch_21.04-py3.sif
tensorflow_21.04-tf2-py3.sif
...
```

Build a Horovod + PyTorch container image using a container definition file.

```Console
es1 $ cd programs
es1 $ module load singularitypro/3.7
es1 $ singularity build --fakeroot pytorch+horovod.sif ../imagenet/pytorch+horovod.def
es1 $ ls -1
...
pytorch+horovod.sif
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

Go into each benchmark directory, like `anode_single`, and submit job scripts in the directory.
Do not submit multiple jobs under the directories because these job scripts generate files with the same names, like `GPU_1.log`.

```Console
es1 $ cd imagenet
es1 $ cd anode_single
es1 $ qsub -g GROUP job_gpu1.sh
```


## Benchmark Results

See `summary_single.ipynb` and `summary_multi.ipynb`.
