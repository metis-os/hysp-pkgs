#!/usr/bin/env bash

##Debug
#set -x ; set +e

#-------------------------------------------------------#
##ENV
SYSTMP="$(dirname $(mktemp -u))" && export SYSTMP="$SYSTMP"
TMPDIR="$(mktemp -d)" && export TMPDIR="$TMPDIR" ; echo -e "\n[+] Using TEMP: $TMPDIR\n"
ulimit -S -s unlimited 2>/dev/null
ulimit -f unlimited 2>/dev/null
curl -qfsSL "https://bin.ajam.dev/aarch64_arm64_Linux/METADATA.json" | jq --arg BIN "$BIN" --arg REPO_URL "$REPO_URL" --arg WEB_URL "$WEB_URL" '.[] | select(.name == $BIN) | if .web_url == $WEB_URL then . else if .repo_url == $REPO_URL then . else empty end end' > "$TMPDIR/METADATA.json"
#-------------------------------------------------------#

if jq --exit-status . "$TMPDIR/METADATA.json" >/dev/null 2>&1; then
    #-------------------------------------------------------#
    ##Parse
    NAME="$(cat "$TMPDIR/METADATA.json" | jq -r '.name' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '[:space:]')" && export NAME="$NAME"
    REPO_URL="$(cat "$TMPDIR/METADATA.json" | jq -r '.repo_url' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export REPO_URL="$REPO_URL"
    SIZE="$(cat "$TMPDIR/METADATA.json" | jq -r '.size' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export SIZE="$SIZE"
    BSUM="$(cat "$TMPDIR/METADATA.json" | jq -r '.b3sum' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export BSUM="$BSUM"
    SHA="$(cat "$TMPDIR/METADATA.json" | jq -r '.sha256' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export SHA="$SHA"
    SOURCE_URL="$(cat "$TMPDIR/METADATA.json" | jq -r '.download_url' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export SOURCE_URL="$SOURCE_URL"
   #Git 
    if [[ "$REPO_URL" == https://github.com* ]]; then
       AUTHOR="$(cat "$TMPDIR/METADATA.json" | jq -r '.repo_author' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export AUTHOR="$AUTHOR"
       DESCRIPTION="$(cat "$TMPDIR/METADATA.json" | jq -r '.repo_info' | sed 's/`//g' | sed 's/^[ \t]*//;s/[ \t]*$//' | sed ':a;N;$!ba;s/\r\n//g; s/\n//g')" && export DESCRIPTION="$DESCRIPTION" 
       LANGUAGE="$(cat "$TMPDIR/METADATA.json" | jq -r '.repo_language' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export LANGUAGE="$LANGUAGE"
       LICENSE="$(cat "$TMPDIR/METADATA.json" | jq -r '.repo_license' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export LICENSE="$LICENSE"
       LAST_UPDATED="$(cat "$TMPDIR/METADATA.json" | jq -r '.repo_updated' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export LAST_UPDATED="$LAST_UPDATED"
       PKG_VERSION="$(cat "$TMPDIR/METADATA.json" | jq -r '.repo_version' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export PKG_VERSION="$PKG_VERSION"
       PKG_RELEASED="$(cat "$TMPDIR/METADATA.json" | jq -r '.repo_released' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export PKG_RELEASED="$PKG_RELEASED"
       STARS="$(cat "$TMPDIR/METADATA.json" | jq -r '.repo_stars' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export STARS="$STARS"
       TOPICS="$(cat "$TMPDIR/METADATA.json" | jq -c -r '.repo_topics // []' | sed 's/[][ ]*//g; s/^/["/; s/$/"]/; s/,/","/g')" && export TOPICS="$TOPICS"
    else
       DESCRIPTION="$(cat "$TMPDIR/METADATA.json" | jq -r '.description' | sed 's/`//g' | sed 's/^[ \t]*//;s/[ \t]*$//' | sed ':a;N;$!ba;s/\r\n//g; s/\n//g')" && export DESCRIPTION="$DESCRIPTION" 
       LAST_UPDATED="$(cat "$TMPDIR/METADATA.json" | jq -r '.build_date' | sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//')" && export LAST_UPDATED="$LAST_UPDATED"
       TOPICS="[\"\"]" && export TOPICS="$TOPICS"
    fi
    #-------------------------------------------------------#
    
    #-------------------------------------------------------#
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
    #-------------------------------------------------------#
    
    #-------------------------------------------------------#
    #Sanity Checks for updater
    if [[ -n "$GITHUB_WORKSPACE" ]]; then
       # Run
       bash <(curl -qfsSL "https://raw.githubusercontent.com/metis-os/hysp-pkgs/main/.github/scripts/pkg_metaupdater_aarch64_arm64.sh")
    fi
    #-------------------------------------------------------#
fi
