# Inter GPU Broadcast Benchmark

Used benchmark software.

- [OSU Micro-Benchmarks](https://mvapich.cse.ohio-state.edu/benchmarks/) for MPI Bcast
- [NCCL Tests](https://github.com/NVIDIA/nccl-tests) for NCCL Bcast

Software versions.

| Software             | ComputeNode(V) | ComputeNode(A) |
| :------------------- | -------------: | -------------: |
| OS                   | CentOS 7.5     | RHEL 8.2       |
| gcc                  | 7.4.0          | 8.3.1          |
| CUDA                 | 11.2.2         | 11.2.2         |
| OpenMPI              | 4.0.5          | 4.0.5          |
| UCX                  | 1.7.0          | 1.9.0          |
| GDRCopy              | 2.0            | 2.1            |
| NCCL                 | 2.8.4-1        | 2.8.4-1        |
| OSU Micro-Benchmarks | 5.7            | 5.7            |
| NCCL Tests           | Commit:0b30de5 | Commit:0b30de5 |


## Build

### ComputeNode(A)

OSU Micro-Benchmarks

```Console
es1$ qrsh -g GROUP -l rt_AG.small=1
a0001$ cd programs
a0001$ module load cuda/11.2/11.2.2
a0001$ module load openmpi/4.0.5
a0001$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.7.tar.gz
a0001$ export INSTALL_DIR=`pwd`/omb-5.7-anode
a0001$ tar zxf osu-micro-benchmarks-5.7.tar.gz
a0001$ cd osu-micro-benchmarks-5.7
a0001$ CC=mpicc ./configure --prefix=$INSTALL_DIR --enable-cuda
a0001$ make; make install
a0001$ cd ..
a0001$ rm -fr osu-micro-benchmarks-5.7
```

NCCL Tests

```Console
es1$ qrsh -g GROUP -l rt_AG.small=1
a0001$ cd programs
a0001$ module load openmpi/4.0.5
a0001$ module load cuda/11.2/11.2.2
a0001$ module load nccl/2.8/2.8.4-1
a0001$ git clone git@github.com:NVIDIA/nccl-tests.git nccl-tests-anode
a0001$ cd nccl-tests-anode
a0001$ make MPI=1 MPI_HOME=$OMPI_HOME CUDA_HOME=$CUDA_HOME NCCL_HOME=$NCCL_HOME
```

### ComputeNode(V)

OSU Micro-Benchmarks

```Console
es1$ qrsh -g GROUP -l rt_G.small=1
g0001$ cd programs
g0001$ module load cuda/11.2/11.2.2
g0001$ module load gcc/7.4.0
g0001$ module load openmpi/4.0.5
g0001$ wget http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.7.tar.gz
g0001$ export INSTALL_DIR=`pwd`/omb-5.7-vnode
g0001$ tar zxf osu-micro-benchmarks-5.7.tar.gz
g0001$ cd osu-micro-benchmarks-5.7
g0001$ CC=mpicc ./configure --prefix=$INSTALL_DIR --enable-cuda
g0001$ make; make install
g0001$ cd ..
g0001$ rm -fr osu-micro-benchmarks-5.7
```

NCCL Tests

```Console
es1$ qrsh -g GROUP -l rt_G.small=1
g0001$ cd programs
g0001$ module load openmpi/4.0.5
g0001$ module load cuda/11.2/11.2.2
g0001$ module load nccl/2.8/2.8.4-1
g0001$ git clone git@github.com:NVIDIA/nccl-tests.git nccl-tests-vnode
g0001$ cd nccl-tests-vnode
g0001$ make MPI=1 MPI_HOME=$OMPI_HOME CUDA_HOME=$CUDA_HOME NCCL_HOME=$NCCL_HOME
```


## Run

Go into each benchmark directory, like `intra_anode`, and submit a job script in the directory.

```Console
es1 $ cd bcast
es1 $ cd intra_anode
es1 $ qsub -g GROUP job.sh
```


## Benchmark Results
