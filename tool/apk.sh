#!/usr/bin/env bash
# Build the release APK remotely with rflutter and name it openjot-<version>.apk.
#
#   tool/apk.sh                     build, then copy to dist/openjot-<version>.apk
#   tool/apk.sh --split-per-abi     also copy one APK per ABI
#   tool/apk.sh --no-build          only copy the APK already in build/
#
# Flutter expects build/app/outputs/flutter-apk/app-release.apk, so the Gradle
# output keeps that name. The copy in dist/ carries the release name.
set -euo pipefail

cd "$(dirname "$0")/.."

mode="release"
splits=0
build=1
for arg in "$@"; do
  case "$arg" in
    --split-per-abi) splits=1 ;;
    --no-build) build=0 ;;
    --debug) mode="debug" ;;
    -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

version=$(sed -n 's/^version:[[:space:]]*\([0-9][0-9.]*\).*/\1/p' pubspec.yaml)
if [ -z "$version" ]; then
  echo "cannot read the version from pubspec.yaml" >&2
  exit 1
fi

if [ "$build" = 1 ]; then
  args=(build apk "--$mode")
  [ "$splits" = 1 ] && args+=(--split-per-abi)
  rflutter "${args[@]}"
fi

out="build/app/outputs/flutter-apk"
mkdir -p dist

if [ "$splits" = 1 ]; then
  for abi in armeabi-v7a arm64-v8a x86_64; do
    src="$out/app-$abi-$mode.apk"
    [ -f "$src" ] || continue
    dst="dist/openjot-$version-$abi.apk"
    cp "$src" "$dst"
    echo "$dst"
  done
else
  src="$out/app-$mode.apk"
  if [ ! -f "$src" ]; then
    echo "no APK at $src; run without --no-build" >&2
    exit 1
  fi
  dst="dist/openjot-$version.apk"
  cp "$src" "$dst"
  echo "$dst"
fi