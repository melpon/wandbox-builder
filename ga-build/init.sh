function _vercmp() {
    # head は何よりも新しいバージョンとする
    if [ $1 == head -a $2 == head ]; then
        return 0
    fi
    if [ $1 == head ]; then
        # $1 > $2
        return 1
    fi
    if [ $2 == head ]; then
        # $1 < $2
        return 2
    fi

    if [[ $1 == $2 ]]; then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 2
        fi
    done
    return 0
}

function _compare_version() {
  case $2 in
    "==") _vercmp $1 $3; test $? -eq 0; return $?;;
    ">") _vercmp $1 $3; test $? -eq 1; return $?;;
    "<") _vercmp $1 $3; test $? -eq 2; return $?;;
    ">=") _vercmp $1 $3; test $? -eq 1 -o $? -eq 0; return $?;;
    "<=") _vercmp $1 $3; test $? -eq 2 -o $? -eq 0; return $?;;
    *) echo "$2 is not valid comparer"; exit 1;;
  esac
}

function compare_version() {
  { set +x; } 2>/dev/null
  _compare_version "$@"
  result=$?
  set -x
  { return $result; } 2>/dev/null
}

function wget_strict_sha256() {
  url=$1
  sha256=$2
  shift 2

  if [ ! -e $sha256 ]; then
    set +x
    app=`basename $CURRENT_DIR`
    echo "a sha256 file '$sha256' not found."
    echo "run below command to create the sha256 file:"
    echo "  cd .. && ./sha256-calc.sh $app $url"
    exit 1
  fi
  wget $url "$@"
  if sha256sum -c $sha256; then
    :
  else
    exit 1
  fi
}

function check_install() {
  return 0
}

function archive_install() {
  tar czf "$2" "$1"
  echo "::set-output name=package_filename::$3"
  echo "::set-output name=package_path::$2"
}
