# proxyctl

Clash Verge 终端代理开关。只改**当前 shell** 的环境变量，不启停代理内核。

默认：`127.0.0.1:7897`（mixed-port）

## 安装

```bash
# 任选一处存放，例如 ~/.local/bin/proxyctl.sh
# 写入 ~/.bashrc（或 ~/.zshrc）后重新打开终端：
. ~/.local/bin/proxyctl.sh
```

必须 `source`。直接执行无效（子进程里的 export 不会回到当前 shell）。

## 用法

```bash
proxy on        # 开
proxy off       # 关
proxy status    # 状态
```

改端口：

```bash
PROXY_HTTP_PORT=7890 PROXY_SOCKS_PORT=7890 proxy on
```

## 与 Git 的关系

`proxy on` **不会**写入 `~/.gitconfig`。

| 场景 | 做法 |
|---|---|
| curl / pip / 一般命令 | `proxy on` 即可 |
| git 长期走代理 | `git config --global http.proxy http://127.0.0.1:7897`<br>`git config --global https.proxy http://127.0.0.1:7897` |
| git 单次 | `git -c http.proxy=http://127.0.0.1:7897 -c https.proxy=http://127.0.0.1:7897 <命令>` |
| 取消 git 代理 | `git config --global --unset http.proxy`<br>`git config --global --unset https.proxy` |

国内 GitHub **镜像站** 和 **本地代理** 不要叠加；官方 `github.com` + 代理即可。

## 排障

```bash
ss -ltnp | grep 7897                                          # 内核在听吗
curl -sS -m 8 -x http://127.0.0.1:7897 -o /dev/null -w "%{http_code}\n" https://github.com
git config --show-origin --get-regexp 'proxy'                 # git 代理写在哪
```
