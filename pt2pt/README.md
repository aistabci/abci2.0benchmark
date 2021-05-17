# Inter GPU Point-to-Point Communication Benchmark

| Software  | ComputeNode(V) | ComputeNode(A) |
| :-------- | -------------: | -------------: |
| OS        | CentOS 7.5     | RHEL 8.2       |
| gcc       | 7.4.0          | 8.3.1          |
| CUDA      | 11.2.2         | 11.2.2         |


## Build and Run

### Intra-Node Inter-GPU Communication

### ComputeNode(V)

### ComputeNode(V)

```Console
es1 $ qrsh -g GROUP -l rt_F=1
g0001 $ cd pt2pt/intra_vnode
g0001 $ module load cuda/11.2/11.2.2
g0001 $ cp -r $CUDA_HOME/samples .
g0001 $ (cd samples/1_Utilities/p2pBandwidthLatencyTest; make)
g0001 $ ./samples/bin/x86_64/linux/release/p2pBandwidthLatencyTest > intra_vnode.out
g0001 $ rm -fr samples
```

Check scores under `Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)` and `P2P=Enabled Latency (P2P Writes) Matrix (us)` sections.

