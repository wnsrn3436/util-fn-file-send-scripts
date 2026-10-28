# Script reference

File transfer scripts that run on top of Faucet Networking. The server sends one file to every connected client.

## Setup and connection

- `fnf_init()` : Initializes the scripts. It must be called once before any other script is used.
- `fnf_uninit()` : Frees the list and buffers the scripts were using. If a connection is still open, close it with `fnf_close` before calling this.
- `fnf_socket_make(port)` : Opens a server on the given port. The port is an integer from 1 to 65535. Returns `true` on success and `false` on failure.
- `fnf_socket_join(ip, port)` : Connects to the server at the given address. Returns `true` on success and `false` on failure. It also fails when the server is full.
- `fnf_close()` : Closes the connection and resets the transfer state.
- `fnf_get_error_string()` : Returns the last error message. It is an empty string if no error has occurred.
- `fnf_set_player_accept_max(max)` : Sets the maximum number of clients the server accepts. 0 means no limit and is the default. Can only be used on the server.
- `fnf_get_is_guest()` : Returns whether the currently running side is a client.
- `fnf_get_player_number()` : Returns the number of connected clients. Can only be used on the server.

## Transfer

- `fnf_fsend(fname, folder, maxspeed, overload)` : Starts sending the file `fname` to every connected client. Can only be used on the server. `folder` is the folder the client saves the file into. `maxspeed` is the largest chunk sent at once, in bytes, and 0 means no limit. `overload` is the longest time to wait for a reply, in milliseconds, and 0 means no limit. If a reply takes longer than this, the chunk size is reduced. Returns `false` if a transfer is already in progress or no client is connected.
- `fnf_fcheck()` : Advances the transfer one step and returns the current state. Both the server and the clients must call it every step.

| State | Meaning |
|---|---|
| `fnf_fwait` | No file is being sent or received |
| `fnf_fsend_start` | The server started a transfer |
| `fnf_fsending` | The server is sending the file |
| `fnf_fsend_complete_one` | Finished sending to one client |
| `fnf_fsend_complete` | Finished sending to every client |
| `fnf_fsend_error` | The MD5 of the file a client received did not match, so the file is sent again |
| `fnf_freceive_start` | The client started receiving the file |
| `fnf_freceiving` | The client is receiving the file |
| `fnf_freceive_complete` | The client received the whole file |
| `fnf_freceive_error` | The MD5 of the received file did not match, so the file was deleted. The server sends it again |
| `fnf_server_shutdown` | The connection to the server was lost |
| `fnf_sdstate_error` | Not connected |

## Queries

These return information about the file being transferred.

| Function | Value |
|---|---|
| `fnf_get_fname()` | File name |
| `fnf_get_fsize()` | File size in bytes |
| `fnf_get_folder()` | Save folder |
| `fnf_get_fmd5()` | MD5 of the file |
| `fnf_get_fplayer()` | Number of the client the server is currently sending to |
| `fnf_get_sending()` | Bytes the server has sent so far |
| `fnf_get_saving()` | Bytes the client has received so far |
| `fnf_get_speed()` | Current chunk size in bytes. 0 before a transfer starts |

## Changes

v1.1

- `fnf_fcheck` was fixed.
