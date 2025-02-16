FROM golang:1.20 AS builder
# Set environment variables for static build
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64
WORKDIR /app
COPY backend/go.mod backend/go.sum ./
RUN go mod download
COPY backend/. .
RUN go build -o api ./cmd/api

FROM scratch
COPY --from=builder /app/api /app/api
CMD ["/app/api"]