ARG PGVERSION
ARG VERSION

FROM golang:1.13-buster
ENV \
  GO111MODULE=on \
  CGO_ENABLED=0 \
  GOOS=linux
WORKDIR /go/src/github.com/sorintlab/stolon
ADD . .
RUN go build -v -installsuffix cgo -ldflags="-w -X github.com/sorintlab/stolon/cmd.Version=${VERSION} -s" -o /go/bin/keeper cmd/keeper/*.go
RUN go build -v -installsuffix cgo -ldflags="-w -X github.com/sorintlab/stolon/cmd.Version=${VERSION} -s" -o /go/bin/proxy cmd/proxy/*.go
RUN go build -v -installsuffix cgo -ldflags="-w -X github.com/sorintlab/stolon/cmd.Version=${VERSION} -s" -o /go/bin/sentinel cmd/sentinel/*.go
RUN go build -v -installsuffix cgo -ldflags="-w -X github.com/sorintlab/stolon/cmd.Version=${VERSION} -s" -o /go/bin/stolonctl cmd/stolonctl/*.go


FROM postgres:$PGVERSION
RUN useradd -ms /bin/bash stolon
ENV PATH='/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
COPY --from=0 /go/bin /usr/local/bin
