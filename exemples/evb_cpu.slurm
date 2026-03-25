#!/bin/bash
#SBATCH --job-name=evb_qdyn
#SBATCH --output=messages.out.txt
#SBATCH --error=messages.err.txt
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=2G
#SBATCH --partition=normal1,normal2,normal3,normal4,normal5,highmem

set -euo pipefail

# Example based on the GPX6 repository workflow for EVB calculations with Q6/Qdyn6.
# Submit this script from a directory already prepared by q_genrelax.py or
# q_genfeps.py, where a series of *.inp files has been generated.
#
# Typical workflow:
#   1. Generate EVB inputs (relaxation or FEP) with qtools.
#   2. Copy this script into the generated folder.
#   3. Submit it with: sbatch evb_cpu.slurm
#
# Typical layout:
#   minim/
#     relax_001.inp
#     relax_002.inp
#     ...
#     evb_cpu.slurm
#
# or:
#   replica001/
#     frame_001.inp
#     frame_002.inp
#     ...
#     evb_cpu.slurm
#
# By default this uses qdyn6.
# If your cluster provides a different Q6 executable, override it like this:
#   sbatch --export=ALL,EVB_CMD=qdyn6_r8 evb_cpu.slurm

OK="(\033[0;32m   OK   \033[0m)"
FAILED="(\033[0;31m FAILED \033[0m)"
EVB_CMD="${EVB_CMD:-qdyn6}"

# Fail early if the chosen executable is not available.
if ! command -v "${EVB_CMD}" >/dev/null 2>&1; then
    echo "Error: executable '${EVB_CMD}' was not found in PATH." >&2
    exit 1
fi

# Collect all input files in the current directory.
shopt -s nullglob
steps=( *.inp )
shopt -u nullglob

if [ "${#steps[@]}" -eq 0 ]; then
    echo "Error: no .inp files were found in the current directory: $(pwd)" >&2
    exit 1
fi

# Run files in natural/version order: step_2 before step_10.
IFS=$'\n' steps=( $(printf '%s\n' "${steps[@]}" | sort -V) )
unset IFS

echo "Working directory: $(pwd)"
echo "EVB/Qdyn executable: ${EVB_CMD}"
echo "Detected steps:"
printf '  - %s\n' "${steps[@]}"

for input_file in "${steps[@]}"; do
    step="${input_file%.inp}"
    # Keep one log file per input so failed steps are easy to inspect.
    echo "Running EVB step ${step}"

    if "${EVB_CMD}" "${input_file}" > "${step}.log"; then
        echo -e "${OK}"
    else
        echo -e "${FAILED}"
        echo "Check output (${step}.log) for more info." >&2
        exit 1
    fi
done

echo "All EVB steps finished successfully."
