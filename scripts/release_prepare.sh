#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBSPEC_PATH="$ROOT_DIR/pubspec.yaml"

usage() {
  cat <<'EOF'
Usage:
  scripts/release_prepare.sh --version X.Y.Z --build N
  scripts/release_prepare.sh --bump patch
  scripts/release_prepare.sh --bump minor
  scripts/release_prepare.sh --bump major

Description:
  Updates pubspec.yaml "version: X.Y.Z+N" for release builds and prints
  ready-to-run commands for Android AAB and iOS build.

Options:
  --version X.Y.Z    Explicit semantic version.
  --build N          Explicit build number.
  --bump TYPE        Auto-bump version (patch|minor|major) and build +1.
  -h, --help         Show help.
EOF
}

if [[ ! -f "$PUBSPEC_PATH" ]]; then
  echo "pubspec.yaml not found at $PUBSPEC_PATH"
  exit 1
fi

CURRENT_LINE="$(grep -E '^version:\s*[0-9]+\.[0-9]+\.[0-9]+\+[0-9]+\s*$' "$PUBSPEC_PATH" || true)"
if [[ -z "$CURRENT_LINE" ]]; then
  echo "Unable to find a valid version line in pubspec.yaml (expected: version: X.Y.Z+N)"
  exit 1
fi

CURRENT_VERSION="${CURRENT_LINE#version: }"
CURRENT_SEMVER="${CURRENT_VERSION%%+*}"
CURRENT_BUILD="${CURRENT_VERSION##*+}"

TARGET_SEMVER=""
TARGET_BUILD=""
BUMP_TYPE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      TARGET_SEMVER="${2:-}"
      shift 2
      ;;
    --build)
      TARGET_BUILD="${2:-}"
      shift 2
      ;;
    --bump)
      BUMP_TYPE="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

if [[ -n "$BUMP_TYPE" && ( -n "$TARGET_SEMVER" || -n "$TARGET_BUILD" ) ]]; then
  echo "Use either --bump OR --version/--build, not both."
  exit 1
fi

if [[ -n "$BUMP_TYPE" ]]; then
  IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_SEMVER"
  case "$BUMP_TYPE" in
    patch)
      PATCH=$((PATCH + 1))
      ;;
    minor)
      MINOR=$((MINOR + 1))
      PATCH=0
      ;;
    major)
      MAJOR=$((MAJOR + 1))
      MINOR=0
      PATCH=0
      ;;
    *)
      echo "Invalid bump type: $BUMP_TYPE (allowed: patch|minor|major)"
      exit 1
      ;;
  esac
  TARGET_SEMVER="${MAJOR}.${MINOR}.${PATCH}"
  TARGET_BUILD="$((CURRENT_BUILD + 1))"
fi

if [[ -z "$TARGET_SEMVER" ]]; then
  TARGET_SEMVER="$CURRENT_SEMVER"
fi
if [[ -z "$TARGET_BUILD" ]]; then
  TARGET_BUILD="$CURRENT_BUILD"
fi

if ! [[ "$TARGET_SEMVER" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Invalid --version value: $TARGET_SEMVER (expected X.Y.Z)"
  exit 1
fi
if ! [[ "$TARGET_BUILD" =~ ^[0-9]+$ ]]; then
  echo "Invalid --build value: $TARGET_BUILD (expected integer)"
  exit 1
fi

NEW_VERSION_LINE="version: ${TARGET_SEMVER}+${TARGET_BUILD}"

awk -v newline="$NEW_VERSION_LINE" '
  BEGIN { changed = 0 }
  /^version:[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+\+[0-9]+[[:space:]]*$/ {
    print newline
    changed = 1
    next
  }
  { print }
  END {
    if (changed == 0) {
      exit 2
    }
  }
' "$PUBSPEC_PATH" > "${PUBSPEC_PATH}.tmp"

mv "${PUBSPEC_PATH}.tmp" "$PUBSPEC_PATH"

echo "Updated release version:"
echo "  from: $CURRENT_VERSION"
echo "    to: ${TARGET_SEMVER}+${TARGET_BUILD}"
echo
echo "Next commands:"
echo "  flutter pub get"
echo "  flutter build appbundle --release"
echo "  flutter build ipa --release"
echo
echo "Optional explicit build flags:"
echo "  flutter build appbundle --release --build-name $TARGET_SEMVER --build-number $TARGET_BUILD"
echo "  flutter build ipa --release --build-name $TARGET_SEMVER --build-number $TARGET_BUILD"
