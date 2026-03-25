#!/bin/bash
#SBATCH --job-name=evb_cpu
#SBATCH --output=results/evb_%j.out
#SBATCH --error=results/evb_%j.err
#SBATCH --time=04:00:00
#SBATCH --partition=normal1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

set -euo pipefail

# Exemple de job simple d'EVB sobre CPU.
# Ajusteu EVB_CMD i els fitxers d'entrada segons el paquet EVB instal·lat.
#
# Estructura suggerida:
#   data/evb/
#     evb.in
#     system.top
#     system.crd
#   results/
#
# Si l'eina EVB és dins d'un contenidor, podeu fer servir:
#   EVB_CMD=(apptainer exec /ruta/evb.sif evb)

mkdir -p results

EVB_CMD=(evb)

srun -N1 -n1 -c1 \
    "${EVB_CMD[@]}" \
    -i data/evb/evb.in \
    -p data/evb/system.top \
    -c data/evb/system.crd \
    -o results/evb.out
