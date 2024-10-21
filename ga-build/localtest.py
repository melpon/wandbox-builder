#!/bin/env python3
import sys
import subprocess
import os


CONTAINER_NAME = 'wandbox-localtest'


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
    subprocess.run(['docker', 'container', 'stop', CONTAINER_NAME])
    subprocess.run(['docker', 'container', 'rm', CONTAINER_NAME])
    git_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    subprocess.run(['docker', 'container', 'create', '-v', git_dir + ':/work/wandbox-builder', '-it', '--name', CONTAINER_NAME, 'melpon/wandbox:ubuntu-24.04-buildbase'])
    subprocess.run(['docker', 'container', 'start', CONTAINER_NAME])
    subprocess.run(['docker', 'container', 'exec', CONTAINER_NAME, '/bin/bash', '-c', f'''
    set -ex
    set -o pipefail
    cd /work/wandbox-builder
    export GITHUB_OUTPUT=`pwd`/ga-build/{compiler}-{version_name}.env
    ./ga-build/{compiler}/run.sh setup {version} | tee {logfile}
    ./ga-build/{compiler}/run.sh install {version} | tee -a {logfile}
    cat $GITHUB_OUTPUT
    '''])
    print()
    print("For debugging, you can run below command:")
    print(f"$ docker exec -it {CONTAINER_NAME} /bin/bash")
    print()


if __name__ == '__main__':
    main()
