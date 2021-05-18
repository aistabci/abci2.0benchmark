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

The results of `ComputeNode(A) Mem` and `ComputeNode(V) Mem` are host memory to host memory transfer.

| Size (B) | ComputeNode(A) | ComputeNode(V) | ComputeNode(A) Mem | ComputeNode(V) Mem |
| :------- | -------------: | -------------: | ------------------:| ------------------:|
| 0        |           2.12 |           1.27 |               1.48 |               0.88 |
| 1        |           3.32 |           2.67 |               1.48 |               0.88 |
| 2        |           3.28 |           2.37 |               1.47 |               0.87 |
| 4        |           3.28 |           2.36 |               1.47 |               0.86 |
| 8        |           3.28 |           2.37 |               1.47 |               0.86 |
| 16       |           3.28 |           2.37 |               1.47 |               0.88 |
| 32       |           3.32 |           2.41 |               1.50 |               0.91 |
| 64       |           3.45 |           2.53 |               1.57 |               1.03 |
| 128      |           3.43 |           2.56 |               1.61 |               1.06 |
| 256      |           3.51 |           2.61 |               1.80 |               1.56 |
| 512      |           3.51 |           2.71 |               1.86 |               1.65 |
| 1024     |           3.60 |           2.94 |               1.97 |               1.84 |
| 2048     |           3.85 |           4.06 |               2.78 |               2.20 |
| 4096     |           4.34 |           6.11 |               3.43 |               3.00 |
| 8192     |           4.84 |          10.59 |               4.24 |               4.15 |
| 16384    |           7.74 |          18.19 |               6.21 |               5.65 |
| 32768    |           8.32 |          30.79 |               7.51 |               7.05 |
| 65536    |          10.45 |          57.25 |               9.62 |              11.07 |
| 131072   |          14.56 |         116.58 |              13.29 |              17.63 |
| 262144   |          23.62 |          62.53 |              11.19 |              20.38 |
| 524288   |          40.21 |          88.77 |              17.22 |              31.89 |
| 1048576  |          74.36 |         139.90 |              28.73 |              53.89 |
| 2097152  |         143.87 |         242.35 |              50.62 |              96.81 |
| 4194304  |         280.51 |         450.49 |              97.40 |             183.60 |

#### 1 GPU to 1 GPU bandwidth

The unit is MB/s.

The results of `ComputeNode(A) Mem` and `ComputeNode(V) Mem` are host memory to host memory transfer.

| Size (B) | ComputeNode(A) | ComputeNode(V) | ComputeNode(A) Mem | ComputeNode(V) Mem |
| :------- | -------------: | -------------: | ------------------:| ------------------:|
| 1        |           3.08 |           1.74 |               5.47 |               5.59 |
| 2        |           6.15 |           3.15 |              10.98 |              11.12 |
| 4        |          12.14 |          10.62 |              21.98 |              22.23 |
| 8        |          24.70 |          22.03 |              43.30 |              44.21 |
| 16       |          49.43 |          43.45 |              87.51 |              91.04 |
| 32       |          98.68 |          85.41 |             175.31 |             181.31 |
| 64       |         158.77 |         167.38 |             342.55 |             323.49 |
| 128      |         370.75 |         317.19 |             647.16 |             640.14 |
| 256      |         707.31 |         604.42 |            1025.39 |            1110.22 |
| 512      |        1336.39 |        1006.47 |            1963.33 |            1949.37 |
| 1024     |        2460.52 |        1192.81 |            3618.89 |            3492.18 |
| 2048     |        4253.68 |        1241.68 |            7478.97 |            6183.87 |
| 4096     |        6798.43 |        1223.78 |           12694.69 |            8137.15 |
| 8192     |        8555.38 |        1215.61 |           17995.62 |           10071.36 |
| 16384    |        8959.21 |        1242.54 |           20266.70 |           10616.34 |
| 32768    |       12535.73 |        7443.77 |           29565.37 |           16977.47 |
| 65536    |       13500.37 |        9062.89 |           38396.04 |           20650.83 |
| 131072   |       14389.96 |        9723.24 |           45520.51 |           23310.21 |
| 262144   |       14985.33 |        9929.02 |           47415.26 |           23807.30 |
| 524288   |       15183.32 |       10073.86 |           48386.43 |           24093.90 |
| 1048576  |       15304.63 |       10169.66 |           48920.17 |           24221.76 |
| 2097152  |       15349.92 |       10209.67 |           47832.84 |           24285.75 |
| 4194304  |       15365.95 |       10226.04 |           47959.64 |           24226.69 |

