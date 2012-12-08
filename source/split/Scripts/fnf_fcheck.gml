if global._fnf_sdstate_=0{global._fnf_socket_error_str_=error_f1; return 0}

var i, skv_var, skv_var2;

if !global._fnf_guest_
{
    skv_var=socket_accept(global._fnf_soket_)
    while(skv_var>0)
    {
        if (!global._fnf_player_join_accept_max_ or global._fnf_player_join_accept_max_>ds_list_size(global._fnf_join_soket_)) and global._fnf_sdstate_=1
        {
            socket_sendbuffer_limit(skv_var, 0)
            ds_list_add(global._fnf_join_soket_, skv_var)
            write_ubyte(skv_var, 1)
            socket_send(skv_var)
        }
        else{write_ubyte(skv_var, 0); socket_send(skv_var); socket_destroy(skv_var)}
        skv_var=socket_accept(global._fnf_soket_)
    }
}

if global._fnf_sdstate_>1
{
    skv_var2=ds_list_size(global._fnf_join_soket_)
    for(i=0; i!=skv_var2; i+=1)
    {
        skv_var=ds_list_find_value(global._fnf_join_soket_, i)
        if i!=global._fnf_fplayer_
        {
            if tcp_eof(skv_var){continue}
            else{while(tcp_receive(skv_var, 1)){}}
        }
        else
        {
            if tcp_eof(skv_var)
            {
                if ds_list_size(global._fnf_join_soket_)>global._fnf_fplayer_+1
                {
                    global._fnf_fplayer_+=1
                    buffer_set_readpos(global._fnf_buffer_, 0)
                    global._fnf_sdstate_=2
                    global._fnf_speed_=10
                    global._fnf_speed_up_=1
                    return 5
                }
                else
                {
                    buffer_clear(global._fnf_buffer_)
                    buffer_clear(global._fnf_noone_buffer_)
                    global._fnf_sdstate_=1
                    global._fnf_fplayer_=0
                    global._fnf_folder_=""
                    global._fnf_fname_=""
                    global._fnf_fsize_=0
                    global._fnf_md5_=""
                    global._fnf_speed_=10
                    global._fnf_speed_up_=1
                    return 6
                }
            }
        }
    }
}

skv_var=ds_list_find_value(global._fnf_join_soket_, global._fnf_fplayer_)

