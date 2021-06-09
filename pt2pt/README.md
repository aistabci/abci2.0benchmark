# Inter GPU Point-to-Point Communication Benchmark

Used benchmark software.

- p2pBandwidthLatencyTest (as a part of CUDA) for intra-node inter-gpu communication
- [OSU Micro-Benchmarks](https://mvapich.cse.ohio-state.edu/benchmarks/) for inter-node communication

Software versions.

| Software             | ComputeNode(V) | ComputeNode(A) |
| :------------------- | -------------: | -------------: |
| OS                   | CentOS 7.5     | RHEL 8.2       |
| gcc                  | 7.4.0          | 8.3.1          |
| CUDA                 | 11.2.2         | 11.2.2         |
| OpenMPI              | 4.0.5          | 4.0.5          |
| UCX                  | 1.7.0          | 1.9.0          |
| GDRCopy              | 2.0            | 2.1            |
| OSU Micro-Benchmarks | 5.7            | 5.7            |


## Build

### Intra-Node Inter-GPU Communication

Procedures for building p2pBandwidthLatencyTest for ComputeNode(A).

```Console
es1 $ qrsh -g GROUP -l rt_AG.small=1
a0001 $ cd programs
a0001 $ module load cuda/11.2/11.2.2
a0001 $ cp -r $CUDA_HOME/samples cuda-samples-anode
a0001 $ cd cuda-samples-anode/1_Utilities/p2pBandwidthLatencyTest
a0001 $ make
```

Procedures for building p2pBandwidthLatencyTest for ComputeNode(V).

```Console
es1 $ qrsh -g GROUP -l rt_G.small=1
g0001 $ cd programs
g0001 $ module load cuda/11.2/11.2.2
g0001 $ cp -r $CUDA_HOME/samples cuda-samples-vnode
g0001 $ cd cuda-samples-vnode/1_Utilities/p2pBandwidthLatencyTest
g0001 $ make
```

### Inter-Node Communication

Procedures for building OSU Micro-Benchmarks for ComputeNode(A).

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

Procedures for building OSU Micro-Benchmarks for ComputeNode(V).

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

### Run

Go into each benchmark directory, like `inter_anode`, and submit a job script in the directory.

```Console
es1 $ cd pt2pt
es1 $ cd inter_anode
es1 $ qsub -g GROUP job01.sh
```


## Benchmark Results

See `summary_inter.ipynb` and `summary_intra.ipynb`.
