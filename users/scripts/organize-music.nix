{ pkgs, python3Packages }:

python3Packages.buildPythonApplication {
    pname = "organize-music";
    version = "0.2.0";

    format = "other";
    src = ./organize-music.py;

    dontBuild = true;
    dontUnpack = true;

    nativeBuildInputs = [ pkgs.makeWrapper ];

#    dependencies = with python3Packages; [
#        mutagen
#    ];

    installPhase = ''
        mkdir -p $out/bin

        makeWrapper ${python3Packages.python.withPackages (ps: with ps; [
            mutagen
        ])}/bin/python $out/bin/organize-music --add-flags $src
    '';
}
