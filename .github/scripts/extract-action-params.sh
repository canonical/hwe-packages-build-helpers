#!/bin/bash

YQ="$(which yq)"
ACTION_FILE="$1"

# Function to calculate max length for a column
calc_max_width() {
    local max=0
    while IFS= read -r line; do
        local len=${#line}
        [ "${len}" -gt "${max}" ] && max="${len}"
    done
    echo "${max}"
}

# Generate inputs table data - extract name, required, description, and default separately
mapfile -t input_names < <($YQ eval '.inputs | keys | .[]' "${ACTION_FILE}")

inputs_data=""
for name in "${input_names[@]}"; do
    required="$($YQ eval ".inputs.${name}.required // \"false\"" "${ACTION_FILE}")"
    description="$($YQ eval ".inputs.${name}.description // \"\"" "${ACTION_FILE}")"
    default="$($YQ eval ".inputs.${name}.default // \"\"" "${ACTION_FILE}")"

    if [ -n "${default}" ]; then
        full_desc="${description} Default: '${default}'."
    else
        full_desc="${description}"
    fi

    inputs_data+="${name}|${required}|${full_desc}"$'\n'
done

# Calculate column widths for inputs
name_width=$(echo "${inputs_data}" | cut -d'|' -f1 | calc_max_width)
[ "${name_width}" -lt 4 ] && name_width=4

req_width=$(echo "${inputs_data}" | cut -d'|' -f2 | calc_max_width)
[ "${req_width}" -lt 8 ] && req_width=8

desc_width=$(echo "${inputs_data}" | cut -d'|' -f3 | calc_max_width)
[ "${desc_width}" -lt 11 ] && desc_width=11

# Generate outputs table data - extract name, type (always "string"), and description
mapfile -t output_names < <($YQ eval '.outputs | keys | .[]' "${ACTION_FILE}")

outputs_data=""
for name in "${output_names[@]}"; do
    description=$($YQ eval ".outputs.${name}.description // \"\"" "${ACTION_FILE}")
    type="string"

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
echo "### inputs"
echo ""
echo "The following inputs are available:"
echo ""

# Header - left, right, left alignment
printf "| %-${name_width}s | %${req_width}s | %-${desc_width}s |\n" "Name" "Required" "Description"
printf "| :%s | %s: | :%s |\n" \
    "$(printf '%*s' $((name_width-1)) '' | tr ' ' '-')" \
    "$(printf '%*s' $((req_width-1)) '' | tr ' ' '-')" \
    "$(printf '%*s' $((desc_width-1)) '' | tr ' ' '-')"

# Data rows
while IFS='|' read -r name req desc; do
    [ -z "${name}" ] && continue
    printf "| %-${name_width}s | %${req_width}s | %-${desc_width}s |\n" "${name}" "${req}" "${desc}"
done <<< "${inputs_data}"

# Print outputs section
echo ""
echo "### outputs"
echo ""
echo "The following outputs are available:"
echo ""

# Header - left, right, left alignment
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
