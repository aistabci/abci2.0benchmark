# Local SSD Benchmark

| Software  | ComputeNode(V) | ComputeNode(A) |
| :-------- | -------------: | -------------: |
| fio       | 3.26           | 3.26           |
| OS        | CentOS 7.5     | RHEL 8.2       |
| gcc       | 7.4.0          | 8.3.1          |

Reference

- [fio GitHub](https://github.com/axboe/fio)
- [fio Document](https://fio.readthedocs.io/en/latest/index.html)


## Build fio for Each Compute Node

### ComputeNode(A)

```Console
es1 $ qrsh -g GROUP -l rt_AG.small=1
a0001 $ localssd/anode
a0001 $ wget https://github.com/axboe/fio/archive/refs/tags/fio-3.26.tar.gz
a0001 $ tar zxf fio-3.26.tar.gz
a0001 $ cd fio-fio-3.26
a0001 $ ./configure --prefix=`pwd`/../fio-3.26
a0001 $ make
a0001 $ make install
```

### ComputeNode(V)

```Console
es1 $ qrsh -g GROUP -l rt_G.small=1
g0001 $ localssd/vnode
g0001 $ wget https://github.com/axboe/fio/archive/refs/tags/fio-3.26.tar.gz
g0001 $ tar zxf fio-3.26.tar.gz
g0001 $ cd fio-fio-3.26
g0001 $ module load gcc/7.4.0
g0001 $ ./configure --prefix=`pwd`/../fio-3.26
g0001 $ make
g0001 $ make install
```


## Run Benchmarks

Go into each benchmark directory, like `anode`, and submit a job script in the directory.

```Console
es1 $ cd localssd
es1 $ cd anode
es1 $ qsub -g GROUP anode.sh
```


## Benchmark Results

Performance in MB/s.

| System         | Seq. Read | Seq. Write | Rand. Read | Rand. Write |
| :------------- | --------: | ---------: | ---------: |-----------: |
| ComputeNode(A) | 2732      | 1927       | 1650       | 1850        |
| ComputeNode(V) | 2546      | 1342       | 942        | 706         |

Performance in kIOPS for Random I/O.

| System         | Rand. Read | Rand. Write |
| :------------- | ---------: |-----------: |
| ComputeNode(A) | 403.58     | 451.81      |
| ComputeNode(V) | 230.40     | 172.42      |
