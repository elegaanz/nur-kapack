{ stdenv, fetchFromGitLab
, meson, ninja, pkgconfig
, simgrid, intervalset, boost, rapidjson, redox, zeromq, docopt_cpp, pugixml
, debug ? false
}:

stdenv.mkDerivation rec {
  pname = "batsim";
  version = "4.0.0";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "batsim";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lr3vawdbmajisgvbj5cjqw0wfy9y990yhl20kplarambx40nplp";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];
  # runtimeDeps is used to generate multi-layered docker contained
  runtimeDeps = [
    simgrid
    intervalset
    rapidjson
    redox
    zeromq
    docopt_cpp
    pugixml
  ];
  buildInputs = [
    boost
  ] ++ runtimeDeps;

  mesonBuildType = if debug then "debug" else "release";
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An infrastructure simulator that focuses on resource management techniques.";
    homepage = "https://framagit.org/batsim/batsim";
    platforms = platforms.all;
    license = licenses.lgpl3;
    broken = false;

    longDescription = ''
      Batsim is an infrastructure simulator that enables the study of resource management techniques.
    '';
  };
}