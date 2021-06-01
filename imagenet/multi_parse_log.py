import glob
import os
import sys

from tensorflow.python.summary.summary_iterator import summary_iterator


if len(sys.argv) != 2:
    print('Specify a log directory.', file=sys.stderr)
    sys.exit(1)


tensorboard_logs = sys.argv[1]
files = glob.glob(os.path.join(tensorboard_logs, '*'))

if len(files) != 1:
    print('There must be a single file in the log directory.', file=sys.stderr)
    sys.exit(1)

logfile = files[0]

walltimes = [e.wall_time for e in summary_iterator(logfile)]
time_diff = walltimes[-1] - walltimes[0]

print(f'Time for train: {time_diff:.2f}')
