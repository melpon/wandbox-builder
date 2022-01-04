import os
import yaml
import tempfile
import subprocess
import urllib
import logging
import shutil
import tarfile
import argparse
import requests
import get_asset_info
from typing import Optional, List, Tuple



# デプロイしたいバージョン
def get_expected_versions(filename) -> List[Tuple[str, str]]:
    with open(filename) as f:
        data = yaml.load(f, Loader=yaml.Loader)
    r = []
    for k, v in data['jobs'].items():
        if k.startswith('_'):
            continue
        for version in v['strategy']['matrix']['version']:
            r.append((k, version))
    return r


# 今現在デプロイされているバージョン
def get_actual_versions(dirname) -> List[Tuple[str, str]]:
    r = []
    if not os.path.exists(dirname):
        return r

    with os.scandir(dirname) as it:
        for entry in it:
            if entry.is_file():
                k, v = entry.name.split(' ', maxsplit=1)
                r.append((k, v))
    return r


# 差分を調べる
# a から b になるのに追加する必要がある差分 add と削除する必要がある差分 del のタプルを返す
def get_difference(a, b):
    sa = set(a)
    sb = set(b)
    adds = sb - sa
    dels = sa - sb
    return sorted(adds), sorted(dels)


def mkdir_p(path: str):
    if os.path.exists(path):
        logging.debug(f'mkdir -p {path} => already exists')
        return
    os.makedirs(path, exist_ok=True)
    logging.debug(f'mkdir -p {path} => directory created')


def cmd(args, **kwargs):
    logging.debug(f'+{args} {kwargs}')
    if 'check' not in kwargs:
        kwargs['check'] = True
    if 'resolve' in kwargs:
        resolve = kwargs['resolve']
        del kwargs['resolve']
    else:
        resolve = True
    if resolve:
        args = [shutil.which(args[0]), *args[1:]]
    return subprocess.run(args, **kwargs)


def download(url: str, output_dir: Optional[str] = None, filename: Optional[str] = None) -> str:
    if filename is None:
        output_path = urllib.parse.urlparse(url).path.split('/')[-1]
    else:
        output_path = filename

    if output_dir is not None:
        output_path = os.path.join(output_dir, output_path)

    if os.path.exists(output_path):
        return output_path

    try:
        if shutil.which('curl') is not None:
            cmd(["curl", "-fLo", output_path, url])
        else:
            cmd(["wget", "-cO", output_path, url])
    except Exception:
        # ゴミを残さないようにする
        if os.path.exists(output_path):
            os.remove(output_path)
        raise

    return output_path


def rm_rf(path: str):
    if not os.path.exists(path):
        logging.debug(f'rm -rf {path} => path not found')
        return
    if os.path.isfile(path) or os.path.islink(path):
        os.remove(path)
        logging.debug(f'rm -rf {path} => file removed')
    if os.path.isdir(path):
        shutil.rmtree(path)
        logging.debug(f'rm -rf {path} => directory removed')


def extract(file: str, output_dir: str):
    if not file.endswith('.tar.gz'):
        raise Exception()

    name = os.path.basename(file[:-len('.tar.gz')])
    path = os.path.join(output_dir, name)
    rm_rf(path)
    with tarfile.open(file) as t:
        t.extractall(output_dir)
    # path にディレクトリが作られているはず
    if not os.path.isdir(path):
        raise Exception()

    return path


# デプロイする
def deploy(compiler: str, version: str, version_dir: str, deploy_dir: str, download_url: str):
    with tempfile.TemporaryDirectory() as tempdir:
        # コンパイラをダウンロード
        archive_path = download(download_url, tempdir)

        # バージョンファイルを消して解凍
        mkdir_p(version_dir)
        version_path = os.path.join(version_dir, f'{compiler} {version}')
        with open(version_path, 'rb') as f:
            rm_rf(f.read().decode('utf-8'))
        rm_rf(version_path)

        mkdir_p(deploy_dir)
        deploy_path = extract(archive_path, deploy_dir)

        # デプロイ完了したのでバージョン情報とパスを書き込む
        with open(version_path, 'wb') as f:
            f.write(deploy_path.encode('utf-8'))


# 削除する
def deploy_delete(compiler: str, version: str, version_dir: str):
    # バージョンファイルと展開先ディレクトリを削除
    version_path = os.path.join(version_dir, f'{compiler} {version}')
    with open(version_path, 'rb') as f:
        rm_rf(f.read().decode('utf-8'))
    rm_rf(version_path)


def find_download_url(asset_info, compiler, version):
    name = f"{compiler}-{version.replace(' ', '-')}.tar.gz"
    for obj in asset_info:
        if obj['name'] == name:
            return obj['browser_download_url']
    raise Exception(f'{name} not in asset info')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("url")
    parser.add_argument("--github_token", default=None)

    args = parser.parse_args()

    # 各コンパイラのダウンロード URL を取得する
    asset_info = get_asset_info.get_asset_info(args.url, args.github_token)

    version_dir = '/opt/wandbox-data/wandbox-deploy'
    deploy_dir = '/opt/wandbox'

    expected_versions = get_expected_versions('.github/workflows/build.yml')
    actual_versions = get_actual_versions(version_dir)
    adds, dels = get_difference(actual_versions, expected_versions)
    for compiler, version in dels:
        deploy_delete(compiler, version, version_dir)
    for compiler, version in adds:
        download_url = find_download_url(asset_info, compiler, version)
        deploy(compiler, version, version_dir, deploy_dir, download_url)


BASE_DIR = os.path.abspath(os.path.dirname(__file__))


if __name__ == '__main__':
    os.chdir(BASE_DIR)
    main()