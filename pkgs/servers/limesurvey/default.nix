{ stdenv, fetchFromGitHub, writeText, nixosTests, nixos-icons }:

stdenv.mkDerivation rec {
  pname = "limesurvey";
  version = "3.23.0+200813";

  src = fetchFromGitHub {
    owner = "LimeSurvey";
    repo = "LimeSurvey";
    rev = version;
    sha256 = "0r260z40g6b2bsfzxgfwdffbs17bl784xsc67n7q8222rs601hxf";
  };

  nixos-artwork = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixos-artwork";
    rev = "5ea155993a4a0f6bb91d52ef2e0b8ffe9194167d";
    sha256 = "15jhlnfcd9z5xla9cp1fcz6s8aask8bik720rvfn1vljyzs0fdvv";
  };

  phpConfig = writeText "config.php" ''
  <?php
    return require(getenv('LIMESURVEY_CONFIG'));
  ?>
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/limesurvey
    cp -r . $out/share/limesurvey

    # hack in the nixos logo
    mkdir -p $out/share/limesurvey/upload/themes/survey/generalfiles/
    cp ${nixos-artwork}/logo/nixos.svg $out/share/limesurvey/upload/themes/survey/generalfiles/

    cp ${phpConfig} $out/share/limesurvey/application/config/config.php

    runHook postInstall
  '';

  passthru.tests = {
    smoke-test = nixosTests.limesurvey;
  };

  meta = with stdenv.lib; {
    description = "Open source survey application";
    license = licenses.gpl2;
    homepage = "https://www.limesurvey.org";
    maintainers = with maintainers; [offline];
    platforms = with platforms; unix;
  };
}
