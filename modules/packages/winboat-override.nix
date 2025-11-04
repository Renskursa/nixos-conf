self: super: {
  winboat = super.winboat.overrideAttrs (old: {
    src = old.src.overrideAttrs (_: {
      outputHash = "sha256-4NV9nyFLYJt9tz3ikDTb1oSpJGAKr1I49D0VHqpty3I=";
    });
  });
}
