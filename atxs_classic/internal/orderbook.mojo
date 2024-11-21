from sys.ffi import DLHandle
from memory import UnsafePointer


var __wrapper = _DLWrapper()


@value
struct _DLWrapper:
    var _handle: DLHandle

    var _seq_skiplist_new: DL_Fn[
        "seq_skiplist_new", fn (is_forward: Bool) -> c_void_ptr
    ]
    var _seq_skiplist_free: DL_Fn[
        "seq_skiplist_free", fn (list: c_void_ptr) -> None
    ]
    var _seq_skiplist_insert: DL_Fn[
        "seq_skiplist_insert",
        fn (
            list: c_void_ptr, key: Int64, value: Int64, update_if_exists: Bool
        ) -> Bool,
    ]
    var _seq_skiplist_remove: DL_Fn[
        "seq_skiplist_remove", fn (list: c_void_ptr, key: Int64) -> Int64
    ]
    var _seq_skiplist_search: DL_Fn[
        "seq_skiplist_search", fn (list: c_void_ptr, key: Int64) -> Int64
    ]
    var _seq_skiplist_dump: DL_Fn[
        "seq_skiplist_dump", fn (list: c_void_ptr) -> None
    ]
    var _seq_skiplist_begin: DL_Fn[
        "seq_skiplist_begin", fn (list: c_void_ptr) -> c_void_ptr
    ]
    var _seq_skiplist_end: DL_Fn[
        "seq_skiplist_end", fn (list: c_void_ptr) -> c_void_ptr
    ]
    var _seq_skiplist_next: DL_Fn[
        "seq_skiplist_next",
        fn (list: c_void_ptr, node: c_void_ptr) -> c_void_ptr,
    ]
    var _seq_skiplist_node_value: DL_Fn[
        "seq_skiplist_node_value",
        fn (
            node: c_void_ptr,
            key: UnsafePointer[Int64],
            value: UnsafePointer[Int64],
        ) -> None,
    ]

    fn __init__(out self):
        self._handle = DLHandle(LIBNAME)
        self._seq_skiplist_new = self._handle
        self._seq_skiplist_free = self._handle
        self._seq_skiplist_insert = self._handle
        self._seq_skiplist_remove = self._handle
        self._seq_skiplist_search = self._handle
        self._seq_skiplist_dump = self._handle
        self._seq_skiplist_begin = self._handle
        self._seq_skiplist_end = self._handle
        self._seq_skiplist_next = self._handle
        self._seq_skiplist_node_value = self._handle


@always_inline
fn seq_skiplist_new(is_forward: Bool) -> c_void_ptr:
    return __wrapper._seq_skiplist_new.call(is_forward)


@always_inline
fn seq_skiplist_free(list: c_void_ptr) -> None:
    return __wrapper._seq_skiplist_free.call(list)


@always_inline
fn seq_skiplist_insert(
    list: c_void_ptr, key: Int64, value: Int64, update_if_exists: Bool
) -> Bool:
    return __wrapper._seq_skiplist_insert.call(list, key, value, update_if_exists)


@always_inline
fn seq_skiplist_remove(list: c_void_ptr, key: Int64) -> Int64:
    return __wrapper._seq_skiplist_remove.call(list, key)


@always_inline
fn seq_skiplist_search(list: c_void_ptr, key: Int64) -> Int64:
    return __wrapper._seq_skiplist_search.call(list, key)


@always_inline
fn seq_skiplist_dump(list: c_void_ptr) -> None:
    return __wrapper._seq_skiplist_dump.call(list)


@always_inline
fn seq_skiplist_begin(list: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_skiplist_begin.call(list)


@always_inline
fn seq_skiplist_end(list: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_skiplist_end.call(list)


@always_inline
fn seq_skiplist_next(list: c_void_ptr, node: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_skiplist_next.call(list, node)


@always_inline
fn seq_skiplist_node_value(
    node: c_void_ptr,
    key: UnsafePointer[Int64],
    value: UnsafePointer[Int64],
) -> None:
    return __wrapper._seq_skiplist_node_value.call(node, key, value)
