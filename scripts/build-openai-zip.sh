#!/usr/bin/env bash
# Builds the ZIP that OpenAI's plugin portal (platform.openai.com/plugins) takes for review.
# Only the files an OpenAI plugin uses go in, so nothing meant for Claude Code, Gemini CLI or the
# MCP Registry is scanned with it. Run from anywhere: bash scripts/build-openai-zip.sh
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

for tool in jq zip; do
  command -v "$tool" >/dev/null || { echo "$tool is needed to build the ZIP" >&2; exit 1; }
done

manifest=plugin.json
openai='.extensions["com.openai"]'
fail=0
need() {
  if ! jq -e "$1" "$manifest" >/dev/null; then
    echo "plugin.json: $2" >&2
    fail=1
  fi
}

need "$openai.interface.displayName | length <= 30" 'interface.displayName is over 30 characters'
need "$openai.interface.shortDescription | length <= 30" 'interface.shortDescription is over 30 characters'
need "$openai.interface.longDescription | length <= 4000" 'interface.longDescription is over 4,000 characters'
need "[$openai.interface.defaultPrompt[] | length <= 128] | all" 'a defaultPrompt is over 128 characters'
need "[$openai.interface.capabilities[] | length <= 120] | all" 'a capability is over 120 characters'
need "$openai.review.test_cases.positive | length == 5" 'review.test_cases.positive needs exactly 5 cases'
need "$openai.review.test_cases.negative | length == 3" 'review.test_cases.negative needs exactly 3 cases'
need "$openai.review.demo_recording_url | type == \"string\" and startswith(\"https://\")" \
  'review.demo_recording_url is missing: record the five positive test cases in ChatGPT and add the video link'
need '.version | test("^[0-9]+\\.[0-9]+\\.[0-9]+$")' 'version is not semver'
for key in websiteURL supportURL privacyPolicyURL termsOfServiceURL; do
  need "$openai.interface.$key | startswith(\"https://\")" "interface.$key must be an https URL"
done
# The reviewer opens every listing URL, and a redirect to an unrelated page reads as a broken link.
if command -v curl >/dev/null; then
  for key in websiteURL supportURL privacyPolicyURL termsOfServiceURL; do
    url="$(jq -r "$openai.interface.$key" "$manifest")"
    status="$(curl -s -o /dev/null -w '%{http_code}' "$url" || true)"
    if [ "$status" != 200 ]; then
      echo "interface.$key ($url) answers $status, not 200" >&2
      fail=1
    fi
  done
fi
jq -e '[.mcpServers[] | .headers // {} | length == 0] | all' mcp.json >/dev/null || { echo 'mcp.json: headers must be empty' >&2; fail=1; }
[ "$fail" -eq 0 ] || exit 1

version="$(jq -r .version "$manifest")"
out="$root/dist/forminal-openai-$version.zip"
mkdir -p "$root/dist"
rm -f "$out"
zip -q -r -X "$out" plugin.json mcp.json skills assets -x '.*' -x '*/.*'
echo "Built $out"
unzip -l "$out"
