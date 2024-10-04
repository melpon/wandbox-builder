#!/bin/env python3
import sys
import subprocess
import os


def main():
    if len(sys.argv) <= 1:
        print(f"{sys.argv[0]} <compiler> <version> [<args>...]")
        sys.exit(0)

    compiler = sys.argv[1]
    version = ' '.join(sys.argv[2:])
    version_name = '-'.join(sys.argv[2:])
    logfile = f'ga-build/{compiler}-{version_name}.log'

    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    subprocess.run(['bash', 'buildbase/build.sh'])
    git_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    subprocess.run(['docker', 'run', '-v', git_dir + ':/work/wandbox-builder', '-it', 'melpon/wandbox:ubuntu-24.04-buildbase', '/bin/bash', '-c', f'''
    set -ex
    set -o pipefail
    cd /work/wandbox-builder
    export GITHUB_OUTPUT=`pwd`/ga-build/{compiler}-{version_name}.env
    ./ga-build/{compiler}/run.sh setup {version} | tee {logfile}
    ./ga-build/{compiler}/run.sh install {version} | tee -a {logfile}
    cat $GITHUB_OUTPUT
    '''])


if __name__ == '__main__':
    main()
