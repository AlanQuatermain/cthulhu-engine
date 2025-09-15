#!/usr/bin/env bash
set -euo pipefail

# Generate DocC documentation into the 'Documentary' folder at repo root.
# Requires swift-docc-plugin (declared in Package.swift).

ROOT_DIR=$(cd "$(dirname "$0")"/.. && pwd)
OUT_DIR="$ROOT_DIR/Documentary"

swift package --allow-writing-to-directory "$OUT_DIR" \
  generate-documentation \
  --target CthulhuEngine \
  --output-path "$OUT_DIR" \
  --transform-for-static-hosting \
  --hosting-base-path CthulhuEngine

echo "Documentation generated at $OUT_DIR"

