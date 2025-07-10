#!/usr/bin/env bash
set -Eeuo pipefail

# ref:https://github.com/camalot/apprise-webhook
# ref:https://github.com/onedr0p/home-ops/blob/main/kubernetes/apps/default/webhook/app/resources/jellyseerr-pushover.sh

HTTPS_PROXY=${1:-""}
NO_PROXY=${2:-""}
SC_KEY=${3:?}
PAYLOAD=${4:?}

export HTTPS_PROXY="${HTTPS_PROXY}"
export NO_PROXY="${NO_PROXY}"

echo "[DEBUG] Payload: ${PAYLOAD}"

function _jq() {
    jq --raw-output "${1:?}" <<<"${PAYLOAD}"
}

function notify() {
    # ref:https://github.com/easychen/serverchan-demo/blob/master/shell/send.sh
    # ref:https://doc.sc3.ft07.com/zh/serverchan3

    local title="Alert from Homelab-ops"
    local content="$(_jq '.body')"
    local key="$SC_KEY"

    postdata="text=$title&desp=$content"
    opts=(
        "--header" "Content-type: application/x-www-form-urlencoded"
        "--data" "$postdata"
    )

    if [[ "$key" =~ ^sctp([0-9]+)t ]]; then
        num=${BASH_REMATCH[1]}
        url="https://${num}.push.ft07.com/send/${key}.send"
    else
        url="https://sctapi.ftqq.com/${key}.send"
    fi

    result=$(curl -X POST -s -o /dev/null -w "%{http_code}" "$url" "${opts[@]}")
    echo "[DEBUG] Notify result: $result"
}

function main() {
  notify
}

main "$@"
