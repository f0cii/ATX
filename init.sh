export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(realpath .magic/envs/default/lib):$(realpath .)
export LD_PRELOAD=libatx-classic.so
