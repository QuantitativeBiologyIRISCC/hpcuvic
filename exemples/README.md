# exemples

Carpeta amb scripts Slurm d'exemple per executar càlculs al clúster HPC de la UVic-UCC.

## Fitxers

- `amber_cpu_parallel.slurm`: exemple de job paral·lel CPU per a AMBER.
- `evb_cpu.slurm`: exemple de job CPU per a EVB.
- `openmm_cpu_parallel.slurm`: exemple de job paral·lel CPU per a OpenMM.

## Flux de treball

1. Copia l'exemple que s'assembli més al teu càlcul.
2. Ajusta partició, temps, memòria, nombre de CPUs i rutes d'entrada o sortida.
3. Desa l'script al teu espai de treball del clúster.
4. Envia'l amb `sbatch nom_script.slurm` i revisa l'estat amb `squeue -u $USER`.
