FROM golang:1.7 as bimage

RUN mkdir /app
COPY . /go/src/github.com/microservices-demo/payment/

RUN go get -u github.com/FiloSottile/gvt
RUN cd /go/src/github.com/microservices-demo/payment/ && gvt restore

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/main github.com/microservices-demo/payment/cmd/paymentsvc

FROM alpine:3.4

COPY --from=bimage /app/main /app
WORKDIR /app

USER root 

CMD ["/app/main", "-port=80"]
