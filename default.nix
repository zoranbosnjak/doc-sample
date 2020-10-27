{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs {}
}:

let
  tex = pkgs.texlive.combined.scheme-full;

  sphinx = pkgs.callPackage ./nix/sphinx { inherit pkgs; };

  deps = with pkgs; [
    sphinx
    tex
  ];

  fontconf = pkgs.makeFontsConf { fontDirectories = [
    pkgs.texlive.cm.pkgs
    pkgs.texlive.dejavu.pkgs
    pkgs.texlive.dejavu-otf.pkgs
  ]; };

  envVars = ''
    export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive"
  '';

  src = builtins.filterSource
    (path: type: type != "directory" || baseNameOf path != ".git")
    ./.;

  drv = pkgs.stdenv.mkDerivation {
    name = "sample";
    version = "0.1.0";
    src = src;
    buildInputs = deps;
    preBuild = envVars;
    FONTCONFIG_FILE = fontconf;
    buildPhase = ''
      mkdir -p $out
      make latexpdf
    '';
    installPhase = ''
      mkdir -p $out
      cp _build/latex/*pdf $out
    '';
  };

  env = pkgs.stdenv.mkDerivation {
    name = "sample-environment";
    buildInputs = deps;
    shellHook = envVars;
    FONTCONFIG_FILE = fontconf;
  };

in
  if pkgs.lib.inNixShell then env else drv

