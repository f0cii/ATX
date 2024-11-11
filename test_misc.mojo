from python import Python


fn main() raises:
    # 这相当于Python中的`import numpy as np`
    var np = Python.import_module("numpy")
 
    # 现在可以像在Python中编写一样使用numpy
    var array = np.array([1, 2, 3])
    print(array)