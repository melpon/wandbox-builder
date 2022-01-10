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
    subprocess.run(['docker', 'run', '-v', git_dir + ':/work/wandbox-builder', '-it', 'melpon/wandbox:ubuntu-20.04-buildbase', '/bin/bash', '-c', f'''
    set -ex
    set -o pipefail
    cd /work/wandbox-builder
    ./ga-build/{compiler}/run.sh setup {version} | tee {logfile}
    ./ga-build/{compiler}/run.sh install {version} | tee -a {logfile}
    # ::set-output name=package_filename::gcc-10.2.0.tar.gz
    # ::set-output name=package_path::/opt/wandbox/gcc-10.2.0.tar.gz
    # ::set-output name=prefix::/opt/wandbox/gcc-10.2.0
    PACKAGE_FILENAME=`grep -e '^::set-output name=package_filename::' {logfile} | cut -d ':' -f5`
    PACKAGE_PATH=`grep -e '^::set-output name=package_path::' {logfile} | cut -d ':' -f5`
    PREFIX=`grep -e '^::set-output name=package_path::' {logfile} | cut -d ':' -f5`
    ls -lha $PACKAGE_PATH
    '''])


if __name__ == '__main__':
    main()
