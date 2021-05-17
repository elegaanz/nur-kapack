{ stdenv, fetchFromGitLab
, meson, ninja, pkgconfig
, simgrid, intervalset, boost, rapidjson, redox, hiredis, libev, zeromq, docopt_cpp, pugixml
, debug ? false
}:

stdenv.mkDerivation rec {
  pname = "batsim";
  version = "3.1.0";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "batsim";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yyga9mj76k316rm4qp2sjhgkm03213d855n2j8fjnd2ikdj7zm6";
  };

  # Temporary hack. Meson is no longer able to pick up Boost automatically.
  # https://github.com/NixOS/nixpkgs/issues/86131
  BOOST_INCLUDEDIR = "${stdenv.lib.getDev boost}/include";
  BOOST_LIBRARYDIR = "${stdenv.lib.getLib boost}/lib";

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];
  # runtimeDeps is used to generate multi-layered docker contained
  runtimeDeps = [
    simgrid
    intervalset
    boost
    rapidjson
    redox
    hiredis
    libev
    zeromq
    docopt_cpp
    pugixml
  ];
  buildInputs = runtimeDeps;

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
