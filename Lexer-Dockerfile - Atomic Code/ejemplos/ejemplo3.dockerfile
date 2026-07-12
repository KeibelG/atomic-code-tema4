# Build multi-etapa para un binario en Go
FROM golang:1.22 AS builder
WORKDIR /build
COPY . .
RUN go build -o servidor .

FROM alpine:3.19
COPY --from=builder /build/servidor /usr/local/bin/servidor

HEALTHCHECK --interval=30s --timeout=3s CMD ["/usr/local/bin/servidor", "--health"]

STOPSIGNAL SIGTERM
CMD ["/usr/local/bin/servidor"]
