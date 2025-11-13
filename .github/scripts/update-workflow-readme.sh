#!/bin/bash

set -e

WORKFLOW_FILE="$1"

if [ -z "${WORKFLOW_FILE}" ]; then
    echo "Usage: $0 <workflow-file>" >&2
    echo "Example: $0 .github/workflows/shared-kernel-builder.yml" >&2
    exit 1
fi

README_FILE="README.md"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
EXTRACT_SCRIPT="${SCRIPT_DIR}/extract-workflow-params.sh"

if [ ! -f "${README_FILE}" ]; then
    echo "Error: README file not found: ${README_FILE}" >&2
    exit 1
fi

if [ ! -x "${EXTRACT_SCRIPT}" ]; then
    echo "Error: Extract script not found or not executable: ${EXTRACT_SCRIPT}" >&2
    exit 1
fi

# Generate new inputs/outputs section
NEW_CONTENT="$("${EXTRACT_SCRIPT}" "${WORKFLOW_FILE}")"

# Create temporary file for the updated README
TEMP_FILE="$(mktemp)"
trap 'rm -f "${TEMP_FILE}"' EXIT

# Process the README file
awk -v new_content="\n${NEW_CONTENT}\n" '
    /^<!-- start customizing:'"$(basename "${WORKFLOW_FILE}")"' -->$/ {
        in_customizing = 1
        print
        print new_content
        next
    }
    /^<!-- end customizing -->$/ && in_customizing {
        in_customizing = 0
    }
    !in_customizing {
        print
    }
' "${README_FILE}" > "${TEMP_FILE}"

# Replace original file with updated content
mv "${TEMP_FILE}" "${README_FILE}"

echo "Successfully updated ${README_FILE}"
