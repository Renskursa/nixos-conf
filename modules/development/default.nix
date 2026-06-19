{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # Editors
    vscode
    neovim
    vim
    helix
    zed-editor

    # Terminal
    ghostty
    kitty
    tmux
    zellij
    starship
    zoxide
    fzf
    bat
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
    gitui

    # JavaScript/TypeScript
    nodejs_22
    bun
    deno
    pnpm
    yarn
    typescript
    nodePackages.typescript-language-server
    biome

    # Python
    python312
    python312Packages.pip
    python312Packages.virtualenv
    python312Packages.ipython
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
    direnv
    nix-direnv
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
