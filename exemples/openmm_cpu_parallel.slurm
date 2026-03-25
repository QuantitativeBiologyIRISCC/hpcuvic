#!/bin/bash
#SBATCH --job-name=openmm_cpu_parallel
#SBATCH --output=results/openmm_%j.out
#SBATCH --error=results/openmm_%j.err
#SBATCH --time=08:00:00
#SBATCH --partition=normal1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G

set -euo pipefail

# Exemple per executar un únic càlcul d'OpenMM en paral·lel sobre CPU.
# Les particions normal* del clúster tenen 14 CPUs per node; aquí en fem servir 8.
#
# Estructura suggerida:
#   data/openmm/
#     run_openmm.py
#     system.prmtop
#     system.inpcrd
#   results/
#
# Si feu servir un contenidor, substituïu OPENMM_CMD per:
#   OPENMM_CMD=(apptainer exec /ruta/openmm.sif python)
#
# L'script de Python hauria d'usar la plataforma CPU d'OpenMM i llegir
# el nombre de fils des de SLURM_CPUS_PER_TASK o OPENMM_CPU_THREADS.

mkdir -p results

OPENMM_CMD=(python)

srun -N1 -n1 -c"${SLURM_CPUS_PER_TASK}" \
    env OPENMM_CPU_THREADS="${SLURM_CPUS_PER_TASK}" \
    "${OPENMM_CMD[@]}" data/openmm/run_openmm.py \
    --top data/openmm/system.prmtop \
    --coords data/openmm/system.inpcrd \
    --platform CPU \
    --threads "${SLURM_CPUS_PER_TASK}" \
    --output results/openmm
