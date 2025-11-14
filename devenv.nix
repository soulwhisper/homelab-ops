{
  lib,
  pkgs,
  config,
  ...
}:
{
  env.KUBECONFIG = "./infrastructure/talos/clusterconfig/kubeconfig";
  env.TALOSCONFIG = "./infrastructure/talos/clusterconfig/talosconfig";
  env.KUBECONFIG_DIR = "$HOME/.kube";
  env.FLUX_SYSTEM_NAMESPACE = "gitops-system";
  env.ROOK_OPERATOR_NAMESPACE = "storage-system";
  env.ROOK_CLUSTER_NAMESPACE = "storage-system";

  # replace pre-commit and various linters
  git-hooks = {
    exclude = ".github\/.*";
    hooks = {
      prettier = {
        enable = true;
        settings = {
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
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