#### 4 GPU to 4 GPU latency

The unit is micro-second.

The results of `ComputeNode(A) Mem` and `ComputeNode(V) Mem` are host memory to host memory transfer.

| Size (B) | ComputeNode(A) | ComputeNode(V) | ComputeNode(A) Mem | ComputeNode(V) Mem |
| :------- | -------------: | -------------: | ------------------:| ------------------:|
| 0        |           2.10 |           1.46 |               1.51 |               1.04 |
| 1        |           3.41 |           2.57 |               1.51 |               0.89 |
| 2        |           3.23 |           2.47 |               1.49 |               0.89 |
| 4        |           3.23 |           2.47 |               1.49 |               0.89 |
| 8        |           3.23 |           2.47 |               1.49 |               0.89 |
| 16       |           3.27 |           2.48 |               1.49 |               0.89 |
| 32       |           3.42 |           2.61 |               1.52 |               0.94 |
| 64       |           3.55 |           2.78 |               1.58 |               1.06 |
| 128      |           3.54 |           2.84 |               1.63 |               1.08 |
| 256      |           3.60 |           2.82 |               1.91 |               1.59 |
| 512      |           3.64 |           2.93 |               1.88 |               1.67 |
| 1024     |           3.74 |           3.27 |               1.98 |               1.86 |
| 2048     |           3.96 |           4.32 |               2.79 |               2.24 |
| 4096     |           4.44 |           6.39 |               3.42 |               3.02 |
| 8192     |           4.93 |          15.87 |               4.26 |               4.36 |
| 16384    |           9.05 |          20.53 |               6.27 |               5.87 |
| 32768    |          11.06 |          32.66 |               7.54 |               7.43 |
| 65536    |          14.20 |          59.74 |               9.82 |              11.41 |
| 131072   |          20.00 |         120.32 |              14.12 |              18.21 |
| 262144   |          30.30 |         100.95 |              12.02 |              30.26 |
| 524288   |          52.02 |         148.97 |              19.50 |              54.75 |
| 1048576  |          98.26 |         207.86 |              38.54 |              98.41 |
| 2097152  |         196.01 |         448.89 |              90.85 |             178.46 |
| 4194304  |         397.32 |         875.08 |             181.03 |             356.67 |

#### 4 GPU to 4 GPU bandwidth

The unit is MB/s.

The results of `ComputeNode(A) Mem` and `ComputeNode(V) Mem` are host memory to host memory transfer.

