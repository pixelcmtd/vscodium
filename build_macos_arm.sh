#!/bin/sh

[ $# -lt 1 ] && echo "No version given." && exit 1
set -uxe

rm -rf VSCode* vscode
. get_repo.sh
SHOULD_BUILD=yes CI_BUILD=no OS_NAME=osx VSCODE_ARCH=arm64 . build.sh
cd ..
tar cJf vscodium/VSCode-darwin-arm64/VSCodium.tar.xz vscodium/VSCode-darwin-arm64/VSCodium.app -x "*.DS_Store"
gpg --armor --sign --local-user C6917CCF69E560DEFD0EFB17E90005837ECF00FF vscodium/VSCode-darwin-arm64/VSCodium.tar.xz

gh release create "$1" --notes "A new release that you can actually trust. 😉

🏳️‍⚧️"
gh release upload "$1" vscodium/VSCode-darwin-arm64/VSCodium.zip

sudo rm -rf /Applications/VSCodium.app
sudo cp -r vscodium/VSCode-darwin-arm64/VSCodium.app /Applications/VSCodium.app
sudo xattr -r -d com.apple.quarantine /Applications/VSCodium.app
