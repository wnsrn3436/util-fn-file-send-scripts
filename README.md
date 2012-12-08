# FN File Send Scripts

A set of GameMaker 8 scripts that lets a server send a file to every connected client. It splits the file into chunks over Faucet Networking sockets, sizes the chunks to how fast the receiver answers, and compares the MD5 at the end, resending from the start on a mismatch. File name, size, bytes so far, and speed can be read during a transfer, so a progress display is easy to draw.

<p>
  <img src="docs/screenshots/screenshot-1.png" width="306" alt="Example">
</p>


## How to use

The Releases download contains the script resource (`.gmres`), the Faucet Networking and Hashes Dll extensions (`.gex`), an example, and a script reference. Install both extensions in GameMaker 8 and import the resource with `File > Import Resources`.

```gml
fnf_init()
fnf_socket_make(12345)                              // server. A client calls fnf_socket_join(ip, 12345)
fnf_fsend("file.txt", "download\", 65536, 512)      // server only. Sends to everyone connected

state = fnf_fcheck()                                // every step. Returns one of the states below
```

The arguments of `fnf_fsend` are the file to send, the folder the receiver saves into, the maximum chunk size in bytes (0 for no limit), and the reply wait limit in milliseconds (0 for no limit). A server can cap the player count with `fnf_set_player_accept_max`.

| `fnf_fcheck` return | Meaning |
|---|---|
| `fnf_fwait` | Nothing to send or receive |
| `fnf_fsend_start`, `fnf_fsending`, `fnf_fsend_complete_one`, `fnf_fsend_complete` | Server: transfer started, in progress, one player done, everyone done |
| `fnf_fsend_error` | Server: the receiver's MD5 differed, resending |
| `fnf_freceive_start`, `fnf_freceiving`, `fnf_freceive_complete` | Client: receiving started, in progress, done |
| `fnf_freceive_error` | Client: the MD5 differed, the file was deleted |
| `fnf_server_shutdown` | Client: the server went away |
| `fnf_sdstate_error` | No socket |

During a transfer, `fnf_get_fname`, `fnf_get_fsize`, `fnf_get_folder`, and `fnf_get_fmd5` give the file information, `fnf_get_sending` (server) and `fnf_get_saving` (client) give the bytes so far, and `fnf_get_speed` gives the chunk size. To finish, call `fnf_close` and then `fnf_uninit`. The arguments of every script are described in [docs/reference.md](docs/reference.md).

The example asks whether this computer is the server and, for a client, asks for an IP and connects on port 12345. Pressing space on the server sends `file.txt` to the `download\` folder of every client, and both sides show the file name, progress, speed, MD5, and state.


## How it works

**`fnf_fcheck` is a single state machine.** State 1 is idle, 2 sends the header, 3 sends a chunk, and 4 waits for the reply. The server serves connected clients one at a time, and when one has received everything it moves to the next and rewinds the buffer read position. The header carries the file name, size, target folder, and MD5.

```gml
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
```

**Chunk size grows and shrinks with the replies.** A chunk starts at 10 bytes and grows by an increasing multiple of 100 on every reply. If a reply arrives later than the limit given to `fnf_fsend`, the size shrinks by the same amount and the increment resets. A maximum chunk size, if given, is never exceeded.

```gml
if !global._fnf_speed_c_c_ or current_time-global._fnf_speed_c_<global._fnf_speed_c_c_{global._fnf_speed_+=100*global._fnf_speed_up_; global._fnf_speed_up_+=1}
else{global._fnf_speed_=max(10, global._fnf_speed_-100*global._fnf_speed_up_); global._fnf_speed_up_=1}
```

**The receiver checks the MD5.** A client collects chunks in a buffer, and once the size matches the header it writes the file and compares `md5_hash_file` from Hashes Dll with the MD5 in the header. It replies 1 on a match and 2 otherwise, and a server that gets 2 rewinds the read position and sends the file to the same client again.


## Files

| Path | Content |
|---|---|
| `source/fn-file-send-scripts.gmk` | Script project file |
| `source/split/` | Text tree produced by GmkSplitter |
| `source/Faucet Networking v1.4.2.gex` | Faucet Networking extension |
| `source/Hashes Dll.gex` | Hashes Dll extension |
| `docs/reference.md` | Script reference |
| `docs/screenshots/` | Screenshots |
| Releases | Script resource, extensions, example, and script reference |


## Credits

Faucet Networking is a networking and buffer extension for GameMaker made by Medo42. Hashes Dll was made by freaked.


## License

zlib. See [LICENSE](LICENSE). Bundled libraries made by other people keep their own licenses.
