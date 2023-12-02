#!/usr/bin/env bash

##Debug
#set -x ; set +e

###ENV (Exported or passed Inline)
# #Example:
# export GITHUB_TOKEN="$UNDERPRIVILEGED_READ_ONLY_GH_TOKEN" #Required to get around github api rate limits
# export BIN="eget" #placeholder for [bin] name = "$BIN", must be same in source_bin
# export REPO="zyedidia/eget" #NOT URL, Only $AUTHOR/$REPO_NAME
# export SOURCE_BIN="Azathothas/Toolpacks" #Full: https://raw.githubusercontent.com/Azathothas/Toolpacks/main/aarch64_arm64_v8a_Android/$BIN

##Usage: 
# Actions: BIN="$BIN" REPO="$REPO" SOURCE_BIN="Azathothas/Toolpacks" bash "$GITHUB_WORKSPACE/main/.github/scripts/pkg_metafetcher_aarch64_arm64_v8a_Android.sh"
# General: BIN="$BIN" REPO="$REPO" SOURCE_BIN="Azathothas/Toolpacks" bash <(curl -qfsSL "https://raw.githubusercontent.com/metis-os/hysp-pkgs/main/.github/scripts/pkg_metafetcher_aarch64_arm64_v8a_Android.sh")
#List all available $BIN: curl -qfsSL "https://api.github.com/repos/Azathothas/Toolpacks/contents/aarch64_arm64_v8a_Android" | jq -r '.[].name' | grep -iv '.md$' | sort -u 

#Sanity Checks for token
if [[ -z "$GITHUB_TOKEN" ]]; then
   # With Token = 5000 req/minute (80 req/minute)
   # No Token = 60 request/hr
   echo -e "\n[-] GITHUB_TOKEN is NOT Exported"
   echo -e "Export it to avoid ratelimits"
   exit 1
fi

#Ulimit
ulimit -S -s unlimited 2>/dev/null
ulimit -f unlimited 2>/dev/null
#Fetch raw json
# For size & actual source url
PKG_METADATA="$(curl -qfsSL "https://api.github.com/repos/$SOURCE_BIN/contents/aarch64_arm64_v8a_Android/$BIN" -H "Authorization: Bearer $GITHUB_TOKEN" 2>/dev/null | jq '.content=""')" && export PKG_METADATA="$PKG_METADATA"
#For Name, author, description, lang, license, repo url, stars, topics etc
REPO_METADATA="$(curl -qfsSL "https://api.github.com/repos/$REPO" -H "Authorization: Bearer $GITHUB_TOKEN" 2>/dev/null)" && export REPO_METADATA="$REPO_METADATA"
#For Version
RELEASE_METADATA="$(curl -qfsSL "https://api.github.com/repos/$REPO/releases/latest" -H "Authorization: Bearer $GITHUB_TOKEN" 2>/dev/null | jq '.assets=""')" && export RELEASE_METADATA="$RELEASE_METADATA"
#BLAKE3SUM for hash verification
B3_SUMS="$(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/aarch64_arm64_v8a_Android/BLAKE3SUM" -H "Authorization: Bearer $GITHUB_TOKEN" 2>/dev/null)" && export B3_SUMS="$B3_SUMS"
#SHA256SUMS for Legacy
#SHA256_SUMS="$(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/aarch64_arm64_v8a_Android/README.md" -H "Authorization: Bearer $GITHUB_TOKEN" 2>/dev/null | grep -A 9999999999999 "SHA256SUM" 2>/dev/null | awk '/Sizes/{exit} {print}' 2>/dev/null | sed 's/^[ \t]*//;s/[ \t]*$//')" && export SHA256_SUMS="$SHA256_SUMS"
SHA256_SUMS="$(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/aarch64_arm64_v8a_Android/SHA256SUM" -H "Authorization: Bearer $GITHUB_TOKEN" 2>/dev/null)" && export SHA256_SUMS="$SHA256_SUMS"
#Parse
NAME="$(echo $REPO_METADATA | jq -r '.name' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export NAME="$NAME"
AUTHOR="$(echo $REPO_METADATA | jq -r '.owner.login' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export AUTHOR="$AUTHOR"
DESCRIPTION="$(echo $REPO_METADATA | jq -r '.description' | sed 's/`//g' | sed 's/^[ \t]*//;s/[ \t]*$//' | sed ':a;N;$!ba;s/\r\n//g; s/\n//g')" && export DESCRIPTION="$DESCRIPTION"
LANGUAGE="$(echo $REPO_METADATA | jq -r '.language' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export LANGUAGE="$LANGUAGE"
LICENSE="$(echo $REPO_METADATA | jq -r '.license.name' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export LICENSE="$LICENSE"
LAST_UPDATED="$(echo $REPO_METADATA | jq -r '.pushed_at' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export LAST_UPDATED="$LAST_UPDATED"
#If Releases don't exist, use tags
if [ -z "$RELEASE_METADATA" ]; then
   PKG_VERSION="$(curl -qfsSL "https://api.github.com/repos/$REPO/tags" -H "Authorization: Bearer $GITHUB_TOKEN" 2>/dev/null | jq -r '.[0].name' )" && export PKG_VERSION="$PKG_VERSION"
   PKG_RELEASED="$(curl -qfsSL "https://api.github.com/repos/$REPO/git/refs/tags/$PKG_VERSION" -H "Authorization: Bearer $GITHUB_TOKEN" 2>/dev/null | jq '.object.url' | xargs curl -qfsSL -H "Authorization: Bearer $GITHUB_TOKEN" 2>/dev/null | jq -r '.committer.date' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export PKG_RELEASED="$PKG_RELEASED"
