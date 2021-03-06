{ config, lib, pkgs, ... }:
let
  pkgs_lists = import ../config/my_pkgs_list.nix { inherit pkgs; };
  cfg = config.environment.mickours.development;
in
  with lib;
  {
    options.environments.mickours.development = {
      enable = mkEnableOption "development";
      keys = mkOption {
        type = types.listOf types.string;
        default = [];
        example = [];
        description = ''
          The list of Ssh keys allowed to log.
        '';
      };
    };

    config = mkIf config.environments.mickours.development.enable {
      environment.systemPackages = pkgs_lists.development;

      nix = {
        # make sure dependencies are well defined
        useSandbox = true;

        # keep build dpendencies to enable offline rebuild
        extraOptions = ''
          gc-keep-outputs = true
          gc-keep-derivations = true
        '';
      };

      nixpkgs.config.allowUnfree = true;

      nix.buildCores = 0;
    };
  }
