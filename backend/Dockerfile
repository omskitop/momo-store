# Use the official Golang image as a build stage
FROM golang:1.20 AS builder

# Set environment variables for static build
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code into the container and build the Go application
COPY . .
RUN go build -o api ./cmd/api

# Start a new stage from scratch
FROM scratch

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/api /app/api

# Command to run the Go application
CMD ["/app/api"]