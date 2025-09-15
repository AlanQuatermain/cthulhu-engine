#!/usr/bin/env bash
set -euo pipefail

# Generate DocC documentation into the 'Documentary' folder at repo root.
# Requires swift-docc-plugin (declared in Package.swift).
#
# Usage:
#   ./Scripts/generate-docs.sh [--target <TargetName>] [--out <OutputDir>] [--static-hosting [<base-path>]]
#
# Examples:
#   ./Scripts/generate-docs.sh
#   ./Scripts/generate-docs.sh --target CthulhuEngine --out ./Documentary
#   ./Scripts/generate-docs.sh --static-hosting CthulhuEngine    # for GitHub Pages

ROOT_DIR=$(cd "$(dirname "$0")"/.. && pwd)
TARGET="CthulhuEngine"
OUT_DIR="$ROOT_DIR/Documents"
STATIC_HOSTING=0
BASE_PATH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET="${2:?missing target name}"; shift 2 ;;
    --out)
      OUT_DIR="${2:?missing output dir}"; shift 2 ;;
    --static-hosting)
      STATIC_HOSTING=1
      # Optional base-path may follow
      if [[ ${2:-} != "" && ${2:-} != --* ]]; then
        BASE_PATH="$2"; shift 2
      else
        shift 1
      fi ;;
    -h|--help)
      cat << EOF
Usage: $0 [--target <TargetName>] [--out <OutputDir>] [--static-hosting [<base-path>]]
EOF
      exit 0 ;;
    *)
      echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

cmd=(swift package --allow-writing-to-directory "$OUT_DIR" generate-documentation --target "$TARGET" --output-path "$OUT_DIR")

if [[ $STATIC_HOSTING -eq 1 ]]; then
  cmd+=(--transform-for-static-hosting)
  if [[ -n "$BASE_PATH" ]]; then
    cmd+=(--hosting-base-path "$BASE_PATH")
  fi
fi

"${cmd[@]}"

echo "Documentation generated at $OUT_DIR"
