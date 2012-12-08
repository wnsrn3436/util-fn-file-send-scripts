if global._fnf_sdstate_=0
{
    global._fnf_socket_error_str_=error_f1
    return 0
}

if !global._fnf_guest_
{
    var i, skv_byte;
    skv_byte=ds_list_size(global._fnf_join_soket_)
    for(i=0; i!=skv_byte; i+=1){socket_destroy(ds_list_find_value(global._fnf_join_soket_, i))}
}
ds_list_clear(global._fnf_join_soket_)
buffer_clear(global._fnf_buffer_)
buffer_clear(global._fnf_noone_buffer_)
socket_destroy(global._fnf_soket_)
global._fnf_sdstate_=0
global._fnf_fplayer_=0
global._fnf_folder_=""
global._fnf_fname_=""
global._fnf_fsize_=0
global._fnf_md5_=""
global._fnf_speed_=10
global._fnf_speed_up_=1
global._fnf_player_join_accept_max_=0
global._fnf_guest_=0
global._fnf_socket_error_str_=""

return 1
