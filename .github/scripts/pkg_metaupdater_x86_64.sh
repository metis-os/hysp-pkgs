#!/usr/bin/env bash

##Usage: 
# Actions: BIN="$BIN" REPO="$REPO" SOURCE_BIN="Azathothas/Toolpacks" bash "$GITHUB_WORKSPACE/main/.github/scripts/pkg_metafetcher_x86_64.sh"
# bash "$GITHUB_WORKSPACE/main/.github/scripts/pkg_metaupdater_x86_64.sh"
# General: BIN="$BIN" REPO="$REPO" SOURCE_BIN="Azathothas/Toolpacks" bash <(curl -qfsSL "https://raw.githubusercontent.com/metis-os/hysp-pkgs/main/.github/scripts/pkg_metafetcher_x86_64.sh")
# bash <(curl -qfsSL "https://raw.githubusercontent.com/metis-os/hysp-pkgs/main/.github/scripts/pkg_metaupdater_x86_64.sh")

#Deps: env exported
# moreutils (sponge) installed
# This works,, but for some reason numbers are blanked
#envsubst < "$GITHUB_WORKSPACE/main/data/x86_64/eget.toml"
#awk -v STARS="$STARS" '/stars/{gsub(/\$STARS/, STARS)}1' "$GITHUB_WORKSPACE/main/data/x86_64/eget.toml"
#This also works:
# awk -v BIN="$BIN" -v DESCRIPTION="$DESCRIPTION" -v AUTHOR="$AUTHOR" -v REPO_URL="$REPO_URL" -v STARS="$STARS" \
#     -v PKG_VERSION="$PKG_VERSION" -v PKG_RELEASED="$PKG_RELEASED" -v SIZE="$SIZE" -v SHA="$SHA" \
#     -v SOURCE="$SOURCE" -v LANGUAGE="$LANGUAGE" -v LICENSE="$LICENSE" -v TOPICS="$TOPICS" \
#     '{gsub(/\$BIN/, BIN); gsub(/\$DESCRIPTION/, DESCRIPTION); gsub(/\$AUTHOR/, AUTHOR); gsub(/\$REPO_URL/, REPO_URL); \
#     gsub(/\$STARS/, STARS); gsub(/\$PKG_VERSION/, PKG_VERSION); gsub(/\$PKG_RELEASED/, PKG_RELEASED); \
#     gsub(/\$SIZE/, SIZE); gsub(/\$SHA/, SHA); gsub(/\$SOURCE/, SOURCE); gsub(/\$LANGUAGE/, LANGUAGE); \
#     gsub(/\$LICENSE/, LICENSE); gsub(/\$TOPICS/, TOPICS); print}'
awk -v BIN="$BIN" -v DESCRIPTION="$DESCRIPTION" -v AUTHOR="$AUTHOR" -v REPO_URL="$REPO_URL" -v STARS="$STARS" -v PKG_VERSION="$PKG_VERSION" -v PKG_RELEASED="$PKG_RELEASED" -v SIZE="$SIZE" -v SHA="$SHA" -v SOURCE_URL="$SOURCE_URL" -v LANGUAGE="$LANGUAGE" -v LICENSE="$LICENSE" -v TOPICS="$TOPICS" '{gsub(/name = .*/, "name = \"" BIN "\""); \
      gsub(/description = .*/, "description = \"" DESCRIPTION "\""); \
      gsub(/author = .*/, "author = \"" AUTHOR "\""); \
      gsub(/repo = .*/, "repo = \"" REPO_URL "\""); \
      gsub(/stars = .*/, "stars = \"" STARS "\""); \
      gsub(/version = .*/, "version = \"" PKG_VERSION "\""); \
      gsub(/updated = .*/, "updated = \"" PKG_RELEASED "\""); \
      gsub(/size = .*/, "size = \"" SIZE "\""); \
      gsub(/sha = .*/, "sha = \"" SHA "\""); \
      gsub(/source = .*/, "source = \"" SOURCE_URL "\""); \
      gsub(/language = .*/, "language = \"" LANGUAGE "\""); \
      gsub(/license = .*/, "license = \"" LICENSE "\""); \
      gsub(/url = .*/, "source = \"" SOURCE_URL "\""); \
      gsub(/keywords = .*/, "keywords = " TOPICS); \
      print }' "$GITHUB_WORKSPACE/main/data/x86_64/$BIN.toml" | envsubst | sponge "$GITHUB_WORKSPACE/main/data/x86_64/$BIN.toml"
# Sample Spec : https://github.com/metis-os/hysp-pkgs/blob/main/data/x86_64/SAMPLE_SPEC.toml
#EOF
