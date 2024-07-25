{
  lib,
  fetchFromGitHub,
  nur,
}:

nur.repos.Samuel-Martineau.buildFirefoxExtension rec {
  pname = "multi-account-containers";
  version = "8.1.3";
  addonId = "@testpilot-containers";

  webextBuildFlags = [ "--source-dir=src" ];

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = version;
    hash = "sha256-DdwTWY5TcASd6KukHeaf9YmFWCfh4BFrTrLbzm+auEY=";
    fetchSubmodules = true;
  };

  meta = with lib; {
    description = "Firefox Multi-Account Containers lets you keep parts of your online life separated into color-coded tabs that preserve your privacy. Cookies are separated by container, allowing you to use the web with multiple identities or accounts simultaneously.";
    homepage = "https://github.com/mozilla/multi-account-containers";
    license = licenses.mpl20;
  };
}
