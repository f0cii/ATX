from memory import UnsafePointer
from builtin._location import __call_location
from sys.ffi import c_char, c_int
from .internal.ffi import *


alias LOG_LEVEL_DBG = 0
alias LOG_LEVEL_INF = 1
alias LOG_LEVEL_WRN = 2
alias LOG_LEVEL_ERR = 3
alias LOG_LEVEL_OFF = 4


fn init_log(level: String, filename: String) -> None:
    var level_ = LOG_LEVEL_INF
    if level == "DBG":
        level_ = LOG_LEVEL_DBG
    elif level == "INF":
        level_ = LOG_LEVEL_INF
    elif level == "WRN":
        level_ = LOG_LEVEL_WRN
    elif level == "ERR":
        level_ = LOG_LEVEL_ERR
    elif level == "OFF":
        level_ = LOG_LEVEL_OFF
    seq_init_log(level_, filename.unsafe_cstr_ptr(), len(filename))


# 规整文件名: /home/yl/mojo/moxt-pro/strategies/runner.mojo -> strategies/runner.mojo
@always_inline
fn fix_src_file_name(file_name: String) -> String:
    var file_name_ = file_name
    if file_name_.startswith("/home/yl/mojo/echo/"):
        file_name_ = file_name_.replace("/home/yl/mojo/echo/", "")
    return file_name_


@always_inline
fn logd(s: String):
    var call_loc = __call_location()
    var s_ = fix_src_file_name(call_loc.file_name) + ":" + str(
        call_loc.line
    ) + ": " + s
    seq_logvd(s_.unsafe_cstr_ptr(), len(s_))


@always_inline
fn logi(s: String):
    var call_loc = __call_location()
    var s_ = fix_src_file_name(call_loc.file_name) + ":" + str(
        call_loc.line
    ) + ": " + s
    seq_logvi(s_.unsafe_cstr_ptr(), len(s_))


@always_inline
fn logw(s: String):
    var call_loc = __call_location()
    var s_ = fix_src_file_name(call_loc.file_name) + ":" + str(
        call_loc.line
    ) + ": " + s
    seq_logvw(s_.unsafe_cstr_ptr(), len(s_))


@always_inline
fn loge(s: String):
    var call_loc = __call_location()
    var s_ = fix_src_file_name(call_loc.file_name) + ":" + str(
        call_loc.line
    ) + ": " + s
    seq_logve(s_.unsafe_cstr_ptr(), len(s_))
