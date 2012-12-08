if global._fnf_sdstate_!=0
{
    global._fnf_socket_error_str_=error_f1
    return 0
}

global._fnf_soket_=tcp_listen(argument0)
if socket_has_error(global._fnf_soket_){global._fnf_socket_error_str_=socket_error(global._fnf_soket_); socket_destroy(global._fnf_soket_); return 0}

global._fnf_sdstate_=1
return 1
