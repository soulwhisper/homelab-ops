set quiet := true
set shell := ['bash', '-euo', 'pipefail', '-c']

[private]
default:
  @just --list

[doc('Init Archlinux workstation')]
workstation:
  @echo "Install pacman packages"
  sudo pacman -Syuq --needed --noconfirm --noprogressbar $(cat Archfile | xargs)
  @echo "Install yay packages"
  yay -Syuq --needed --noconfirm --noprogressbar $(cat Yayfile | xargs)
  @echo "Install krew packages"
  fish_add_path $HOME/.krew/bin
  kubectl krew index add default https://github.com/kubernetes-sigs/krew-index.git
  kubectl krew index add netshoot https://github.com/nilic/kubectl-netshoot.git
  kubectl krew install $(cat Krewfile | xargs)
  go install github.com/mirceanton/kubectl-switch/v2@latest
  fish_add_path $HOME/go/bin
  @echo "Import configs"
  [ -f .config.zip ] && unzip -oq .config.zip -d "$HOME"
  @echo "Set fish aliases"
  fish -i -c "alias --save k=kubectl"
  fish -i -c "alias --save kc='kubectl switch context'"
  fish -i -c "alias --save kns='kubectl switch ns'"
  fish -i -c "alias --save ks=kubescape"
  fish -i -c "alias --save kubectl='kubecolor --kubecolor-theme=protanopia-dark'"
  fish -i -c "alias --save watch='viddy --disable_auto_save --differences --interval 2 --shell fish'"
  fish -i -c "alias --save kyaml='kubectl $argv -o yaml | kubectl neat'"
  fish -i -c "alias --save flux-local='uvx flux-local'"
  @echo "Workstation setup complete"
