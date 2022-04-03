FROM --platform=${BUILDPLATFORM} golang:alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM

WORKDIR /alqasr
COPY . .

RUN set -eux; \
    case "${TARGETPLATFORM}" in \
        'linux/386')   GOARCH='386'   GOOS='linux' ;; \
        'linux/amd64') GOARCH='amd64' GOOS='linux' ;; \
        'linux/arm64') GOARCH='arm64' GOOS='linux' ;; \
        *) echo >&2 "error: unsupported target platform '${TARGETPLATFORM}'"; exit 1 ;; \
    esac && \
    cp dist/alqasr_pac_${GOOS}_${GOARCH}/alqasr_pac alqasr_pac

FROM alpine:latest

COPY --from=build /alqasr/alqasr_pac /usr/local/bin/alqasr_pac
EXPOSE 8080

ENTRYPOINT [ "alqasr_pac" ]
CMD        [ "--config=/etc/alqasr/pac.yml" ]
