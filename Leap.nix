#  https://unix.stackexchange.com/questions/522822/different-methods-to-run-a-non-nixos-executable-on-nixos/522823#522823 
{ stdenv, lib, coreutils, dpkg, glibc, gcc-unwrapped, autoPatchelfHook, callPackage, gtk2-x11
  , libdbusmenu
  , xorg
  , libGL
  , cairo
  , alsa-lib
  , sqlite
  , libxslt
  , libGLU
  , xml2
  , zlib
  , glib
}:
let

  # Please keep the version x.y.0.z and do not update to x.y.76.z because the
  # source of the latter disappears much faster.
  version = "0.0.0";

  src = ./Leap-2.3.1+31549-x64.deb;

in stdenv.mkDerivation {
  name = "Leap-${version}";

  system = "x86_64-linux";

  inherit src;

  # Required for compilation
  nativeBuildInputs = [
    autoPatchelfHook # Automatically setup the loader, and do the magic
    dpkg
  ];

  # Required at running time
  buildInputs = [
    stdenv
    coreutils
    glibc
    gcc-unwrapped
    gtk2-x11
    libdbusmenu
    xorg.libxcb
    libGL
    xorg.libXcursor
    cairo
    xorg.libXext
    alsa-lib
    sqlite
    xorg.libSM
    libxslt
    xorg.libICE
    libGLU
    xml2
    xorg.libXi
    xorg.libXrandr
    xorg.libX11
    zlib
    glib
  ];

  unpackPhase = "true";


  # cp -av $out/opt/Wolfram/WolframScript/* $out
  # rm -rf $out/opt
  #
  # Extract and copy executable in $out/bin
  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
  '';

  meta = with lib; {
    description = "Leap";
    homepage = https://ultraleap.com;
    license = licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