switch(global._fnf_sdstate_)
{
    case 1: 
    {
        if !global._fnf_guest_
        {
            skv_var2=ds_list_size(global._fnf_join_soket_)
            for(i=0; i!=skv_var2; i+=1)
            {
                skv_var=ds_list_find_value(global._fnf_join_soket_, i)
                if tcp_eof(skv_var)
                {
                    socket_destroy(skv_var)
                    ds_list_delete(global._fnf_join_soket_, i)
                    i-=1; skv_var2-=1; continue
                }
                else{while(tcp_receive(skv_var, 1)){}}
            }
            return 8
        }
        else
        {
            if tcp_eof(global._fnf_soket_){global._fnf_socket_error_str_=socket_error(global._fnf_soket_); return 1}
            if global._fnf_fname_=""
            {
                if tcp_receive(global._fnf_soket_, 8)
                {
                    if socket_receivebuffer_size(global._fnf_soket_)!=8
                    {
                        skv_var=8-socket_receivebuffer_size(global._fnf_soket_)
                        buffer_clear(global._fnf_noone_buffer_)
                        write_buffer(global._fnf_noone_buffer_, global._fnf_soket_)
                        while(skv_var>0)
                        {
                            if tcp_eof(global._fnf_soket_){break}
                            tcp_receive(global._fnf_soket_, skv_var)
                            skv_var-=socket_receivebuffer_size(global._fnf_soket_)
                            write_buffer(global._fnf_noone_buffer_, global._fnf_soket_)
                        }
                        if skv_var>0{break}
                        skv_var=read_double(global._fnf_noone_buffer_)
                    }
                    else{skv_var=read_double(global._fnf_soket_)}
                    buffer_clear(global._fnf_noone_buffer_)
                    while(skv_var>0)
                    {
                        if tcp_eof(global._fnf_soket_){break}
                        tcp_receive(global._fnf_soket_, skv_var)
                        skv_var-=socket_receivebuffer_size(global._fnf_soket_)
                        write_buffer(global._fnf_noone_buffer_, global._fnf_soket_)
                    }
                    if skv_var>0{break}
                    global._fnf_fname_=read_string(global._fnf_noone_buffer_, read_ushort(global._fnf_noone_buffer_))
                    global._fnf_fsize_=read_double(global._fnf_noone_buffer_)
                    global._fnf_folder_=read_string(global._fnf_noone_buffer_, read_ushort(global._fnf_noone_buffer_))
                    global._fnf_md5_=read_string(global._fnf_noone_buffer_, read_ushort(global._fnf_noone_buffer_))
                    write_byte(global._fnf_soket_, 0)
                    socket_send(global._fnf_soket_)
                }
                if global._fnf_fname_=""{return 8}
                else{return 4}
            }
            else
            {
                if tcp_receive(global._fnf_soket_, 8)
                {
                    if socket_receivebuffer_size(global._fnf_soket_)!=8
                    {
                        skv_var=8-socket_receivebuffer_size(global._fnf_soket_)
                        buffer_clear(global._fnf_noone_buffer_)
                        write_buffer(global._fnf_noone_buffer_, global._fnf_soket_)
                        while(skv_var>0)
                        {
                            if tcp_eof(global._fnf_soket_){break}
                            tcp_receive(global._fnf_soket_, skv_var)
                            skv_var-=socket_receivebuffer_size(global._fnf_soket_)
                            write_buffer(global._fnf_noone_buffer_, global._fnf_soket_)
                        }
                        if skv_var>0{break}
                        skv_var=read_double(global._fnf_noone_buffer_)
                    }
                    else{skv_var=read_double(global._fnf_soket_)}
                    buffer_clear(global._fnf_noone_buffer_)
                    while(skv_var>0)
                    {
                        if tcp_eof(global._fnf_soket_){break}
                        tcp_receive(global._fnf_soket_, skv_var)
                        skv_var-=socket_receivebuffer_size(global._fnf_soket_)
                        write_buffer(global._fnf_noone_buffer_, global._fnf_soket_)
                    }
                    if skv_var>0{break}
                    global._fnf_speed_=buffer_bytes_left(global._fnf_noone_buffer_)
                    write_buffer_part(global._fnf_buffer_, global._fnf_noone_buffer_, buffer_bytes_left(global._fnf_noone_buffer_))
                    if buffer_size(global._fnf_buffer_)=global._fnf_fsize_
                    {
                        file_delete(global._fnf_folder_+global._fnf_fname_)
                        write_buffer_to_file(global._fnf_buffer_, global._fnf_folder_+global._fnf_fname_)
                        global._fnf_fsize_=0
                        global._fnf_fplayer_=0
                        global._fnf_speed_=10
                        global._fnf_speed_up_=1
                        buffer_clear(global._fnf_buffer_)
                        buffer_clear(global._fnf_noone_buffer_)
                        if global._fnf_md5_!=md5_hash_file(global._fnf_folder_+global._fnf_fname_)
                        {
                            global._fnf_md5_=""
                            global._fnf_folder_=""
                            global._fnf_fname_=""
                            write_byte(global._fnf_soket_, 2)
                            socket_send(global._fnf_soket_)
                            file_delete(global._fnf_folder_+global._fnf_fname_)
                            return 11
                        }
                        else
                        {
                            global._fnf_md5_=""
                            global._fnf_folder_=""
                            global._fnf_fname_=""
                            write_byte(global._fnf_soket_, 1)
                            socket_send(global._fnf_soket_)
                            return 7
                        }
                    }
                    else
                    {
                        write_byte(global._fnf_soket_, 1)
                        socket_send(global._fnf_soket_)
                    }
                }
                return 9
            }
        }
        break
    }
    case 2: 
    {
        write_double(skv_var, 14+string_length(global._fnf_fname_)+string_length(global._fnf_folder_)+string_length(global._fnf_md5_))
        write_ushort(skv_var, string_length(global._fnf_fname_))
        write_string(skv_var, global._fnf_fname_)
        write_double(skv_var, global._fnf_fsize_)
        write_ushort(skv_var, string_length(global._fnf_folder_))
        write_string(skv_var, global._fnf_folder_)
        write_ushort(skv_var, string_length(global._fnf_md5_))
        write_string(skv_var, global._fnf_md5_)
        socket_send(skv_var)
        global._fnf_sdstate_=4
        return 2
        break
    }
    case 3: 
    {
        global._fnf_speed_=min(global._fnf_speed_, buffer_bytes_left(global._fnf_buffer_))
        write_double(skv_var, global._fnf_speed_)
        write_buffer_part(skv_var, global._fnf_buffer_, global._fnf_speed_)
        socket_send(skv_var)
        global._fnf_speed_c_=current_time
        global._fnf_sdstate_=4
        return 3
        break
    }
    case 4: 
    {
        if tcp_receive(skv_var, 1)
        {
            global._fnf_sdstate_=3
            switch(read_byte(skv_var))
            {
                case 1: 
                {
                    if buffer_bytes_left(global._fnf_buffer_)=0
                    {
                        if ds_list_size(global._fnf_join_soket_)>global._fnf_fplayer_+1
                        {
                            global._fnf_fplayer_+=1
                            buffer_set_readpos(global._fnf_buffer_, 0)
                            global._fnf_sdstate_=2
                            global._fnf_speed_=10
                            global._fnf_speed_up_=1
                            return 5
                        }
                        else
                        {
                            buffer_clear(global._fnf_buffer_)
                            buffer_clear(global._fnf_noone_buffer_)
                            global._fnf_fplayer_=0
                            global._fnf_sdstate_=1
                            global._fnf_folder_=""
                            global._fnf_fname_=""
                            global._fnf_fsize_=0
                            global._fnf_md5_=""
                            global._fnf_speed_=10
                            global._fnf_speed_up_=1
                            return 6
                        }
                    }
                    else
                    {
                        if !global._fnf_speed_c_c_ or current_time-global._fnf_speed_c_<global._fnf_speed_c_c_{global._fnf_speed_+=100*global._fnf_speed_up_; global._fnf_speed_up_+=1}
                        else{global._fnf_speed_=max(10, global._fnf_speed_-100*global._fnf_speed_up_); global._fnf_speed_up_=1}
                        if global._fnf_speed_max_!=0 and global._fnf_speed_>global._fnf_speed_max_
                        {
                            global._fnf_speed_=global._fnf_speed_max_
                            global._fnf_speed_up_=1
                        }
                        return 3
                    }
                    break
                }
                case 2: 
                {
                    global._fnf_speed_=10
                    global._fnf_speed_up_=1
                    global._fnf_sdstate_=2
                    buffer_set_readpos(global._fnf_buffer_, 0)
                    return 10
                    break
                }
            }
        }
        return 3
        break
    }
}
