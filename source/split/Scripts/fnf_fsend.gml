if global._fnf_sdstate_!=1 or global._fnf_guest_=1 or ds_list_size(global._fnf_join_soket_)=0
{
    global._fnf_socket_error_str_=error_f1
    return 0
}

append_file_to_buffer(global._fnf_buffer_, argument0)

global._fnf_folder_=argument1
global._fnf_fname_=argument0
global._fnf_fsize_=buffer_size(global._fnf_buffer_)
global._fnf_md5_=md5_hash_file(argument0)
global._fnf_fplayer_=0
global._fnf_speed_max_=argument2
global._fnf_speed_c_c_=argument3

global._fnf_sdstate_=2
return 1
