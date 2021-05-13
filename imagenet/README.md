# Benchmark of Training ResNet50 using ImageNet

| Software             | Version   |
| -------------------- | --------- |
| Singularity Pro      | 3.7       |
| NVIDIA PyTorch Image | 21.04-py3 |


## Prepare The Container Image

Download PyTorch container image from NGC Container Registry.

```Console
es1 $ cd imagenet
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

Go into each benchmark directory, like `a100x1_lustre`, and submit a job script in the directory.
When submitting a benchmark that uses data on Lustre (suffix of the benchmark directory is `_lustre`), you should not submit other ImageNet benchmarks to avoid IO contantion.

```Console
es1 $ cd imagenet
es1 $ cd a100x1_lustre
es1 $ qsub -g GROUP a100x1_lustre.sh
```

