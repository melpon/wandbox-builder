import os
import yaml
import tempfile
import argparse
import get_asset_info
from typing import Optional, List

from deploy import download, mkdir_p, extract, rm_rf


# デプロイしたいコンパイラ
def get_heads(filename) -> List[str]:
    with open(filename) as f:
        data = yaml.load(f, Loader=yaml.Loader)
    r = []
    for name in data['jobs']['heads']['strategy']['matrix']['name']:
        r.append(name)
    return r


def find_download_url(asset_info, name):
    name = f"{name}.tar.gz"
    for obj in asset_info:
        if obj['name'] == name:
            return name, obj['url']
    raise Exception(f'{name} not in asset info')


# デプロイする
def deploy(head: str, version_dir: str, deploy_dir: str, download_url: str, archive_name: str, github_token: Optional[str] = None):
    with tempfile.TemporaryDirectory() as tempdir:
        # コンパイラをダウンロード
        header_args = ["-H", "Accept: application/octet-stream"]
        if github_token is not None:
            header_args += ["-H", f"Authorization: token {github_token}"]
        # なんかよく切断されるのでリトライを設定する
        header_args += ["--retry", "5"]

        archive_path = download(download_url, tempdir, archive_name, header_args)

        # テンポラリディレクトリ上に解凍
        mkdir_p(version_dir)
        extract_path = extract(archive_path, tempdir)

        # バージョンファイルと本体を消して、解凍した新しいバージョンを配置する
        version_path = os.path.join(version_dir, head)
        if os.path.exists(version_path):
            with open(version_path, 'rb') as f:
                rm_rf(f.read().decode('utf-8'))
        rm_rf(version_path)

        mkdir_p(deploy_dir)
        deploy_path = os.path.join(deploy_dir, head)
        os.rename(extract_path, deploy_path)

        # デプロイ完了したのでバージョン情報とパスを書き込む
        with open(version_path, 'wb') as f:
            f.write(deploy_path.encode('utf-8'))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("url")
    parser.add_argument("--github_token", default=None)

    args = parser.parse_args()

    # 各コンパイラのダウンロード URL を取得する
    asset_info = get_asset_info.get_asset_info(args.url, args.github_token)

    version_dir = '/opt/wandbox-data/wandbox-deploy-heads'
    deploy_dir = '/opt/wandbox'

    heads = get_heads('.github/workflows/heads.yml')
    for head in heads:
        name, download_url = find_download_url(asset_info, head)
        deploy(head, version_dir, deploy_dir, download_url, name, args.github_token)


BASE_DIR = os.path.abspath(os.path.dirname(__file__))


if __name__ == '__main__':
    os.chdir(BASE_DIR)
    main()