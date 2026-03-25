#!/bin/bash
#SBATCH --job-name=amber_cpu_parallel
#SBATCH --output=results/amber_%j.out
#SBATCH --error=results/amber_%j.err
#SBATCH --time=08:00:00
#SBATCH --partition=normal1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

set -euo pipefail

# Exemple per enviar un únic càlcul d'AMBER en paral·lel sobre CPU.
# Aquí es fan servir 8 tasques MPI dins d'una partició normal*.
#
# Estructura suggerida:
#   data/amber/
#     mdin
#     system.prmtop
#     system.rst7
#   results/
#
# Si AMBER és dins d'un contenidor, substituïu AMBER_CMD per, per exemple:
#   AMBER_CMD=(apptainer exec /ruta/amber.sif pmemd.MPI)

mkdir -p results

AMBER_CMD=(pmemd.MPI)

srun -N1 -n"${SLURM_NTASKS}" -c1 \
    "${AMBER_CMD[@]}" -O \
    -i data/amber/mdin \
    -p data/amber/system.prmtop \
    -c data/amber/system.rst7 \
    -r results/amber.restrt \
    -x results/amber.nc \
    -o results/amber.mdout \
    -inf results/amber.mdinfo
