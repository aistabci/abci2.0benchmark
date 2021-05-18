# Inter GPU Point-to-Point Communication Benchmark

Use benchmark software.

- p2pBandwidthLatencyTest (as a part of CUDA) for intra-node inter-gpu communication
- [OSU Micro-Benchmarks](https://mvapich.cse.ohio-state.edu/benchmarks/) for inter-node communication

Software versions.

| Software  | ComputeNode(V) | ComputeNode(A) |
| :-------- | -------------: | -------------: |
| OS        | CentOS 7.5     | RHEL 8.2       |
| gcc       | 7.4.0          | 8.3.1          |
| CUDA      | 11.2.2         | 11.2.2         |
| OpenMPI   | 4.0.5          | 4.0.5          |
| UCX       | 1.7.0          | 1.9.0          |
| GDRCopy   | 2.0            | 2.1            |


## Build and Run

### Intra-Node Inter-GPU Communication

Procedures for building and running p2pBandwidthLatencyTest.

#### ComputeNode(A)

```Console
es1 $ qrsh -g GROUP -l rt_AF=1
a0001 $ cd pt2pt/intra_anode
a0001 $ module load cuda/11.2/11.2.2
a0001 $ cp -r $CUDA_HOME/samples .
a0001 $ (cd samples/1_Utilities/p2pBandwidthLatencyTest; make)
a0001 $ hostname > intra_anode.out
a0001 $ ./samples/bin/x86_64/linux/release/p2pBandwidthLatencyTest >> intra_anode.out
a0001 $ rm -fr samples
```

Check scores under `Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)` and `P2P=Enabled Latency (P2P Writes) Matrix (us)` sections of `intra_anode.out` file.

#### ComputeNode(V)

```Console
es1 $ qrsh -g GROUP -l rt_F=1
g0001 $ cd pt2pt/intra_vnode
g0001 $ module load cuda/11.2/11.2.2
g0001 $ cp -r $CUDA_HOME/samples .
g0001 $ (cd samples/1_Utilities/p2pBandwidthLatencyTest; make)
g0001 $ hostname > intra_vnode.out
g0001 $ ./samples/bin/x86_64/linux/release/p2pBandwidthLatencyTest >> intra_vnode.out
g0001 $ rm -fr samples
```

Check scores under `Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)` and `P2P=Enabled Latency (P2P Writes) Matrix (us)` sections of `intra_vnode.out` file.

### Inter-Node Communication

#### Build

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

#### Run

Go into each benchmark directory, like `inter_anode`, and submit a job script in the directory.

```Console
es1 $ cd pt2pt
es1 $ cd inter_anode
es1 $ qsub -g GROUP inter_anode_1gpu.sh
```


## Benchmark Results

### Intra-Node Inter-GPU Communication

#### Bandwidth

ComputeNode(A)

```
Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)
   D\D     0      1      2      3      4      5      6      7
     0 1291.86 410.10 410.71 411.04 412.22 411.46 412.88 412.15
     1 409.42 1290.79 410.06 410.09 409.95 410.27 409.20 410.26
     2 411.56 410.20 1291.86 413.19 416.39 416.06 414.96 415.76
     3 410.82 411.42 413.32 1290.79 412.80 413.97 413.46 412.66
     4 413.62 411.72 417.62 414.97 1309.72 519.05 519.66 519.74
     5 413.41 412.65 417.95 415.07 517.17 1303.71 518.19 518.02
     6 414.22 411.21 417.06 415.12 517.16 515.45 1302.08 517.84
     7 414.64 411.80 417.10 414.88 518.54 518.24 521.56 1305.89
```

ComputeNode(V)

```
Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)
   D\D     0      1      2      3
     0 779.50  96.90  96.90  96.90
     1  96.85 780.66  96.91  96.91
     2  96.91  96.85 779.50  96.91
     3  96.90  96.90  96.91 779.11
```

#### Latency

ComputeNode(A)

```
P2P=Enabled Latency (P2P Writes) Matrix (us)
   GPU     0      1      2      3      4      5      6      7
     0   3.13   3.36   3.32   3.32   3.32   3.25   3.29   3.24
     1   3.28   2.96   3.32   3.21   3.25   3.25   3.22   3.26
     2   3.30   3.24   3.14   3.25   3.27   3.25   3.24   3.26
     3   3.31   3.26   3.21   3.18   3.24   3.20   3.25   3.26
     4   2.81   2.87   2.81   2.88   2.39   2.81   2.83   2.90
     5   2.81   2.86   2.80   2.81   2.80   2.28   3.05   3.40
     6   2.80   2.81   2.80   2.86   2.80   2.91   2.49   2.86
     7   2.80   2.91   2.83   2.82   2.87   2.88   2.80   2.30
```

ComputeNode(V)

```
P2P=Enabled Latency (P2P Writes) Matrix (us)
   GPU     0      1      2      3
     0   1.81   1.87   1.90   1.90
     1   1.86   1.65   1.86   1.85
     2   1.94   1.95   1.65   1.95
     3   2.00   2.00   2.00   1.68
```

### Inter-Node Communication

#### 1 GPU to 1 GPU latency

The unit is micro-second.

| Size (B) | ComputeNode(A) | ComputeNode(V) |
| :------- | -------------: | -------------: |
| 0        |           2.13 |           1.29 |
| 1        |           3.35 |           2.55 |
| 2        |           3.30 |           2.39 |
| 4        |           3.29 |           2.38 |
| 8        |           3.33 |           2.39 |
| 16       |           3.31 |           2.39 |
| 32       |           3.34 |           2.44 |
| 64       |           3.45 |           2.54 |
| 128      |           3.52 |           2.57 |
| 256      |           3.48 |           2.62 |
| 512      |           3.53 |           2.79 |
| 1024     |           3.62 |           2.96 |
| 2048     |           3.85 |           4.00 |
| 4096     |           4.35 |           6.12 |
| 8192     |           4.89 |          10.62 |
| 16384    |           7.66 |          18.26 |
| 32768    |           8.39 |          30.89 |
| 65536    |          10.68 |          57.40 |
| 131072   |          14.89 |         116.78 |
| 262144   |          23.73 |          62.59 |
| 524288   |          40.69 |          89.07 |
| 1048576  |          75.22 |         140.78 |
| 2097152  |         143.99 |         242.55 |
| 4194304  |         281.31 |         450.21 |
| 8388608  |         559.02 |              - |

#### 1 GPU to 1 GPU bandwidth

The unit is MB/s.

| Size (B) | ComputeNode(A) | ComputeNode(V) |
| :------- | -------------: | -------------: |
| 1        |           3.01 |           2.60 |
| 2        |           6.09 |           5.23 |
| 4        |          12.23 |          10.74 |
| 8        |          24.38 |          21.38 |
| 16       |          48.89 |          42.71 |
| 32       |          97.53 |          84.68 |
| 64       |         162.95 |         161.08 |
| 128      |         379.37 |         318.69 |
| 256      |         718.01 |         625.57 |
| 512      |        1320.07 |         996.42 |
| 1024     |        2441.35 |        1129.36 |
| 2048     |        4232.79 |        1226.78 |
| 4096     |        6753.90 |        1228.63 |
| 8192     |        8591.76 |        1251.46 |
| 16384    |        9196.55 |        1246.80 |
| 32768    |       12871.91 |        7442.19 |
| 65536    |       14091.96 |        9211.93 |
| 131072   |       14371.86 |        9747.91 |
| 262144   |       14362.33 |        9925.02 |
| 524288   |       15296.54 |       10093.68 |
| 1048576  |       15232.23 |       10170.65 |
| 2097152  |       15324.38 |       10205.19 |
| 4194304  |       15387.73 |       10216.91 |
| 8388608  |       15366.87 |              - |

#### 4 GPU to 4 GPU latency

#### 4 GPU to 4 GPU bandwidth

#### 8 GPU to 8 GPU latency

#### 8 GPU to 8 GPU bandwidth
