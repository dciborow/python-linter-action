#!/bin/bash
set -eu # Increase bash strictness

if [[ -n "${GITHUB_WORKSPACE}" ]]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

export REVIEWDOG_VERSION=v0.13.0

echo "[action-pylint] Installing reviewdog..."
wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /tmp "${REVIEWDOG_VERSION}"

if [[ "$(which pylint)" == "" ]]; then
  echo "[action-pylint] Installing pylint package..."
  python -m pip install --upgrade pylint
fi
echo "[action-pylint] pylint version:"
pylint --version

echo "[action-pylint] Checking python code with the pylint linter and reviewdog..."
exit_val="0"
pylint --rcfile ${INPUT_PYLINT_RC} -s n ${INPUT_WORKDIR} 2>&1

echo "[action-pylint] Clean up reviewdog..."
rm /tmp/reviewdog

if [[ "${exit_val}" -ne '0' ]]; then
  exit 1
fi
