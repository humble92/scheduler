# build image
FROM golang:1.12.7-alpine3.10 as builder

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

COPY . /app/
WORKDIR /app

RUN go get -v -d ./...
RUN go build -v scheduler.go


# runtime image
FROM alpine:latest
COPY --from=builder /app/scheduler /app/
COPY .env /app/
WORKDIR /app/
CMD ["./scheduler"]
