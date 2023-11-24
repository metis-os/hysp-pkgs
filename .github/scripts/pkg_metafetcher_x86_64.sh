#!/usr/bin/env bash

###ENV (Exported or passed Inline)
# #Example:
# export GITHUB_TOKEN="$UNDERPRIVILEGED_READ_ONLY_GH_TOKEN" #Required to get around github api rate limits
# export BIN="eget" #placeholder for [bin] name = "$BIN", must be same in source_bin
# export REPO="zyedidia/eget" #NOT URL, Only $AUTHOR/$REPO_NAME
# export SOURCE_BIN="Azathothas/Toolpacks" #Full: https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/$BIN

##Usage: 
# Actions: BIN="$BIN" REPO="$REPO" SOURCE_BIN="Azathothas/Toolpacks" bash "$GITHUB_WORKSPACE/main/.github/scripts/pkg_metafetcher_x86_64.sh"
# General: BIN="$BIN" REPO="$REPO" SOURCE_BIN="Azathothas/Toolpacks" bash <(curl -qfsSL "https://raw.githubusercontent.com/metis-os/hysp-pkgs/main/.github/scripts/pkg_metafetcher_x86_64.sh")
#List all available $BIN: curl -qfsSL "https://api.github.com/repos/Azathothas/Toolpacks/contents/x86_64" | jq -r '.[].name' | grep -iv '.md$' | sort -u 

#Sanity Checks for token
if [[ -z "$GITHUB_TOKEN" ]]; then
   # With Token = 5000 req/minute (80 req/minute)
   # No Token = 60 request/hr
   echo -e "\n[-] GITHUB_TOKEN is NOT Exported"
   echo -e "Export it to avoid ratelimits"
   exit 1
fi

#Fetch raw json
PKG_METADATA="$(curl -qfsSL "https://api.github.com/repos/$SOURCE_BIN/contents/x86_64/$BIN" -H "Authorization: Bearer $GITHUB_TOKEN")" && export PKG_METADATA="$PKG_METADATA"
REPO_METADATA="$(curl -qfsSL "https://api.github.com/repos/$REPO" -H "Authorization: Bearer $GITHUB_TOKEN")" && export REPO_METADATA="$REPO_METADATA"
RELEASE_METADATA="$(curl -qfsSL "https://api.github.com/repos/$REPO/releases/latest" -H "Authorization: Bearer $GITHUB_TOKEN")" && export RELEASE_METADATA="$RELEASE_METADATA"
SHA256_SUMS="$(curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/README.md" -H "Authorization: Bearer $GITHUB_TOKEN" | grep -A 9999999999999 "SHA256SUM" 2>/dev/null | awk '/Sizes/{exit} {print}' 2>/dev/null | sed 's/^[ \t]*//;s/[ \t]*$//')" && export SHA256_SUMS="$SHA256_SUMS"
#Parse
NAME="$(echo $REPO_METADATA | jq -r '.name' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export NAME="$NAME"
AUTHOR="$(echo $REPO_METADATA | jq -r '.owner.login' | sed 's/"//g' |  sed 's/^[ \t]*//;s/[ \t]*$//')" && export AUTHOR="$AUTHOR"
DESCRIPTION="$(echo $REPO_METADATA | jq -r '.description' | sed 's/^[ \t]*//;s/[ \t]*$//' | sed ':a;N;$!ba;s/\r\n//g; s/\n//g')" && export DESCRIPTION="$DESCRIPTION"
LANGUAGE="$(echo $REPO_METADATA | jq -r '.language' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export LANGUAGE="$LANGUAGE"
LICENSE="$(echo $REPO_METADATA | jq -r '.license.name' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export LICENSE="$LICENSE"
LAST_UPDATED="$(echo $REPO_METADATA | jq -r '.pushed_at' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export LAST_UPDATED="$LAST_UPDATED"
PKG_VERSION="$(echo $RELEASE_METADATA | jq -r '.tag_name' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export PKG_VERSION="$PKG_VERSION"
PKG_RELEASED="$(echo $RELEASE_METADATA | jq -r '.published_at' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export PKG_RELEASED="$PKG_RELEASED"
REPO_URL="$(echo $REPO_METADATA | jq -r '.html_url' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export REPO_URL="$REPO_URL"
SIZE="$(echo $PKG_METADATA | jq -r '.size' | awk '{printf "%.2f MB\n", $1 / (1024 * 1024)}' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export SIZE="$SIZE"
SHA="$(echo "$SHA256_SUMS" | grep -i "x86_64/$BIN$" | awk '{print $1}' | sort  -u | head -n 1 | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export SHA="$SHA"
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
   bash <(curl -qfsSL "https://raw.githubusercontent.com/metis-os/hysp-pkgs/main/.github/scripts/pkg_metaupdater_x86_64.sh")
fi
#EOF
