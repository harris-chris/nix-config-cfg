{ lib, buildNpmPackage, fetchzip, nodejs_20 }:

buildNpmPackage rec {
  pname = "claude-code";
  version = "2.0.55";

  nodejs = nodejs_20;

  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-XK+B3oGrcnAi19a7Ttgv2Zpx0+M/nDQenhHQWESumZE=";
  };

  npmDepsHash = "sha256-wsjOkNxuBLMYprjaZQyUZHiqWl8UG7cZ1njkyKZpRYg=";

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
