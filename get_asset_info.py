import requests
import os
import argparse
import json
from typing import Optional


def get_asset_info(url: str, github_token: Optional[str] = None):
    result = []
    headers = {
        'Accept': 'application/vnd.github.v3+json',
    }
    if github_token is not None:
        headers['Authorization'] = f'token {github_token}'

    page = 1
    while True:
        r = requests.get(f'{url}?page={page}', headers=headers)
        r.raise_for_status()
        js = r.json()
        if not isinstance(js, list):
            raise Exception('response is not list')
        if len(js) == 0:
            break
        result.extend(js)
        page += 1
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("url")
    parser.add_argument("--github_token", default=None)

    args = parser.parse_args()

    # 各コンパイラのダウンロード URL を取得する
    asset_info = get_asset_info(args.url, args.github_token)
    print(json.dumps(asset_info, indent=2))


BASE_DIR = os.path.abspath(os.path.dirname(__file__))


if __name__ == '__main__':
    os.chdir(BASE_DIR)
    main()