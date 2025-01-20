{
  lib,
  pkgs,
  ...
}:
{
  env.GREET = "home-ops";
  env.KUBECONFIG = "./kubernetes/kubeconfig";
  env.TALOSCONFIG = "./kubernetes/talos/clusterconfig/talosconfig";
  env.MINIJINJA_CONFIG_FILE = ".minijinja.toml";

  # dotenv.enable = true;

  # languages.python.enable = true;
  # languages.python.uv.enable = true;
  # languages.python.venv.enable = true;
  # languages.python.version = "3.12.2";

  # replace pre-commit and various linters
  git-hooks = {
    # exclude = "_assets\/.*";
    hooks = {
      actionlint = {
        enable = true;
        files = "github\/workflows\/.*\.(yml|yaml)$";
      };
      markdownlint = {
        # enable = true;
        files = "\.md$";
        settings.configuration = {
          MD013.line-length = 120;
          MD024.siblings-only = true;
          MD033 = false;
          MD034 = false;
        };
      };
      prettier = {
        enable = true;
        settings = {
          end-of-line = "lf";
          tab-width = 2;
          trailing-comma = "es5";
          use-tabs = false;
        };
      };
      yamllint = {
        enable = true;
        settings.configuration = ''
          ---
          extends: default
          rules:
            truthy:
              allowed-values: ["true", "false", "on"]
            comments:
              min-spaces-from-content: 1
            line-length: disable
            braces:
              min-spaces-inside: 0
              max-spaces-inside: 1
            brackets:
              min-spaces-inside: 0
              max-spaces-inside: 0
            indentation: enable
        '';
      };
      check-added-large-files.enable = true;
      check-merge-conflicts.enable = true;
      check-executables-have-shebangs.enable = true;
      end-of-file-fixer.enable = true;
      fix-byte-order-marker.enable = true;
      # pre-commit-hook-ensure-sops.enable = true;
      # pre-commit-hook-ensure-sops.files = "\.sops\.(toml|ya?ml)$";
      # shellcheck.enable = true;
      trim-trailing-whitespace.enable = true;
      mixed-line-endings.enable = true;
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
