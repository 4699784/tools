# Clash Verge 终端代理开关
# 只设置当前 shell 环境变量，不启动/停止内核
# 用法: 先 source，再 proxy on | off | status
#
#   . /path/to/proxyctl.sh
#   proxy on

# 直接执行无效（export 不会留在当前 shell）
if [ -n "${BASH_VERSION:-}" ] && [ "${BASH_SOURCE[0]}" = "$0" ]; then
    echo "请先 source:  . $0" >&2
    exit 1
fi

PROXY_HOST="${PROXY_HOST:-127.0.0.1}"
PROXY_HTTP_PORT="${PROXY_HTTP_PORT:-7897}"
PROXY_SOCKS_PORT="${PROXY_SOCKS_PORT:-7897}"

_proxy_on() {
    export http_proxy="http://${PROXY_HOST}:${PROXY_HTTP_PORT}"
    export https_proxy="http://${PROXY_HOST}:${PROXY_HTTP_PORT}"
    export HTTP_PROXY="$http_proxy"
    export HTTPS_PROXY="$https_proxy"
    export all_proxy="socks5://${PROXY_HOST}:${PROXY_SOCKS_PORT}"
    export ALL_PROXY="$all_proxy"
    export no_proxy="127.0.0.1,::1,localhost"
    export NO_PROXY="$no_proxy"
    echo "代理已开启  http=${http_proxy}  socks=${all_proxy}"
}

_proxy_off() {
    unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
    unset all_proxy ALL_PROXY
    unset no_proxy NO_PROXY
    echo "代理已关闭"
}

_proxy_status() {
    if [ -n "${http_proxy}${HTTP_PROXY}${all_proxy}${ALL_PROXY}" ]; then
        echo "状态: 开启"
        echo "  http_proxy=${http_proxy:-$HTTP_PROXY}"
        echo "  https_proxy=${https_proxy:-$HTTPS_PROXY}"
        echo "  all_proxy=${all_proxy:-$ALL_PROXY}"
    else
        echo "状态: 关闭"
    fi
}

proxy() {
    case "${1:-}" in
        on|enable|1)
            _proxy_on
            ;;
        off|disable|0)
            _proxy_off
            ;;
        status|st)
            _proxy_status
            ;;
        -h|--help|help|"")
            cat <<'USAGE'
用法:
  proxy on       开启终端代理 (Clash Verge mixed-port)
  proxy off      关闭终端代理
  proxy status   查看当前状态

环境变量可覆盖端口:
  PROXY_HOST=127.0.0.1 PROXY_HTTP_PORT=7897 PROXY_SOCKS_PORT=7897
USAGE
            ;;
        *)
            echo "未知命令: $1  (用 proxy help 查看帮助)" >&2
            return 1
            ;;
    esac
}
