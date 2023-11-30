#!/usr/bin/env bash

#Debug
#set -x

##Usage: 
# Actions: BIN="$BIN" REPO="$REPO" SOURCE_BIN="Azathothas/Toolpacks" bash "$GITHUB_WORKSPACE/main/.github/scripts/pkg_metafetcher_arm64_v8a_Android.sh"
# bash "$GITHUB_WORKSPACE/main/.github/scripts/pkg_metaupdater_arm64_v8a_Android.sh"
# General: BIN="$BIN" REPO="$REPO" SOURCE_BIN="Azathothas/Toolpacks" bash <(curl -qfsSL "https://raw.githubusercontent.com/metis-os/hysp-pkgs/main/.github/scripts/pkg_metafetcher_arm64_v8a_Android.sh")
# bash <(curl -qfsSL "https://raw.githubusercontent.com/metis-os/hysp-pkgs/main/.github/scripts/pkg_metaupdater_arm64_v8a_Android.sh")

#Deps: env exported
# moreutils (sponge) installed
# This works
#envsubst < "$GITHUB_WORKSPACE/main/data/arm64_v8a_Android/eget.toml"
#awk -v STARS="$STARS" '/stars/{gsub(/\$STARS/, STARS)}1' "$GITHUB_WORKSPACE/main/data/arm64_v8a_Android/eget.toml"
#This also works:
# awk -v BIN="$BIN" -v DESCRIPTION="$DESCRIPTION" -v AUTHOR="$AUTHOR" -v REPO_URL="$REPO_URL" -v STARS="$STARS" \
#     -v PKG_VERSION="$PKG_VERSION" -v PKG_RELEASED="$PKG_RELEASED" -v SIZE="$SIZE" -v SHA="$SHA" \
#     -v SOURCE="$SOURCE" -v LANGUAGE="$LANGUAGE" -v LICENSE="$LICENSE" -v TOPICS="$TOPICS" \
#     '{gsub(/\$BIN/, BIN); gsub(/\$DESCRIPTION/, DESCRIPTION); gsub(/\$AUTHOR/, AUTHOR); gsub(/\$REPO_URL/, REPO_URL); \
#     gsub(/\$STARS/, STARS); gsub(/\$PKG_VERSION/, PKG_VERSION); gsub(/\$PKG_RELEASED/, PKG_RELEASED); \
#     gsub(/\$SIZE/, SIZE); gsub(/\$SHA/, SHA); gsub(/\$SOURCE/, SOURCE); gsub(/\$LANGUAGE/, LANGUAGE); \
#     gsub(/\$LICENSE/, LICENSE); gsub(/\$TOPICS/, TOPICS); print}'
# Cleanup
# unset BIN REPO SOURCE_BIN PKG_METADATA REPO_METADATA RELEASE_METADATA SOURCE_URL
# unset NAME AUTHOR DESCRIPTION LANGUAGE LICENSE LAST_UPDATED PKG_VERSION PKG_RELEASED REPO_URL SIZE SHA SOURCE_URL STARS TOPICS

#Sanity Check
mkdir -p "$GITHUB_WORKSPACE/main/data/arm64_v8a_Android"
if [ ! -s "$GITHUB_WORKSPACE/main/data/arm64_v8a_Android/$BIN.toml" ]; then
   #Get the sample
   curl -qfsSL "https://raw.githubusercontent.com/metis-os/hysp-pkgs/main/data/SPEC/SAMPLE_SPEC_arm64_v8a_Android.toml" -o "$GITHUB_WORKSPACE/main/data/arm64_v8a_Android/$BIN.toml"
   chmod +xwr "$GITHUB_WORKSPACE/main/data/arm64_v8a_Android/$BIN.toml"
   dos2unix --quiet "$GITHUB_WORKSPACE/main/data/arm64_v8a_Android/$BIN.toml"
fi

#Edit
awk -v BIN="$BIN" -v DESCRIPTION="$DESCRIPTION" -v AUTHOR="$AUTHOR" -v REPO_URL="$REPO_URL" -v STARS="$STARS" -v PKG_VERSION="$PKG_VERSION" -v PKG_RELEASED="$PKG_RELEASED" -v SIZE="$SIZE" -v BSUM="$BSUM" -v SHA="$SHA" -v SOURCE_URL="$SOURCE_URL" -v LANGUAGE="$LANGUAGE" -v LICENSE="$LICENSE" -v TOPICS="$TOPICS" '{gsub(/name = .*/, "name = \"" BIN "\""); \
      gsub(/description = .*/, "description = \"" DESCRIPTION "\""); \
      gsub(/author = .*/, "author = \"" AUTHOR "\""); \
      gsub(/repo = .*/, "repo = \"" REPO_URL "\""); \
      gsub(/stars = .*/, "stars = \"" STARS "\""); \
      gsub(/version = .*/, "version = \"" PKG_VERSION "\""); \
      gsub(/updated = .*/, "updated = \"" PKG_RELEASED "\""); \
      gsub(/size = .*/, "size = \"" SIZE "\""); \
      gsub(/bsum = .*/, "bsum = \"" BSUM "\""); \
      gsub(/sha = .*/, "sha = \"" SHA "\""); \
      gsub(/source = .*/, "source = \"" SOURCE_URL "\""); \
      gsub(/language = .*/, "language = \"" LANGUAGE "\""); \
      gsub(/license = .*/, "license = \"" LICENSE "\""); \
      gsub(/keywords = .*/, "keywords = " TOPICS); \
      print }' "$GITHUB_WORKSPACE/main/data/arm64_v8a_Android/$BIN.toml" | envsubst | sponge "$GITHUB_WORKSPACE/main/data/arm64_v8a_Android/$BIN.toml"
##Just In Case      
#awk -v STARS="$STARS" '/stars/{gsub(/\$STARS/, STARS)}1' "$GITHUB_WORKSPACE/main/data/arm64_v8a_Android/$BIN.toml" | sponge "$GITHUB_WORKSPACE/main/data/arm64_v8a_Android/$BIN.toml"
#Temp Fix:
sed '/^description = / s/.*"\(.*\)".*/description = "\1"/' -i "$GITHUB_WORKSPACE/main/data/arm64_v8a_Android/$BIN.toml"
#Print
echo -e "\n [+] $GITHUB_WORKSPACE/main/data/arm64_v8a_Android/$BIN.toml\n" && cat "$GITHUB_WORKSPACE/main/data/arm64_v8a_Android/$BIN.toml" && echo -e "\n" 
# Sample Spec : https://github.com/metis-os/hysp-pkgs/blob/main/SPEC
#EOF
