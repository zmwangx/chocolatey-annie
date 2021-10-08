import hashlib
import os
import os.path
import pathlib
import re
import tempfile
import xml.etree.ElementTree as ET
from distutils.version import StrictVersion as Version
from typing import Callable

import requests


ROOT = pathlib.Path(__file__).parent.parent
NUSPEC = ROOT / "annie.nuspec"
INSTALL_SCRIPT = ROOT / "tools/chocolateyinstall.ps1"
VERIFICATION = ROOT / "legal/VERIFICATION.txt"

REPO = "iawia002/annie"
GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")

ns = {"nuspec": "http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd"}


def get_current_version() -> str:
    return ET.parse(NUSPEC).find("nuspec:metadata/nuspec:version", ns).text


def get_latest_version() -> str:
    headers = {
        "Accept": "application/vnd.github.v3+json",
    }
    if GITHUB_TOKEN:
        headers["Authorization"] = f"token {GITHUB_TOKEN}"
    resp = requests.get(
        f"https://api.github.com/repos/{REPO}/releases/latest",
        headers=headers,
        timeout=5,
    ).json()
    tag = resp["tag_name"]
    return tag.lstrip("v")


def update_file_content(path: pathlib.Path, repl: Callable[..., str], *args, **kwargs):
    with path.open(encoding="utf-8") as fin:
        content = fin.read()
    content = repl(content, *args, **kwargs)
    with path.open("w", encoding="utf-8") as fout:
        fout.write(content)


def nuspec_repl(content: str, old_version: str, new_version: str) -> str:
    content = content.replace(
        f"<version>{old_version}</version>", f"<version>{new_version}</version>"
    )
    content = content.replace(f"v{old_version}", f"v{new_version}")
    return content


def install_script_repl(content: str, old_version: str, new_version: str) -> str:
    def get_url(version: str, arch: str) -> str:
        return (
            f"https://github.com/{REPO}/releases/download/v{version}/annie_{version}_{arch}-bit.zip"
            if Version(version) >= Version("0.11")
            else f"https://github.com/{REPO}/releases/download/{version}/annie_{version}_{arch}-bit.zip"
        )

    def get_sha256(url: str):
        location = pathlib.Path(tempfile.gettempdir()) / os.path.basename(url)

        if location.exists():
            print(f"using existing file {location} as {url}")
            m = hashlib.sha256()
            with location.open("rb") as fp:
                while (chunk := fp.read(65536)) :
                    m.update(chunk)
            return m.hexdigest()

        print(f"downloading {url} to {location} ...")
        with requests.get(url, stream=True, timeout=5) as r:
            r.raise_for_status()
            m = hashlib.sha256()
            with location.open("wb") as fp:
                for chunk in r.iter_content(chunk_size=65536):
                    fp.write(chunk)
                    m.update(chunk)
            return m.hexdigest()

    old_url32 = get_url(old_version, "Windows_32")
    new_url32 = get_url(new_version, "Windows_32")
    content = content.replace(old_url32, new_url32)
    new_url32_sha256 = get_sha256(new_url32)
    content = re.sub(r"(?<=Checksum       = ')\w{64}(?=')", new_url32_sha256, content)

    old_url64 = get_url(old_version, "Windows_64")
    new_url64 = get_url(new_version, "Windows_64")
    content = content.replace(old_url64, new_url64)
    new_url64_sha256 = get_sha256(new_url64)
    content = re.sub(r"(?<=Checksum64     = ')\w{64}(?=')", new_url64_sha256, content)

    assert new_url32 in content
    assert new_url32_sha256 in content
    assert new_url64 in content
    assert new_url64_sha256 in content

    return content


def github_setenv(key: str, val: str) -> None:
    with open(os.getenv("GITHUB_ENV"), "a") as fp:
        fp.write(f"{key}={val}\n")


def main():
    current_version = get_current_version()
    latest_version = get_latest_version()
    if Version(latest_version) <= Version(current_version):
        return

    print(f"updating from {current_version} to {latest_version}")
    update_file_content(NUSPEC, nuspec_repl, current_version, latest_version)
    update_file_content(
        INSTALL_SCRIPT, install_script_repl, current_version, latest_version
    )
    if os.getenv("GITHUB_WORKFLOW"):
        # Running in GitHub Actions; export env vars for future steps.
        github_setenv("UPDATED", "true")
        github_setenv("NEW_VERSION", latest_version)


if __name__ == "__main__":
    main()
