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

A script for preparing training data.

```bash [prepare_train.sh]
mkdir train
cd train
tar xf /home/dataset/image-net/ILSVRC2012_img_train.tar
find . -name "*.tar" | while read NAME ; do mkdir -p "${NAME%.tar}"; tar -xvf "${NAME}" -C "${NAME%.tar}"; rm -f "${NAME}"; done
```

A script for preparing validation data.

```bash [prepare_val.sh]
mkdir val
cd val
tar xf /home/dataset/image-net/ILSVRC2012_img_val.tar
wget https://raw.githubusercontent.com/soumith/imagenetloader.torch/master/valprep.sh
bash valprep.sh
rm valprep.sh
```

Procedure for data preparation.

```Console
es1 $ cd imagenet
es1 $ mkdir -p data/imagenet
es1 $ cd data/imagenet
es1 $ vi prepare_train.sh           (The above script)
es1 $ bash ./prepare_train.sh       (It takes long time)
es1 $ vi prepare_val.sh             (The above script)
es1 $ bash ./prepare_val.sh
es1 $ cd ..
es1 $ tar cf imagenet.tar imagenet  (It takes long time)
```

Reference

- [How to train CNNs on ImageNet](https://towardsdatascience.com/how-to-train-cnns-on-imagenet-ab8dd48202a9)


## Run Benchmarks

Go into each benchmark directory, like `a100x1_lustre`, and submit a job script in the directory.
When submitting a benchmark that uses data on Lustre (suffix of the benchmark is `_lustre`), you should not submit other ImageNet benchmarks to avoid IO contantion.

```Console
es1 $ cd imagenet
es1 $ cd a100x1_lustre
es1 $ qsub -g GROUP a100x1_lustre.sh
```

