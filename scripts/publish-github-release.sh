#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
REPO="${_GITHUB_REPO:-zmcgill7/Solitaire}"
TAG="${TAG_NAME:-}"

if [[ -z "$TAG" ]]; then
  TAG="$(git -C "$ROOT_DIR" describe --tags --exact-match 2>/dev/null || true)"
fi

if [[ -z "$TAG" ]]; then
  echo "No release tag found. Run this from a tag-triggered Cloud Build or set TAG_NAME." >&2
  exit 1
fi

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "GITHUB_TOKEN is required to publish GitHub releases." >&2
  exit 1
fi

if [[ ! -d "$DIST_DIR" ]]; then
  echo "Missing dist directory: $DIST_DIR" >&2
  exit 1
fi

WINDOWS_INSTALLER="$ROOT_DIR/packaging/windows/Solitaire-Windows-x64-Setup.exe"
if [[ -f "$WINDOWS_INSTALLER" ]]; then
  cp "$WINDOWS_INSTALLER" "$DIST_DIR/"
fi

api() {
  local method="$1"
  local url="$2"
  local data="${3:-}"
  if [[ -n "$data" ]]; then
    curl -fsS -X "$method" \
      -H "Authorization: Bearer $GITHUB_TOKEN" \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      -d "$data" \
      "$url"
  else
    curl -fsS -X "$method" \
      -H "Authorization: Bearer $GITHUB_TOKEN" \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "$url"
  fi
}

release_json="$(api GET "https://api.github.com/repos/$REPO/releases/tags/$TAG" || true)"

if [[ -z "$release_json" ]]; then
  release_json="$(api POST "https://api.github.com/repos/$REPO/releases" "{\"tag_name\":\"$TAG\",\"name\":\"Solitaire $TAG\",\"draft\":false,\"prerelease\":false}")"
fi

upload_url="$(printf '%s' "$release_json" | jq -r '.upload_url' | sed 's/{.*//')"

if [[ -z "$upload_url" ]]; then
  echo "Could not resolve GitHub release upload URL." >&2
  exit 1
fi

for artifact in "$DIST_DIR"/*; do
  [[ -f "$artifact" ]] || continue
  name="$(basename "$artifact")"
  content_type="application/octet-stream"
  case "$name" in
    *.zip) content_type="application/zip" ;;
    *.AppImage) content_type="application/octet-stream" ;;
  esac

  asset_id="$(api GET "https://api.github.com/repos/$REPO/releases/tags/$TAG" \
    | jq -r --arg name "$name" '.assets[]? | select(.name == $name) | .id' \
    | head -n 1 || true)"

  if [[ -n "$asset_id" ]]; then
    api DELETE "https://api.github.com/repos/$REPO/releases/assets/$asset_id" >/dev/null
  fi

  curl -fsS -X POST \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -H "Content-Type: $content_type" \
    --data-binary @"$artifact" \
    "$upload_url?name=$name" >/dev/null

  echo "Uploaded $name to $REPO release $TAG"
done
