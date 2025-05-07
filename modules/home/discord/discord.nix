{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Uncomment the following line to enable Discord with Vencord
    discord
    (discord.override {
      withVencord = true;
    })
    # Alternatively, you can use WebCord with Vencord
    # webcord-vencord
  ];
  xdg.configFile."Vencord/themes/gruvbox.theme.css".source = ./gruvbox.css;
}