else
   PKG_VERSION="$(echo $RELEASE_METADATA | jq -r '.tag_name' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export PKG_VERSION="$PKG_VERSION"
   PKG_RELEASED="$(echo $RELEASE_METADATA | jq -r '.published_at' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export PKG_RELEASED="$PKG_RELEASED"
fi
REPO_URL="$(echo $REPO_METADATA | jq -r '.html_url' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export REPO_URL="$REPO_URL"
SIZE="$(echo $PKG_METADATA | jq -r '.size' | awk '{printf "%.2f MB\n", $1 / (1024 * 1024)}' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export SIZE="$SIZE"
BSUM="$(echo "$B3_SUMS" | grep -i "aarch64_arm64_v8a_Android/$BIN$" | awk '{print $1}' | sort  -u | head -n 1 | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export BSUM="$BSUM"
SHA="$(echo "$SHA256_SUMS" | grep -i "aarch64_arm64_v8a_Android/$BIN$" | awk '{print $1}' | sort  -u | head -n 1 | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export SHA="$SHA"
SOURCE_URL="$(echo $PKG_METADATA | jq -r '.download_url' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export SOURCE_URL="$SOURCE_URL"
STARS="$(echo $REPO_METADATA | jq -r '.stargazers_count' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export STARS="$STARS"
TOPICS="$(echo "$REPO_METADATA" | jq -c -r '.topics' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export TOPICS="$TOPICS"

#Print for sanity
echo -e "\n\n"
echo -e "[+] Name: $NAME"
echo -e "[+] Description: $DESCRIPTION"
echo -e "[+] Author: $AUTHOR"
echo -e "[+] Repo: $REPO_URL"
echo -e "[+] Stars: $STARS⭐"
echo -e "[+] Version: $PKG_VERSION"
echo -e "[+] Updated On: $PKG_RELEASED"
echo -e "[+] Size: $SIZE"
echo -e "[+] B3-SUM: $BSUM"
echo -e "[+] SHA-SUM: $SHA"
echo -e "[+] Source: $SOURCE_URL"
echo -e "[+] Topics: $TOPICS"
echo -e "[+] Language: $LANGUAGE"
echo -e "[+] License: $LICENSE"
echo -e "[+] Last Commit: $LAST_UPDATED"
echo -e "\n\n"
#EOF

#Sanity Checks for updater
if [[ -n "$GITHUB_WORKSPACE" ]]; then
   # Run
   bash <(curl -qfsSL "https://raw.githubusercontent.com/metis-os/hysp-pkgs/main/.github/scripts/pkg_metaupdater_aarch64_arm64_v8a_Android.sh")
fi
#EOF
