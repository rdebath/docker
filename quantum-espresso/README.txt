Using openMPI version

docker run --rm -it --user $(id -u):$(id -g) --cap-add=SYS_PTRACE \
            -e OMPI_NUM=4 \
            -v <path/to/input>:/workspace \
            -v <path/to/pseudopotentials>/pseudo_dir \
            yoshidalab/quantum_espresso:openmpi bash
Using openMP version

docker run --rm -it --user $(id -u):$(id -g) \
            -v <path/to/input>:/workspace \
            -v <path/to/pseudopotentials>/pseudo_dir \
            yoshidalab/quantum_espresso:openmpi bash

mpirun \
    --allow-run-as-root \
    --map-by core --bind-to core \
    -x OMP_NUM_THREADS=1 -np 8 ...

mpirun --bind-to socket --map-by socket -np 8 ...


