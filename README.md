# Kong External Auth Plugin

**Kong Gateway***에서 외부 인증 서버에 인증을 위임하기 위한 플러그인*.  

**OAuth2-Proxy**와 함께 사용하여 세션 기반 인증을 처리하고,  
인증된 사용자의 *Access Token을 upstream 서비스로 전달*하는 역할을 한다.

Kong Enterprise Edition에는 외부 인증 서버로 요청을 전달하는 기능(Forward / External Auth 패턴)이 제공된다.  
하지만 Community Edition에는 해당 기능이 기본적으로 제공되지 않는다.

이 플러그인은 Kong Community Edition에서 External Authentication 패턴을 구현하기 위한 목적으로 개발되었다.

## 주요 기능

- Gateway에서 인증을 직접 처리하지 않고 외부 인증 서비스로 위임
- OAuth2-Proxy와 같은 OIDC 인증 프록시와 통합
- `X-Auth-Request-Access-Token` 헤더에서 Access Token 추출
- Upstream 요청에 `Authorization: Bearer <token>` 헤더 추가
- 인증 실패 시 `401 Unauthorized` 반환

## 설치 방법

1. 플러그인 코드 배치

    ```
    kong/plugins/external-auth/
    ├─ handler.lua
    └─ schema.lua
    ```

2. Kong 플러그인 설정 (kong.conf)

    ```conf
    plugins = bundled,external-auth
    lua_package_path = /kong/plugins/?.lua;;
    ```

3. Kong 설정 방법 (kong.yml)

    ```yaml
    services:
    - name: example-api
      host: example-api
      routes:
        - name: example-route
          paths: ["/example"]
          methods: ["GET", "POST"]
          preserve_host: true
      plugins:
        - name: external-auth
          config:
            url: http://oauth2-proxy:4180/oauth2/auth
    ```

4. 도커컴포즈 Kong 마운트

    ```yaml
    kong:
    image: kong:3.9.1
    command: kong start

    volumes:
      - ./kong/kong.conf:/etc/kong/kong.conf
      - ./kong/kong.yml:/kong/kong.yml
      - ./kong/plugins:/kong/plugins:ro
    ```

### OAuth2-Proxy 설정

oauth2-proxy에서 다음 옵션이 활성화되어야 한다.

```conf
set-xauthrequest = true   # 인증된 사용자 정보를 X-Auth-Request-* 헤더로 upstream에 전달
pass-access-token = true  # OAuth2 access token을 X-Forwarded-Access-Token 헤더로 전달
```

### 플러그인 설정 옵션

| 옵션              | 설명                    |
| ----------------- | ----------------------- |
| `url`             | 외부 인증 서버 endpoint |
| `connect_timeout` | 인증 서버 연결 timeout  |
| `send_timeout`    | 요청 전송 timeout       |
| `read_timeout`    | 응답 대기 timeout       |