| Size (B) | ComputeNode(A) | ComputeNode(V) | ComputeNode(A) Mem | ComputeNode(V) Mem |
| :------- | -------------: | -------------: | ------------------:| ------------------:|
| 1        |           11.88 |         10.05 |              18.77 |              20.61 |
| 2        |           23.97 |         20.35 |              43.52 |              41.29 |
| 4        |           48.00 |         40.50 |              87.05 |              83.18 |
| 8        |           95.96 |         80.72 |             171.34 |             166.49 |
| 16       |          192.03 |        162.87 |             343.89 |             334.63 |
| 32       |          382.38 |        322.35 |             693.62 |             663.83 |
| 64       |          643.30 |        572.58 |            1340.45 |            1235.21 |
| 128      |         1435.89 |        966.34 |            2596.91 |            2426.74 |
| 256      |         2771.25 |       2072.21 |            4075.05 |            4133.56 |
| 512      |         5200.01 |       2600.93 |            7756.57 |            7380.08 |
| 1024     |         9558.48 |       2586.49 |           14256.79 |           13104.84 |
| 2048     |        15467.00 |       2584.31 |           24737.11 |           18883.46 |
| 4096     |        19216.83 |       2539.01 |           38301.83 |           21352.97 |
| 8192     |        19386.39 |       2546.60 |           45113.57 |           24448.40 |
| 16384    |        20024.22 |       2557.90 |           47935.26 |           24524.21 |
| 32768    |        20352.19 |      18694.69 |           48182.37 |           24313.84 |
| 65536    |        37893.77 |      19479.79 |           95699.73 |           24678.83 |
| 131072   |        38053.04 |      19817.11 |           97972.69 |           24741.34 |
| 262144   |        38548.09 |      20077.42 |           98469.54 |           24740.74 |
| 524288   |        38791.93 |      20279.33 |           97847.94 |           24753.51 |
| 1048576  |        38940.73 |      20392.52 |           95703.03 |           24779.42 |
| 2097152  |        39045.19 |      20454.89 |           95381.41 |           24785.92 |
| 4194304  |        39056.29 |      20482.11 |           93295.50 |           24786.66 |

#### 8 GPU to 8 GPU latency

The unit is micro-second.

The results of `ComputeNode(A) Mem` are host memory to host memory transfer.

| Size (B) | ComputeNode(A) | ComputeNode(A) Mem |
| :------- | -------------: | -----------------: |
| 0        |           2.15 |               1.52 |
| 1        |           3.89 |               1.50 |
| 2        |           3.26 |               1.49 |
| 4        |           3.26 |               1.50 |
| 8        |           3.29 |               1.49 |
| 16       |           3.28 |               1.50 |
| 32       |           3.93 |               1.52 |
| 64       |           4.03 |               1.59 |
| 128      |           4.11 |               1.63 |
| 256      |           4.09 |               1.92 |
| 512      |           4.14 |               1.89 |
| 1024     |           4.32 |               2.00 |
| 2048     |           4.48 |               2.81 |
| 4096     |           5.03 |               3.45 |
| 8192     |           5.43 |               4.35 |
| 16384    |          14.27 |               6.41 |
| 32768    |          16.69 |               8.34 |
| 65536    |          31.21 |              10.73 |
| 131072   |          36.24 |              16.60 |
| 262144   |          54.48 |              13.41 |
| 524288   |          98.21 |              26.55 |
| 1048576  |         181.14 |              57.41 |
| 2097152  |         356.62 |             124.62 |
| 4194304  |         711.55 |             291.28 |

#### 8 GPU to 8 GPU bandwidth

The unit is MB/s.

The results of `ComputeNode(A) Mem` are host memory to host memory transfer.

| Size (B) | ComputeNode(A) | ComputeNode(A) Mem |
| :------- | -------------: | -----------------: |
| 1        |          23.76 |              44.10 |
| 2        |          47.45 |              88.50 |
| 4        |          96.02 |             177.14 |
| 8        |         190.93 |             353.45 |
| 16       |         381.39 |             704.55 |
| 32       |         763.55 |            1414.44 |
| 64       |        1304.77 |            2690.03 |
| 128      |        2866.25 |            5148.24 |
| 256      |        5499.42 |            8239.82 |
| 512      |       10288.23 |           15584.22 |
| 1024     |       17759.58 |           27018.88 |
| 2048     |       19403.11 |           41155.48 |
| 4096     |       20087.16 |           47311.68 |
| 8192     |       20058.93 |           48359.35 |
| 16384    |       20394.76 |           49066.64 |
| 32768    |       38807.33 |           97887.06 |
| 65536    |       39063.81 |           98496.95 |
| 131072   |       39003.93 |           98680.57 |
| 262144   |       38918.60 |           98634.07 |
| 524288   |       38970.39 |           97700.45 |
| 1048576  |       38949.30 |           95127.09 |
| 2097152  |       39081.00 |           94185.41 |
| 4194304  |       39017.66 |           91941.92 |
