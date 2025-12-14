{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.sleek;
    colorScheme = "Elementary";
    spicetifyPackage = pkgs.spicetify-cli;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle
      fullAppDisplay
      playNext
      playlistIcons
      fullAlbumDate
      volumePercentage
      keyboardShortcut
      autoSkipExplicit
      bookmark
      autoSkipVideo
      beautifulLyrics
      trashbin
    ];
  };
}
