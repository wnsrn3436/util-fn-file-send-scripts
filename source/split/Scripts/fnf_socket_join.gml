if global._fnf_sdstate_!=0
{
    global._fnf_socket_error_str_=error_f1
    return 0
}

var skv_byte;
global._fnf_soket_=tcp_connect(argument0, argument1)
socket_sendbuffer_limit(global._fnf_soket_, 0)
while(socket_connecting(global._fnf_soket_)){}
while(1)
{
    if tcp_eof(global._fnf_soket_){global._fnf_socket_error_str_=socket_error(global._fnf_soket_); socket_destroy(global._fnf_soket_); return 0}
    if tcp_receive(global._fnf_soket_, 1)
    {
        skv_byte=read_ubyte(global._fnf_soket_)
        if skv_byte>0
        {
            global._fnf_guest_=1
            global._fnf_sdstate_=1
            return 1
        }
        else{global._fnf_socket_error_str_=error_f2; socket_destroy(global._fnf_soket_); return 0}
    }
}
