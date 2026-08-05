# syntax=docker/dockerfile:1.7
# buzz-sprig-omp — block/buzz sprig agent image + oh-my-pi (omp) as the ACP runtime.
#
# The upstream sprig image ships the buzz-acp harness and symlinks for the
# Block-maintained agent runtimes (goose etc.), but not omp. buzz-acp spawns
# $BUZZ_ACP_AGENT_COMMAND over stdio; `omp acp` serves ACP, so the only delta
# needed is the static omp binary (musl build for the alpine base).
#
# Build & push (multi-arch optional, cluster is amd64):
#   docker buildx build --platform linux/amd64 \
#     -t ghcr.io/soulwhisper/buzz-sprig-omp:2026.8.5 --push .
#
# Bump OMP_VERSION / the sprig digest together, then update the tag in
# agent-helmrelease.yaml.

FROM ghcr.io/block/buzz-sprig@sha256:0ef011d4330179cc514cedf116d2571c8cf87772e3becfe135db0f44c5e5134b

ARG OMP_VERSION=17.2.8

USER root
RUN apk add --no-cache libgcc libstdc++ \
    && curl -fsSL -o /usr/local/bin/omp \
       "https://github.com/can1357/oh-my-pi/releases/download/v${OMP_VERSION}/omp-linux-musl-x64" \
    && chmod 0755 /usr/local/bin/omp

USER agent
ENTRYPOINT ["/usr/local/bin/sprig-entrypoint"]
