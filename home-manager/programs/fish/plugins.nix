{ pkgs }:

let
  bobthefish = {
    name = "theme-bobthefish";
    src  = pkgs.fetchFromGitHub {
      owner  = "oh-my-fish";
      repo   = "theme-bobthefish";
      rev    = "76cac812064fa749ffc258a20398c6f6250860c5";
      sha256 = "1nvazfyz7vk37nska7yw94kknv8jbsqwzz3ybwbnhsnf98xlir0r";
    };
  };
in
{
  theme  = bobthefish;
  prompt = builtins.readFile "${bobthefish.src.out}/fish_prompt.fish";
}

