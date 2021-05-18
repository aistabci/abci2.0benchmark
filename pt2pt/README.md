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
| 0        |           2.12 |           1.29 |
| 1        |           3.28 |           2.70 |
| 2        |           3.28 |           2.40 |
| 4        |           3.28 |           2.39 |
| 8        |           3.32 |           2.39 |
| 16       |           3.29 |           2.39 |
| 32       |           3.32 |           2.45 |
| 64       |           3.45 |           2.56 |
| 128      |           3.48 |           2.58 |
| 256      |           3.46 |           2.64 |
| 512      |           3.52 |           2.78 |
| 1024     |           3.61 |           3.01 |
| 2048     |           3.85 |           4.00 |
| 4096     |           4.35 |           6.12 |
| 8192     |           4.88 |          10.62 |
| 16384    |           7.61 |          18.28 |
| 32768    |           8.22 |          30.91 |
| 65536    |          10.51 |          57.52 |
| 131072   |          14.54 |         117.47 |
| 262144   |          23.48 |          62.62 |
| 524288   |          40.32 |          89.06 |
| 1048576  |          74.01 |         140.67 |
| 2097152  |         143.54 |         242.33 |
| 4194304  |         280.31 |         450.36 |

#### 1 GPU to 1 GPU bandwidth

The unit is MB/s.

| Size (B) | ComputeNode(A) | ComputeNode(V) |
| :------- | -------------: | -------------: |
| 1        |           3.07 |           2.68 |
| 2        |           6.14 |           5.32 |
| 4        |          12.36 |          10.01 |
| 8        |          18.23 |          21.71 |
| 16       |          49.23 |          43.83 |
| 32       |          99.09 |          86.24 |
| 64       |         163.37 |         164.60 |
| 128      |         376.63 |         306.09 |
| 256      |         703.42 |         604.50 |
| 512      |        1327.11 |         938.78 |
| 1024     |        2431.58 |        1164.97 |
| 2048     |        4206.96 |        1211.98 |
| 4096     |        6269.98 |        1228.30 |
| 8192     |        8632.70 |        1252.48 |
| 16384    |        7574.39 |        1246.74 |
| 32768    |       12952.15 |        7406.31 |
| 65536    |       13056.33 |        9211.76 |
| 131072   |       14345.70 |        9735.75 |
| 262144   |       15120.39 |        9925.60 |
| 524288   |       15086.11 |       10095.31 |
| 1048576  |       15326.79 |       10170.76 |
| 2097152  |       15385.02 |       10180.52 |
| 4194304  |       15357.18 |       10226.11 |

#### 4 GPU to 4 GPU latency

The unit is micro-second.

| Size (B) | ComputeNode(A) | ComputeNode(V) |
| :------- | -------------: | -------------: |
| 0        |           2.20 |           1.41 |
| 1        |           3.47 |           2.57 |
| 2        |           3.30 |           2.48 |
| 4        |           3.31 |           2.49 |
| 8        |           3.31 |           2.49 |
| 16       |           3.37 |           2.50 |
| 32       |           3.53 |           2.62 |
| 64       |           3.62 |           2.69 |
| 128      |           3.63 |           2.82 |
| 256      |           3.71 |           2.91 |
| 512      |           3.71 |           2.96 |
| 1024     |           3.84 |           3.23 |
| 2048     |           4.08 |           4.18 |
| 4096     |           4.54 |           6.34 |
| 8192     |           5.05 |          15.81 |
| 16384    |           9.15 |          21.15 |
| 32768    |          12.11 |          32.40 |
| 65536    |          15.92 |          60.03 |
| 131072   |          25.22 |         120.74 |
| 262144   |          42.15 |          94.81 |
| 524288   |          88.21 |         149.72 |
| 1048576  |         181.46 |         245.85 |
| 2097152  |         374.79 |         401.26 |
| 4194304  |         761.71 |         868.20 |

#### 4 GPU to 4 GPU bandwidth

The unit is MB/s.

| Size (B) | ComputeNode(A) | ComputeNode(V) |
| :------- | -------------: | -------------: |
| 1        |          10.96 |           9.73 |
| 2        |          22.01 |          19.83 |
| 4        |          44.12 |          39.75 |
| 8        |          88.28 |          78.95 |
| 16       |         176.04 |         157.64 |
| 32       |         350.83 |         294.88 |
| 64       |         594.67 |         585.88 |
| 128      |        1333.39 |        1162.88 |
| 256      |        2526.57 |        2131.96 |
| 512      |        4776.62 |        2532.06 |
| 1024     |        8854.53 |        2596.71 |
| 2048     |       14874.82 |        2582.48 |
| 4096     |       17640.13 |        2548.78 |
| 8192     |       19479.06 |        2551.13 |
| 16384    |       20047.74 |        2565.37 |
| 32768    |       19977.52 |       18731.75 |
| 65536    |       29358.39 |       19958.41 |
| 131072   |       29633.32 |       19825.17 |
| 262144   |       29650.12 |       20042.85 |
| 524288   |       29663.44 |       20278.57 |
| 1048576  |       29724.74 |       20392.52 |
| 2097152  |       29725.96 |       20467.20 |
| 4194304  |       29726.59 |       20482.46 |

#### 8 GPU to 8 GPU latency

The unit is micro-second.

| Size (B) | ComputeNode(A) |
| :------- | -------------: |
| 0        |           2.12 |
| 1        |           3.93 |
| 2        |           3.30 |
| 4        |           3.29 |
| 8        |           3.26 |
| 16       |           3.27 |
| 32       |           3.91 |
| 64       |           4.06 |
| 128      |           4.18 |
| 256      |           4.19 |
| 512      |           4.13 |
| 1024     |           4.37 |
| 2048     |           4.39 |
| 4096     |           4.93 |
| 8192     |           5.62 |
| 16384    |          14.39 |
| 32768    |          16.87 |
| 65536    |          29.48 |
| 131072   |          34.29 |
| 262144   |          54.54 |
| 524288   |          95.25 |
| 1048576  |         180.11 |
| 2097152  |         356.59 |
| 4194304  |         707.07 |

#### 8 GPU to 8 GPU bandwidth

The unit is MB/s.

| Size (B) | ComputeNode(A) |
| :------- | -------------: |
| 1        |          22.63 |
| 2        |          47.36 |
| 4        |          95.16 |
| 8        |         189.81 |
| 16       |         379.70 |
| 32       |         757.49 |
| 64       |        1296.08 |
| 128      |        2843.54 |
| 256      |        5463.39 |
| 512      |       10262.46 |
| 1024     |       17580.16 |
| 2048     |       19733.57 |
| 4096     |       19815.39 |
| 8192     |       20199.18 |
| 16384    |       20348.82 |
| 32768    |       38568.70 |
| 65536    |       38790.34 |
| 131072   |       38973.07 |
| 262144   |       38967.40 |
| 524288   |       39006.25 |
| 1048576  |       38964.62 |
| 2097152  |       39108.52 |
| 4194304  |       39055.35 |
