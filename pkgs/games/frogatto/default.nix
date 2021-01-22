{ buildEnv, lib, stdenv, callPackage, makeWrapper, makeDesktopItem }:

let
  description = "Action-adventure game, starring a certain quixotic frog";
  engine = callPackage ./engine.nix { };
  data = callPackage ./data.nix { };
  desktopItem = makeDesktopItem {
    name = "frogatto";
    exec = "frogatto";
    startupNotify = "true";
    icon = "${data}/share/frogatto/modules/frogatto/images/os/frogatto-icon.png";
    comment = description;
    desktopName = "Frogatto";
    genericName = "frogatto";
    categories = "Game;ArcadeGame;";
  };
  pname = "frogatto-unstable";
  version = "2020-12-04";
in buildEnv {
  name = "${pname}-${version}"; # i don't know why this is needed

  buildInputs = [ makeWrapper ];
  paths = [ engine data desktopItem ];
  pathsToLink = [
    "/bin"
    "/share/frogatto/data"
    "/share/frogatto/images"
    "/share/frogatto/modules"
    "/share/applications"
  ];

  postBuild = ''
    wrapProgram $out/bin/frogatto \
      --run "cd $out/share/frogatto"
  '';

  meta = with lib; {
    broken = true;
    homepage = "https://frogatto.com";
    description = description;
    license = with licenses; [ cc-by-30 unfree ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ astro ];
  };
}
