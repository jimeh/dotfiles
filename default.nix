let
  flake = builtins.getFlake "git+file://${builtins.toString ./.}";
in
flake.packages.${builtins.currentSystem}.default
