{ pkgs, ... }:

{
  packages = with pkgs; [
    age
    betterleaks
    curl
    gh
    git
    jq
    opentofu
    sops
    worktrunk
    wrangler
  ];

  enterShell = ''
    export PATH="$DEVENV_ROOT/scripts:$PATH"
  '';
}
