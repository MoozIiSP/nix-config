{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.vscode-server;
in {
  options = {
    services.vscode-server = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = ''
          Whether to enable the vscode server autofix.
        '';
      };
    };
  };

  # TODO: check whether vscode installed.
  config = mkIf cfg.enable {
    systemd.services.vscode-server = {
      wantedBy = [ "default.target" ];
      description = "Automatically fix the VS Code server used by the remote SSH extension";
      serviceConfig = {
        # When a monitored directory is deleted, it will stop being monitored.
        # Even if it is later recreated it will not restart monitoring it.
        # Unfortunately the monitor does not kill itself when it stops monitoring,
        # so rather than creating our own restart mechanism, we leverage systemd to do this for us.
        Restart = "always";
        RestartSec = 0;
        ExecStart = pkgs.writeShellScript "nixos-vscode-server.sh" ''
          set -euo pipefail
          PATH=${makeBinPath (with pkgs; [ coreutils inotify-tools ])}
          # vs_dir=~/.vscode-server/bin
          vsi_dir=~/.vscode-server-insiders/bin
          # for vscode server insiders
          [[ -e $vsi_dir ]] &&
          find "$vsi_dir" -mindepth 2 -maxdepth 2 -name node -type f -exec ln -sfT ${pkgs.nodejs-14_x}/bin/node {} \; ||
          mkdir -p "$vsi_dir"
          while IFS=: read -r vsi_dir event; do
            # A new version of the VS Code Server is being created.
            if [[ $event == 'CREATE,ISDIR' ]]; then
              # Create a trigger to know when their node is being created and replace it for our symlink.
              touch "$vsi_dir/node"
              inotifywait -qq -e DELETE_SELF "$vsi_dir/node"
              ln -sfT ${pkgs.nodejs-14_x}/bin/node "$vsi_dir/node"
            # The monitored directory is deleted, e.g. when "Uninstall VS Code Server from Host" has been run.
            elif [[ $event == DELETE_SELF ]]; then
              # See the comments above Restart in the service config.
              exit 0
            fi
          done < <(inotifywait -q -m -e CREATE,ISDIR -e DELETE_SELF --format '%w%f:%e' "$vsi_dir")
        '';
      };
    };
  };
}