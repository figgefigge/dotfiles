#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

ansible-galaxy collection install -r ansible/requirements.yml

ansible-playbook \
  -i ansible/inventory.ini \
  ansible/site.yml \
  --ask-become-pass
