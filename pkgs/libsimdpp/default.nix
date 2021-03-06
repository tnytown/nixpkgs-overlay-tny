{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, cmake
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  pname = "libsimdpp";

  # untagged revision, fixes hpp file installation
  version = "e71d2ca2d445db627308167cd551d4934af5f4af";

  src = fetchFromGitHub {
    owner = "p12tic";
    repo = "libsimdpp";
    rev = "${version}";
    sha256 = "sha256-DSPL/gKmwIKRwPAzsB4zBPgyo5cb8CD4Pg8R7fD6ZGk=";
  };

  # The XOP test succeeds for some reason on platforms where it should not succeed.
  # XOP is only supported on some Bulldozer CPUs anyways, so we disable it here.
  patchPhase = ''
    substituteInPlace cmake/SimdppMultiarch.cmake \
      --replace 'list(APPEND SIMDPP_ARCHS_PRI "X86_XOP")' ""
  '';

  postInstall = ''
    mkdir -p $out/share/libsimdpp
    cp ../cmake/SimdppMultiarch.cmake $out/share/libsimdpp/libsimdpp-config.cmake
    chmod u+w $out/share/libsimdpp/libsimdpp-config.cmake
    echo -e '\nset(LIBSIMDPP_INCLUDE_DIRS "${placeholder "out"}/include/libsimdpp-2.1")\n' >> $out/share/libsimdpp/libsimdpp-config.cmake
  '';

  nativeBuildInputs = [ cmake ] ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    platforms = platforms.unix;
  };
}
