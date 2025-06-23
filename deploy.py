import os
import yaml
import tempfile
import subprocess
import urllib
import logging
import shutil
import tarfile
import argparse
import json
import get_asset_info
from typing import Optional, List, Tuple


# デプロイしたいバージョン
def get_expected_versions(filenames: List[str]) -> List[Tuple[str, str]]:
    r = []
    for filename in filenames:
        with open(filename) as f:
            data = yaml.load(f, Loader=yaml.Loader)
        for k, v in data['jobs'].items():
            if k.startswith('_'):
                continue
            for version in v['strategy']['matrix']['version']:
                r.append((k, str(version)))
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


def download(url: str, output_dir: Optional[str] = None, filename: Optional[str] = None, args: List[str] = []) -> str:
    if filename is None:
        output_path = urllib.parse.urlparse(url).path.split('/')[-1]
    else:
        output_path = filename

    if output_dir is not None:
        output_path = os.path.join(output_dir, output_path)

    if os.path.exists(output_path):
        return output_path

    retry = 5
    while True:
        try:
            if shutil.which('curl') is not None:
                cmd(["curl", "-fLo", output_path, url] + args)
            else:
                cmd(["wget", "-cO", output_path, url] + args)
            break
        except Exception:
            # ゴミを残さないようにする
            if os.path.exists(output_path):
                os.remove(output_path)
            retry -= 1
            if retry == 0:
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
def deploy(compiler: str, version: str, version_dir: str, deploy_dir: str, download_url: str, archive_name: str, github_token: Optional[str] = None):
    with tempfile.TemporaryDirectory(dir="/opt/wandbox/_tmp") as tempdir:
        # コンパイラをダウンロード
        header_args = ["-H", "Accept: application/octet-stream"]
        if github_token is not None:
            header_args += ["-H", f"Authorization: token {github_token}"]
        # なんかよく切断されるのでリトライを設定する
        header_args += ["--retry", "5"]

        archive_path = download(download_url, tempdir, archive_name, header_args)

        # バージョンファイルを消して解凍
        mkdir_p(version_dir)
        version_path = os.path.join(version_dir, f'{compiler} {version}')
        if os.path.exists(version_path):
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
    if os.path.exists(version_path):
        with open(version_path, 'rb') as f:
            rm_rf(f.read().decode('utf-8'))
    rm_rf(version_path)


def find_download_url(asset_info, compiler, version):
    name = f"{compiler}-{version.replace(' ', '-')}.tar.gz"
    for obj in asset_info:
        if obj['name'] == name:
            return name, obj['url']
    raise Exception(f'{name} not in asset info')


def get_all_workflow_files() -> List[str]:
    r = []
    for file in os.listdir('.github/workflows'):
        if file.startswith('build') and file.endswith('.yml'):
            r.append(os.path.join('.github/workflows', file))
    return r


def deploy_all(url: str, github_token: Optional[str]):
    # 各コンパイラのダウンロード URL を取得する
    asset_info = get_asset_info.get_asset_info(url, github_token)

    version_dir = '/opt/wandbox-data/wandbox-deploy'
    deploy_dir = '/opt/wandbox'

    expected_versions = get_expected_versions(get_all_workflow_files())
    actual_versions = get_actual_versions(version_dir)
    adds, dels = get_difference(actual_versions, expected_versions)
    for compiler, version in dels:
        deploy_delete(compiler, version, version_dir)
    for compiler, version in adds:
        name, download_url = find_download_url(asset_info, compiler, version)
        deploy(compiler, version, version_dir, deploy_dir, download_url, name, github_token)


def get_all_workflow_names() -> List[str]:
    r = []
    for file in get_all_workflow_files():
        with open(file) as f:
            data = yaml.load(f, Loader=yaml.Loader)
        r.append(data['name'])
    return r


def update_workflow(workflow: str, commit: str) -> bool:
    """
    特定のコミットに対するワークフロー情報を更新する

    そのコミットに対する全てのワークフローの実行が終わった場合は true を返す
    """
    # この関数が複数のプロセスから実行されるとまずいけど、
    # そんなことはなかなか起きないはずなので気にしないでおく

    # 確認したいワークフロー名の一覧
    workflow_names = get_all_workflow_names()

    # ワークフロー情報の更新
    deploying_dir = '/opt/wandbox-data/wandbox-deploying'
    mkdir_p(deploying_dir)
    commit_filepath = os.path.join(deploying_dir, f'{commit}.json')
    if os.path.exists(commit_filepath):
        commit_info = json.load(open(commit_filepath))
    else:
        commit_info = {name: False for name in workflow_names}

    commit_info[workflow] = True

    with open(commit_filepath, 'w') as f:
        f.write(json.dumps(commit_info))

    # ワークフローの全ての実行が終わってるかを確認する
    for name in workflow_names:
        if not commit_info.get(name, False):
            return False
    return True


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("workflow")
    parser.add_argument("commit")
    parser.add_argument("url")
    parser.add_argument("--github_token", default=None)

    args = parser.parse_args()
    if update_workflow(args.workflow, args.commit):
        deploy_all(args.url, args.github_token)
        print("::set-output name=deployed::true")
    else:
        print("::set-output name=deployed::false")


BASE_DIR = os.path.abspath(os.path.dirname(__file__))


if __name__ == '__main__':
    os.chdir(BASE_DIR)
    main()