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
      #inputs.zen-browser.packages."${system}".default
      # pkgs.librewolf
    ]
  );
}
