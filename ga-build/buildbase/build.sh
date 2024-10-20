set -ex
cd `dirname $0`

docker build . -t melpon/wandbox:ubuntu-24.04-buildbase
