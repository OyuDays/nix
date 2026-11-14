#!/usr/bin/env python3

import psutil
import argparse
import glob

parser = argparse.ArgumentParser()
parser.add_argument("-i", action='store_true')
parser.add_argument("-t", action='store_true')

args = parser.parse_args()

if args.i:
    print('speedometer-symbolic')
if args.t:
    cpu_percent = psutil.cpu_percent(0.5, False)
    print(f'{cpu_percent}%')
