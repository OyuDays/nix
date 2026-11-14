#!/usr/bin/env python3

import psutil
import argparse
import glob

parser = argparse.ArgumentParser()
parser.add_argument("-i", action='store_true')
parser.add_argument("-t", action='store_true')

args = parser.parse_args()

if args.i:
    print('media-flash-memory-stick-symbolic')
if args.t:
    mem = psutil.virtual_memory()

    print(f'{round(mem.used/1048576)}/{round(mem.total/1048576)} MiB')
