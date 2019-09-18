#!/bin/bash
set -euo pipefail
PUBLISH_BRANCH="master"
PUBLISH_DIR="public"

git config --global user.email "action@github.com"
git config --global user.name "GitHub Action"

HUGO_ENV=production hugo -v --gc --minify --cleanDestinationDir

TMPDIR="$(mktemp -d)"
git clone --depth 1 -b "${PUBLISH_BRANCH}" "https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" "${TMPDIR}"
cd "${TMPDIR}"
git checkout -b "update/${GITHUB_SHA}"

rsync -va --delete --exclude '.gitignore' --exclude '.git' --exclude '.circleci' --exclude 'CNAME' "${GITHUB_WORKSPACE}/${PUBLISH_DIR}" ./
git add -A
git commit -m "GitHub Action Update ${GITHUB_SHA}" --allow-empty
hub pull-request -p -b "${PUBLISH_BRANCH}" --no-edit
