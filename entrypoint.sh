#!/bin/bash
set -eu # Increase bash strictness

if [[ -n "${GITHUB_WORKSPACE}" ]]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

if [[ "$(which pylint)" == "" ]]; then
  echo "[action-pylint] Installing pylint package..."
  python -m pip install --upgrade pylint
fi
echo "[action-pylint] pylint version:"
pylint --version

echo "[action-pylint] Checking python code with the pylint linter and reviewdog..."
exit_val="0"
pylint --rcfile ${INPUT_PYLINT_RC} -s n ${INPUT_WORKDIR}

if [[ "${exit_val}" -ne '0' ]]; then
  exit 1
fi
