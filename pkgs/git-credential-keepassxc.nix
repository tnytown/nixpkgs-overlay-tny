{ lib, fetchFromGitHub, rustPlatform, targetPlatform, darwin }:
rustPlatform.buildRustPackage rec {
  pname = "git-credential-keepassxc";
  version = "0.8.1";

  buildInputs = lib.optionals (targetPlatform.isDarwin) [ darwin.apple_sdk.frameworks.IOKit ];
  src = fetchFromGitHub {
    owner = "Frederick888";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JhJu2/dcHBe1CAdMTMxlA0jA/wYQG3EBtf9POVe9SAQ=";
  };

  cargoSha256 = "sha256-62enbfDccfedPo0tICHPitDbZc+qu9t0Kh9kHeP/xzU=";

  meta = with lib; {
    description = "Helper that allows Git (and shell scripts) to use KeePassXC as credential store";
    homepage = "https://github.com/Frederick888/git-credential-keepassxc";
    license = licenses.gpl3Only;
    maintainers = [ "tny" ];
  };

  doCheck = false;
}