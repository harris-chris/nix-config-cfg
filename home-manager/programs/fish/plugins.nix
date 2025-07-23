{ pkgs }:

let
  bobthefish = {
    name = "theme-bobthefish";
    src  = pkgs.fetchFromGitHub {
      owner  = "oh-my-fish";
      repo   = "theme-bobthefish";
      rev    = "76cac812064fa749ffc258a20398c6f6250860c5";
      sha256 = "sha256-7nZ25R75WsSPqSmyeJbRQ49cITxL3D5CfyplsixFlY8=";
    };
  };
in
{
  theme  = bobthefish;
  prompt = builtins.readFile "${bobthefish.src.out}/functions/fish_prompt.fish";
}

