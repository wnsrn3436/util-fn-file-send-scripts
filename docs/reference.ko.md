# 스크립트 설명

Faucet Networking 위에서 동작하는 파일 전송 스크립트다. 서버가 접속한 모든 클라이언트에게 파일 하나를 보낸다.

## 준비와 연결

- `fnf_init()` : 스크립트를 초기화한다. 다른 스크립트를 사용하기 전에 한 번 호출해야 한다.
- `fnf_uninit()` : 스크립트가 쓰던 리스트와 버퍼를 해제한다. 연결이 남아 있으면 `fnf_close` 로 끊은 뒤에 호출해야 한다.
- `fnf_socket_make(port)` : 지정한 포트로 서버를 연다. 포트는 1 부터 65535 사이의 정수다. 성공하면 `true`, 실패하면 `false` 를 돌려준다.
- `fnf_socket_join(ip, port)` : 지정한 주소의 서버에 접속한다. 성공하면 `true`, 실패하면 `false` 를 돌려준다. 서버가 가득 찼을 때도 실패한다.
- `fnf_close()` : 연결을 끊고 전송 상태를 초기화한다.
- `fnf_get_error_string()` : 마지막으로 발생한 오류 메시지를 돌려준다. 오류가 없으면 빈 문자열이다.
- `fnf_set_player_accept_max(max)` : 서버가 받아들일 클라이언트 수의 상한을 정한다. 0 이면 제한하지 않으며 기본값이다. 서버에서만 사용할 수 있다.
- `fnf_get_is_guest()` : 이쪽이 클라이언트인지 돌려준다.
- `fnf_get_player_number()` : 접속해 있는 클라이언트 수를 돌려준다. 서버에서만 사용할 수 있다.

## 전송

- `fnf_fsend(fname, folder, maxspeed, overload)` : `fname` 파일을 접속한 모든 클라이언트에게 보내기 시작한다. 서버에서만 사용할 수 있다. `folder` 는 클라이언트가 파일을 저장할 폴더다. `maxspeed` 는 한 번에 보내는 조각의 최대 크기(바이트)이고 0 이면 제한하지 않는다. `overload` 는 응답을 기다리는 시간의 한계(밀리초)로, 응답이 이보다 늦으면 조각 크기를 줄이며 0 이면 제한하지 않는다. 전송이 진행 중이거나 접속한 클라이언트가 없으면 `false` 를 돌려준다.
- `fnf_fcheck()` : 전송을 한 단계 진행하고 현재 상태를 돌려준다. 서버와 클라이언트 모두 매 스텝 호출해야 한다.

| 상태값 | 뜻 |
|---|---|
| `fnf_fwait` | 보내거나 받는 중인 파일이 없다 |
| `fnf_fsend_start` | 서버가 전송을 시작했다 |
| `fnf_fsending` | 서버가 파일을 보내는 중이다 |
| `fnf_fsend_complete_one` | 클라이언트 한 명에게 전송을 마쳤다 |
| `fnf_fsend_complete` | 모든 클라이언트에게 전송을 마쳤다 |
| `fnf_fsend_error` | 클라이언트가 받은 파일의 MD5 가 달라 다시 보낸다 |
| `fnf_freceive_start` | 클라이언트가 파일을 받기 시작했다 |
| `fnf_freceiving` | 클라이언트가 파일을 받는 중이다 |
| `fnf_freceive_complete` | 클라이언트가 파일을 다 받았다 |
| `fnf_freceive_error` | 받은 파일의 MD5 가 달라 파일을 지웠다. 서버가 다시 보낸다 |
| `fnf_server_shutdown` | 서버와의 연결이 끊겼다 |
| `fnf_sdstate_error` | 연결되어 있지 않다 |

## 조회

전송 중인 파일의 정보를 돌려준다.

| 함수 | 값 |
|---|---|
| `fnf_get_fname()` | 파일 이름 |
| `fnf_get_fsize()` | 파일 크기(바이트) |
| `fnf_get_folder()` | 저장 폴더 |
| `fnf_get_fmd5()` | 파일의 MD5 |
| `fnf_get_fplayer()` | 서버가 지금 보내고 있는 클라이언트의 번호 |
| `fnf_get_sending()` | 서버가 지금까지 보낸 바이트 수 |
| `fnf_get_saving()` | 클라이언트가 지금까지 받은 바이트 수 |
| `fnf_get_speed()` | 현재 조각 크기(바이트). 전송을 시작하기 전에는 0 |

## 변경 내역

v1.1

- `fnf_fcheck` 를 수정했다.
