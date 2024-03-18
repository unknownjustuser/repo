#!/usr/bin/env bash
# shellcheck disable=SC2035

# Script name: update-db.sh
# Description: Script for rebuilding the database for archfiery.
# Contributors: MikuX-Dev

# Set with the flags "-e", "-u","-o pipefail" cause the script to fail
# if certain things happen, which is a good thing.  Otherwise, we can
# get hidden bugs that are hard to discover.
set -euo pipefail

# echo "#################"
# echo "Changing the dir."
# echo "#################"
# cd x86_64/

echo "###########################"
echo "Building the repo database."
echo "###########################"

## Arch: x86_64
if [[ ! -f "archfiery_repo.db" ]]; then
  rm -f *.db
fi

if [[ ! -f "archfiery_repo.db.sig" ]]; then
  rm -f *.db.sig
fi

if [[ ! -f "archfiery_repo.db.tar.gz" ]]; then
  rm -f *.db.tar.gz
fi

if [[ ! -f "archfiery_repo.db.tar.gz.sig" ]]; then
  rm -f *.db.tar.gz.sig
fi

if [[ ! -f "archfiery_repo.files" ]]; then
  rm -f *.files
fi

if [[ ! -f "archfiery_repo.files.sig" ]]; then
  rm -f *.files.sig
fi

if [[ ! -f "archfiery_repo.files.tar.gz" ]]; then
  rm -f *.files.tar.gz
fi

if [[ ! -f "archfiery_repo.files.tar.gz.sig" ]]; then
  rm -f *.files.tar.gz.sig
fi

if [[ ! -f "*.old" ]]; then
  rm -f *.old
fi

echo "###################################"
echo "Building for architecture 'x86_64'."
echo "###################################"

## repo-add
## -s: signs the packages
## -n: only add new packages not already in database
## -R: remove old package files when updating their entry

if [[ ! -f "*.pkg.tar.zst" ]]; then
  repo-add --verify --sign archfiery_repo.db.tar.gz *.pkg.tar.zst
fi

if [[ ! -f "*.pkg.tar.xz" ]]; then
  repo-add --verify --sign archfiery_repo.db.tar.gz *.pkg.tar.xz
fi

if [[ ! -f "*.pkg.tar.gz" ]]; then
  repo-add --verify --sign archfiery_repo.db.tar.gz *.pkg.tar.gz
fi

# Removing the symlinks.
echo "######################"
echo "Removing the symlinks."
echo "######################"

files=(
  "archfiery_repo.db"
  "archfiery_repo.db.sig"
  "archfiery_repo.files"
  "archfiery_repo.files.sig"
)

for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    echo "Removing $file"
    rm "$file"
  fi
done

# Renaming the tar.gz files without the extension.
echo "################################################"
echo "Renaming the tar.gz files without the extension."
echo "################################################"

files=(
  "archfiery_repo.db.tar.gz:archfiery_repo.db"
  "archfiery_repo.db.tar.gz.sig:archfiery_repo.db.sig"
  "archfiery_repo.files.tar.gz:archfiery_repo.files"
  "archfiery_repo.files.tar.gz.sig:archfiery_repo.files.sig"
)

for file in "${files[@]}"; do
  old_name=$(echo "$file" | cut -d: -f1)
  new_name=$(echo "$file" | cut -d: -f2)

  if [ -f "$old_name" ]; then
    echo "Renaming $old_name to $new_name"
    mv "$old_name" "$new_name"
  fi
done

echo "#######################################"
echo "Packages in the repo have been updated!"
echo "#######################################"
