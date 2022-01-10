set -ex
cd `dirname $0`

docker build . -t melpon/wandbox:ubuntu-20.04-buildbase
