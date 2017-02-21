#!/usr/bin/env python

import json
import subprocess
import sys


def run(args):
    print(args)
    subprocess.check_call(args)


REPOSITORIES = {
  'llvm': 'apple/swift-llvm',
  'clang': 'apple/swift-clang',
  'swift': 'apple/swift-swift',
  'lldb': 'apple/swift-lldb',
  'cmark': 'apple/swift-cmark',
  'swift-integration-tests': 'apple/swift-integration-tests',
}


def main(tag):
    for name, repo in REPOSITORIES.items():
        if name == 'swift':
            continue
        url = 'https://github.com/%s.git' % repo
        run(['git', 'clone', '--depth', '1', '--branch', tag, url, name])

if __name__ == '__main__':
    main(sys.argv[1])
