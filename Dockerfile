FROM jaegertracing/jaeger-query:1.8 as jaeger-query

FROM alpine:3.8

COPY --from=jaeger-query /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=jaeger-query /go/bin/query-linux /go/bin/query-linux
COPY docker-healthcheck /usr/local/bin/

RUN apk add --no-cache bash curl && \
chmod +x /usr/local/bin/docker-healthcheck

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s CMD ["docker-healthcheck"]

EXPOSE 16686
ENTRYPOINT ["/go/bin/query-linux"]
