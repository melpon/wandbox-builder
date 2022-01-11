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
  {
    RESTORE=`(set +o | grep xtrace) 2>/dev/null`;
    set +x
  } 2>/dev/null

  _compare_version "$@"
  result=$?

  $RESTORE
  { return $result; } 2>/dev/null
}

function curl_strict_sha256() {
  url=$1
  sha256=$2
  filename=$3

  if [ -z "$filename" ]; then
    curl -fLO $url
    filename=`basename ${url%\?*}`
  else
    curl -fL $url -o $filename
  fi

  if [ ! -e $sha256 ]; then
    sha256sum -b $filename > $sha256
    # GitHub Actions 経由でビルド中の場合、
    # git add して push する
    if [ "$GITHUB_ACTIONS" == "true" ]; then
      pushd $GITHUB_WORKSPACE
        git remote set-url origin https://github-actions:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}
        git config --global user.name "${GITHUB_ACTOR}"
        git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
        git add $sha256
        git commit -m "[skip ci] Add `basename $sha256`"
        git push origin --all
      popd
    fi
  fi

  if sha256sum -c $sha256; then
    return 0
  else
    return 1
  fi
}

function check_install() {
  # チェック用ファイルが存在しない場合はチェックせず常にビルドする
  if [ ! -e "$2" ]; then
    echo "[Skip] check_install $1"
    return 0
  fi

  if (cat "$2" | jq -e ".[] | select(.name==\"$1\")" >/dev/null); then
    # 無事探しているファイルが見つかったら成功としてシェルを終了する
    echo "::set-output name=need_install::false"
    exit 0
  fi

  # 探しているファイルが見つからなかったので、継続してインストールを続ける
  echo "::set-output name=need_install::true"
  return 0
}

function archive_install() {
  pushd "`dirname $1`"
    tar czf "$2" "`basename $1`"
  popd
  echo "::set-output name=package_filename::$3"
  echo "::set-output name=package_path::$2"
  echo "::set-output name=prefix::$1"
}
