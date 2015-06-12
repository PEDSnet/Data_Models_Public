import argparse
import csv
import sys

SITES = set([
    'nationwide',
    'nemours',
    'stlouis',
    'cincinnati'
])


def get_files(a_dir):
    pass


def get_latest_dir(site):
    pass


def make_batch(site):
    latest_dir = get_latest_dir(site)
    files_dict = get_files(latest_dir)
    for table, a_file in files_dict.items():
        pass


def get_args():
    parser = argparse.ArgumentParser(prog='load_i2b2.py')
    parser.add_argument('--root-dir', '-d')
    parser.add_argument('site', type=str)
    args = parser.parse_args()
    if args.site.lower() not in SITES:
        raise ValueError('Invalid site: {0}'.format(args.site))
    return args


def main():
    args = get_args()
    make_batch()

if __name__ == '__main__':
    main()
