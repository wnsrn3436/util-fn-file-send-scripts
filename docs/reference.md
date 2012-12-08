# Script reference

File transfer scripts that run on top of Faucet Networking. A server sends one file to every connected client.

## Setup and connection

- `fnf_init()` : Initializes the scripts. Must be called once before any other script is used.
- `fnf_uninit()` : Frees the list and buffers the scripts were using. If a connection is still open, close it with `fnf_close` before calling this.
- `fnf_socket_make(port)` : Opens a server on the given port. The port is an integer from 1 to 65535. Returns `true` on success and `false` on failure.
- `fnf_socket_join(ip, port)` : Connects to the server at the given address. Returns `true` on success and `false` on failure. It also fails when the server is full.
- `fnf_close()` : Closes the connection and resets the transfer state.
- `fnf_get_error_string()` : Returns the last error message. Returns an empty string if there was no error.
- `fnf_set_player_accept_max(max)` : Sets the maximum number of clients the server accepts. 0 means no limit and is the default. Can only be used on the server.
- `fnf_get_is_guest()` : Returns whether this side is a client.
- `fnf_get_player_number()` : Returns the number of connected clients. Can only be used on the server.

## Transfer

- `fnf_fsend(fname, folder, maxspeed, overload)` : Starts sending the file `fname` to every connected client. Can only be used on the server. `folder` is the folder the client saves the file into. `maxspeed` is the maximum size of one chunk in bytes, and 0 means no limit. `overload` is the reply wait limit in milliseconds, a reply later than this shrinks the chunk size, and 0 means no limit. Returns `false` if a transfer is already in progress or no client is connected.
- `fnf_fcheck()` : Advances the transfer one step and returns the current state. Both the server and the clients must call it every step.

| State | Meaning |
|---|---|
| `fnf_fwait` | No file is being sent or received |
| `fnf_fsend_start` | The server started a transfer |
| `fnf_fsending` | The server is sending the file |
| `fnf_fsend_complete_one` | The server finished sending to one client |
| `fnf_fsend_complete` | The server finished sending to every client |
| `fnf_fsend_error` | The MD5 of the file a client received differed, so it is being resent |
| `fnf_freceive_start` | The client started receiving the file |
| `fnf_freceiving` | The client is receiving the file |
| `fnf_freceive_complete` | The client received the whole file |
| `fnf_freceive_error` | The MD5 of the received file differed, so it was deleted. The server resends it |
| `fnf_server_shutdown` | The connection to the server was lost |
| `fnf_sdstate_error` | Not connected |

## Queries

These return information about the file being transferred.

| Function | Value |
|---|---|
| `fnf_get_fname()` | file name |
| `fnf_get_fsize()` | file size in bytes |
| `fnf_get_folder()` | target folder |
| `fnf_get_fmd5()` | MD5 of the file |
| `fnf_get_fplayer()` | number of the client the server is sending to now |
| `fnf_get_sending()` | bytes the server has sent so far |
| `fnf_get_saving()` | bytes the client has received so far |
| `fnf_get_speed()` | current chunk size in bytes. 0 before a transfer starts |

## Changes

v1.1

- `fnf_fcheck` was fixed.
