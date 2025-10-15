ARG RUST_VERSION=1.89.0
ARG CARGO_CHEF_VERSION=0.1.72

FROM --platform=$BUILDPLATFORM lukemathwalker/cargo-chef:${CARGO_CHEF_VERSION}-rust-${RUST_VERSION}-alpine AS chef
WORKDIR /app

FROM --platform=$BUILDPLATFORM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json --bin frontdoor

FROM --platform=$BUILDPLATFORM chef AS builder
COPY --from=planner /app/recipe.json recipe.json

ARG TARGETPLATFORM
RUN case $TARGETPLATFORM in \
  linux/amd64) \
  echo "export RUSTUP_TARGET=x86_64-unknown-linux-musl" >> /envfile; \
  echo "export CC_x86_64_unknown_linux_musl=clang" >> /envfile; \
  echo "export CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_RUSTFLAGS=\"-Clink-self-contained=yes -Clinker=rust-lld\"" >> /envfile; \
  ;; \
  linux/arm64) \
  echo "export RUSTUP_TARGET=aarch64-unknown-linux-musl" >> /envfile; \
  echo "export CC_aarch64_unknown_linux_musl=clang" >> /envfile; \
  echo "export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_RUSTFLAGS=\"-Clink-self-contained=yes -Clinker=rust-lld\"" >> /envfile; \
  ;; \
  *) \
  echo "TARGETPLATFORM $(TARGETPLATFORM) not supported, exiting"; \
  exit 1; \
  ;; \
  esac

RUN apk update && apk upgrade
RUN apk add musl-dev clang curl
RUN . /envfile; rustup target add $RUSTUP_TARGET
# Build dependencies - this is the caching Docker layer!
RUN . /envfile; cargo chef cook --release --recipe-path recipe.json --target $RUSTUP_TARGET;
# Build application
COPY . .
RUN . /envfile; cargo build --release --target $RUSTUP_TARGET --bin frontdoor; \
RUN . /envfile; cp /app/target/$RUSTUP_TARGET/release/frontdoor /usr/local/bin/frontdoor;

FROM gcr.io/distroless/static-debian12 AS runtime

COPY --from=builder /usr/local/bin/frontdoor /usr/local/bin/frontdoor
CMD ["/usr/local/bin/frontdoor"]