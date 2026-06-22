{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # Editors
    vscode
    neovim
    helix
    zed-editor

    # Terminal
    ghostty
    tmux
    zoxide
    fzf
    eza
    ripgrep
    fd
    jq
    yq
    delta

    # Git
    git
    gh
    lazygit
    git-lfs

    # JavaScript/TypeScript
    nodejs_22
    bun
    deno
    pnpm
    yarn
    typescript
    typescript-language-server
    biome

    # Python
    python313
    python313Packages.pip
    python313Packages.virtualenv
    python313Packages.ipython
    uv
    ruff
    pyright

    # Rust
    rustup
    rust-analyzer
    cargo-watch
    cargo-edit

    # Go
    go
    gopls
    golangci-lint
    delve

    # C/C++
    gcc
    clang
    cmake
    gnumake
    ninja
    gdb
    lldb
    clang-tools
    valgrind

    # Java
    temurin-bin-21
    gradle
    maven

    # Zig
    zig
    zls

    # Build tools
    pkg-config
    autoconf
    automake
    libtool
    meson
    openssl
    sqlite

    # Common build deps
    zlib
    libffi
    readline
    ncurses
    libxml2
    libyaml
    bzip2
    xz
    glib
    pcre2
    icu
    libiconv
    flex
    bison
    gettext
    m4
    perl
    patch
    binutils
    elfutils
    strace
    ltrace

    # Containers
    docker-compose
    kubectl
    k9s
    helm
    terraform

    # Cloud
    awscli2
    google-cloud-sdk

    # Database
    dbeaver-bin
    pgcli

    # API
    insomnia
    httpie

    # Misc
    just
    hyperfine
    tokei
    mkcert
    pre-commit
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";
    GOPATH = "$HOME/go";
  };

  environment.shellAliases = {
    g = "git";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gl = "git pull";
    gd = "git diff";

    ls = "eza --icons";
    ll = "eza -la --icons";
    lt = "eza --tree --icons";
    cat = "bat";
    grep = "rg";
    find = "fd";
    cd = "z";

    dc = "docker-compose";
    k = "kubectl";

    nrs = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    nfu = "nix flake update /etc/nixos";
  };
}
