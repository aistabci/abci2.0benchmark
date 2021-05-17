# Inter GPU Point-to-Point Communication Benchmark

| Software  | ComputeNode(V) | ComputeNode(A) |
| :-------- | -------------: | -------------: |
| OS        | CentOS 7.5     | RHEL 8.2       |
| gcc       | 7.4.0          | 8.3.1          |
| CUDA      | 11.2.2         | 11.2.2         |


## Build and Run

### Intra-Node Inter-GPU Communication

### ComputeNode(A)

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

### ComputeNode(V)

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
