FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . ./
RUN CGO_ENABLED=0 go test -v ./...
RUN CGO_ENABLED=0 go build -o parcel-tracker .

FROM alpine:3.24 AS runtime
WORKDIR /app
COPY --from=builder /app/parcel-tracker .
COPY tracker.db .
ENTRYPOINT ["./parcel-tracker"]