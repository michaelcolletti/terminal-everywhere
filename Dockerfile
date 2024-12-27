FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Zig 0.13.0
RUN curl -L https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz | tar -xJ
ENV PATH="/zig-linux-x86_64-0.13.0:${PATH}"

# Ghostty dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    pkg-config \
    libxcb-randr0-dev \
    libxcb-xfixes0-dev \
    libxcb-render0-dev \
    libxcb-shape0-dev \
    libxcb-xkb-dev \
    libfontconfig-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone and build Ghostty
RUN git clone https://github.com/ghostty-org/ghostty.git \
    && cd ghostty \
    && zig build 

#-Doptimize=ReleaseSafe

WORKDIR /app
COPY . .

#CMD ["./start.sh"]
#CMD ["./ghostty.sh"]
