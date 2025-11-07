#!/bin/bash

YQ="$(which yq)"
WORKFLOW_FILE="$1"

# Function to calculate max length for a column
calc_max_width() {
    local max=0
    while IFS= read -r line; do
        local len="${#line}"
        [ "${len}" -gt "${max}" ] && max="${len}"
    done
    echo "${max}"
}

# Generate inputs table data - extract name, type, required, description, and default separately
mapfile -t input_names < <(${YQ} eval '.on.workflow_call.inputs | keys | .[]' "${WORKFLOW_FILE}")

inputs_data=""
for name in "${input_names[@]}"; do
    type=$(${YQ} eval ".on.workflow_call.inputs.${name}.type // \"string\"" "${WORKFLOW_FILE}")
    required=$(${YQ} eval ".on.workflow_call.inputs.${name}.required // \"false\"" "${WORKFLOW_FILE}")
    description=$(${YQ} eval ".on.workflow_call.inputs.${name}.description // \"\"" "${WORKFLOW_FILE}")
    default=$(${YQ} eval ".on.workflow_call.inputs.${name}.default // \"\"" "${WORKFLOW_FILE}")

    # Clean up multiline descriptions
    description=$(echo "${description}" | tr '\n' ' ' | sed 's/  */ /g' | sed 's/^ //;s/ $//')

    if [ -n "${default}" ]; then
        full_desc="${description} Default: '${default}'."
    else
        full_desc="${description}"
    fi

    inputs_data+="${name}|${type}|${required}|${full_desc}"$'\n'
done

# Calculate column widths for inputs
name_width=$(echo "${inputs_data}" | cut -d'|' -f1 | calc_max_width)
[ "${name_width}" -lt 4 ] && name_width=4

type_width=$(echo "${inputs_data}" | cut -d'|' -f2 | calc_max_width)
[ "${type_width}" -lt 4 ] && type_width=4

req_width=$(echo "${inputs_data}" | cut -d'|' -f3 | calc_max_width)
[ "${req_width}" -lt 8 ] && req_width=8

desc_width=$(echo "${inputs_data}" | cut -d'|' -f4 | calc_max_width)
[ "${desc_width}" -lt 11 ] && desc_width=11

# Generate outputs table data - extract name, type (always "string"), and description
mapfile -t output_names < <(${YQ} eval '.on.workflow_call.outputs | keys | .[]' "${WORKFLOW_FILE}")

outputs_data=""
for name in "${output_names[@]}"; do
    description=$(${YQ} eval ".on.workflow_call.outputs.${name}.description // \"\"" "${WORKFLOW_FILE}")
    type="string"

    # Clean up multiline descriptions
    description=$(echo "${description}" | tr '\n' ' ' | sed 's/  */ /g' | sed 's/^ //;s/ $//')

    outputs_data+="${name}|${type}|${description}"$'\n'
done

# Calculate column widths for outputs
out_name_width=$(echo "${outputs_data}" | cut -d'|' -f1 | calc_max_width)
[ "${out_name_width}" -lt 4 ] && out_name_width=4

out_type_width=$(echo "${outputs_data}" | cut -d'|' -f2 | calc_max_width)
[ "${out_type_width}" -lt 4 ] && out_type_width=4

out_desc_width=$(echo "${outputs_data}" | cut -d'|' -f3 | calc_max_width)
[ "${out_desc_width}" -lt 11 ] && out_desc_width=11

# Print inputs section
echo "#### inputs"
echo ""
echo "The following inputs are available:"
echo ""

# Header - left, center, center, left alignment
printf "| %-${name_width}s | %${type_width}s | %${req_width}s | %-${desc_width}s |\n" "Name" "Type" "Required" "Description"
printf "| :%s | %s: | %s: | :%s |\n" \
    "$(printf '%*s' $((name_width-1)) '' | tr ' ' '-')" \
    "$(printf '%*s' $((type_width-1)) '' | tr ' ' '-')" \
    "$(printf '%*s' $((req_width-1)) '' | tr ' ' '-')" \
    "$(printf '%*s' $((desc_width-1)) '' | tr ' ' '-')"

# Data rows
while IFS='|' read -r name type req desc; do
    [ -z "${name}" ] && continue
    printf "| %-${name_width}s | %${type_width}s | %${req_width}s | %-${desc_width}s |\n" "${name}" "${type}" "${req}" "${desc}"
done <<< "${inputs_data}"

# Print outputs section
echo ""
echo "#### outputs"
echo ""
echo "The following outputs are available:"
echo ""

# Header - left, center, left alignment
printf "| %-${out_name_width}s | %${out_type_width}s | %-${out_desc_width}s |\n" "Name" "Type" "Description"
printf "| :%s | %s: | :%s |\n" \
    "$(printf '%*s' $((out_name_width-1)) '' | tr ' ' '-')" \
    "$(printf '%*s' $((out_type_width-1)) '' | tr ' ' '-')" \
    "$(printf '%*s' $((out_desc_width-1)) '' | tr ' ' '-')"

# Data rows
while IFS='|' read -r name type desc; do
    [ -z "${name}" ] && continue
    printf "| %-${out_name_width}s | %${out_type_width}s | %-${out_desc_width}s |\n" "${name}" "${type}" "${desc}"
done <<< "${outputs_data}"
