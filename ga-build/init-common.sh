# <compiler>/run.sh から source で呼ばれるスクリプト。
# このスクリプトを直接呼ぶことは無い。
set -e

TARGET=$(basename `pwd`)

. ../init.sh

if [ $# -lt 2 ]; then
  echo "$0 <subcommand> <version>"
  exit 1
fi

SUBCOMMAND=$1
VERSION=$2
PACKAGE_FILENAME=$TARGET-$VERSION.tar.gz
PACKAGE_PATH=/opt/wandbox/$TARGET-$VERSION.tar.gz
PREFIX=/opt/wandbox/$TARGET-$VERSION

case "$SUBCOMMAND" in
  "setup" ) : ;;
  "install" ) : ;;
  * ) exit 1
esac

check_install $PACKAGE_FILENAME ../../asset_info.json

rm -rf ~/tmp/$TARGET-$VERSION/
mkdir -p ~/tmp/$TARGET-$VERSION/
cd ~/tmp/$TARGET-$VERSION/

set -x
