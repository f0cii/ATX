from atxs import *
from testing import assert_equal, assert_true


fn test_photon_init() raises -> None:
    var options = PhotonOptions()
    var ret = photon_init(0, 0, options)
    assert_equal(ret, 0)

    photon_fini()


# cp ~/f0cii/echo-cpp2/build/linux/x86_64/release/libecho2.so ~/mojo/echo/
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(realpath .)
# export LD_PRELOAD=./libecho2.so
# mojo test test_echo2.mojo
