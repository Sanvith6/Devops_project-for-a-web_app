# Build stage
FROM golang:1.22 AS base

WORKDIR /app

COPY go.mod .
RUN go mod download

COPY . .
# Build binary inside /app so paths match
RUN go build -o /app/main .

# Final stage with Distroless image
FROM gcr.io/distroless/base

WORKDIR /app

# Copy binary and static folder
COPY --from=base /app/main .
COPY --from=base /app/static ./static

EXPOSE 8050

CMD ["./main"]
