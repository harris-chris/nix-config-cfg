{ lib, buildNpmPackage, fetchzip, nodejs_20 }:

buildNpmPackage rec {
  pname = "claude-code";
  version = "1.0.59";

  nodejs = nodejs_20;

  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-9Y4I3yKHY30O98MXufmx+maFJw2PLu5ceGJw3yyIFH4=";
  };

  npmDepsHash = "sha256-vxWiLkFhN6PHPgqRJFUvroP4Gn3UNdRpA+sSd9oSiyE=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';


  dontNpmBuild = true;
  AUTHORIZED = "1";

  postInstall = ''
    wrapProgram $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1 \
      --unset DEV
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ malo omarjatoi ];
    mainProgram = "claude";
  };
}