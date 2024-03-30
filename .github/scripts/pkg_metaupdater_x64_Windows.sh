#!/usr/bin/env bash

#Debug
#set -x

#Sanity Check
mkdir -p "$GITHUB_WORKSPACE/main/data/x64_Windows"
if [ ! -s "$GITHUB_WORKSPACE/main/data/x64_Windows/$BIN.toml" ]; then
   #Get the sample
   curl -qfsSL "https://raw.githubusercontent.com/metis-os/hysp-pkgs/main/data/SPEC/SAMPLE_SPEC_x64_Windows.toml" -o "$GITHUB_WORKSPACE/main/data/x64_Windows/$BIN.toml"
   chmod +xwr "$GITHUB_WORKSPACE/main/data/x64_Windows/$BIN.toml"
   dos2unix --quiet "$GITHUB_WORKSPACE/main/data/x64_Windows/$BIN.toml"
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
      print }' "$GITHUB_WORKSPACE/main/data/x64_Windows/$BIN.toml" | envsubst | sponge "$GITHUB_WORKSPACE/main/data/x64_Windows/$BIN.toml"
##Just In Case      
#awk -v STARS="$STARS" '/stars/{gsub(/\$STARS/, STARS)}1' "$GITHUB_WORKSPACE/main/data/x64_Windows/$BIN.toml" | sponge "$GITHUB_WORKSPACE/main/data/x64_Windows/$BIN.toml"
#Temp Fix:
sed '/^description = / s/.*"\(.*\)".*/description = "\1"/' -i "$GITHUB_WORKSPACE/main/data/x64_Windows/$BIN.toml"
#Print
echo -e "\n [+] $GITHUB_WORKSPACE/main/data/x64_Windows/$BIN.toml\n" && cat "$GITHUB_WORKSPACE/main/data/x64_Windows/$BIN.toml" && echo -e "\n"
#EOF
