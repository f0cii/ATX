<<<<<<< HEAD
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(realpath . .magic/envs/default/lib)
# export LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH:$(realpath ./lib .magic/envs/default/lib)
# export LD_PRELOAD=./libatx-classic.so
=======
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(realpath .magic/envs/default/lib):$(realpath .)
# export LD_PRELOAD=libatx-classic.so
>>>>>>> be22614 (1)

