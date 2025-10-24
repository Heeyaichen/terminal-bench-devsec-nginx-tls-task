#!/usr/bin/env bash
set -euo pipefail

# Install test dependencies quietly
python3 -m pip install -r requirements.txt >/dev/null 2>&1

# Execute the test file and propagate the exit code
python3 -m pytest -q tests/test_outputs.py