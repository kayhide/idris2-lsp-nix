{ lib
, stdenv
, fetchFromGitHub
, idris2
}:

let
  idris2-with-src = idris2.overrideAttrs (final: prev: {
    installPhase = ''
      runHook preInstall
      make install $makeFlags
      make install-with-src-libs $makeFlags IDRIS2_BOOT=$out/bin/idris2
      make install-with-src-api $makeFlags IDRIS2_BOOT=$out/bin/idris2
      runHook postInstall
    '';
  });
in

stdenv.mkDerivation rec {
  pname = "idris2-lsp";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "idris-community";
    repo = "idris2-lsp";
    rev = "idris2-0.6.0";
    sha256 = "sha256-pLh5qBKoi1phvoiaCbpgxs38xaXM1VfD5lQI70I5F38=";
  };

  makeFlags = idris2-with-src.makeFlags;

  buildInputs = [
    idris2-with-src
  ];

  meta = with lib; {
    description = "Language Server for Idris2";
    homepage = "https://github.com/idris-community/idris2-lsp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kayhide ];
    inherit (idris2-with-src.meta) platforms;
  };
}
