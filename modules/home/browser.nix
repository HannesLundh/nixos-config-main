{
  inputs,
  pkgs,
  host,
  ...
}:
{
  home.packages = (
    with pkgs;
    [
      firefox
      # pkgs.librewolf
    ]
  );
}
