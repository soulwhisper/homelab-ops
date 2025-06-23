#!/bin/vbash
# shellcheck shell=bash
# shellcheck source=/dev/null

dry_run=true

# Function to check and switch user context to vyattacfg if necessary
check_user_context() {
  if [[ "$(id -g -n)" != 'vyattacfg' ]]; then
    exec sg vyattacfg -c "/bin/vbash $(readlink -f "$0") $*"
  fi
}

# Function to parse command-line arguments
parse_arguments() {
  while getopts "c" options; do
    case "${options}" in
      c)
        echo 'Will commit changes'
        dry_run=false
        ;;
      *)
        echo 'Error in command line parsing' >&2
        exit 1
        ;;
    esac
  done
}

# Function to load environment variables from a .env file
load_env_vars() {
  if [[ -f "/config/.env" ]]; then
    mapfile environmentAsArray < <(
      cat /config/.env |
      grep --invert-match '^#' |
      grep --invert-match '^\s*$'
    )
    for variableDeclaration in "${environmentAsArray[@]}"; do
      export "${variableDeclaration//[$'\r\n']/}"
    done
  fi
}

# Function to apply environment to configuration files
apply_environment_to_configs() {
  restart_containers=""
  while IFS= read -r -d '' file; do
    cfgfile="${file%.tmpl}"
    shafile="${file}.sha256"

    if ! test -e "${shafile}"; then
      echo "rebuild" >"${shafile}"
    fi

    newsha=$(envsubst <"${file}" | shasum -a 256 | awk '{print $1}')
    oldsha=$(cat "${shafile}")

    if ! test "${newsha}" == "${oldsha}"; then
      echo "Configuration changed for ${file}"
      if ! "${dry_run}"; then
        envsubst <"${file}" >"${cfgfile}"
        echo "${newsha}" >"${shafile}"
        restart_containers="${restart_containers} $(echo "${file}" | awk -F / '{print $1}')"
      fi
    fi
  done < <(find containers -type f -name "*.tmpl" -print0)
}

# Function to load VyOS specific functions and reset configuration
load_vyos_config() {
  source /opt/vyatta/etc/functions/script-template
  load /opt/vyatta/etc/config.boot.default
}

# Function to process all shell scripts in the /config directory
process_config_scripts() {
  configure
  for f in /config/*.sh; do
    if [[ -f "${f}" ]]; then
      echo "Processing ${f}"
      source "${f}"
    fi
  done
}

# Function to commit and save configuration
commit_and_save() {
  if ! "${dry_run}"; then
    # Pull new container images
    mapfile -t AVAILABLE_IMAGES < <(run show container image | awk '{ if ( NR > 1  ) { print $1 ":" $2} }')
    mapfile -t CONFIG_IMAGES < <(sed -nr "s/set container name .* image '(.*)'/\1/p" /config/* | uniq)

    for image in "${CONFIG_IMAGES[@]}"; do
      if [[ ! " ${AVAILABLE_IMAGES[*]} " =~ \ ${image}\  ]]; then
        echo "Pulling image ${image}"
        run add container image "${image}"
      fi
    done

    # Commit and save configuration
    echo "Committing and saving config"
    commit
    save
  fi
}

# Function to clean obsolete container images
clean_obsolete_images() {
  IFS=$'\n' read -rd '' -a AVAILABLE_IMAGES <<<"$(run show container image | tail -n +2)"
  for image in "${AVAILABLE_IMAGES[@]}"; do
    image_name=$(echo "${image}" | awk '{ print $1 }')
    image_tag=$(echo "${image}" | awk '{ print $2 }')
    image_id=$(echo "${image}" | awk '{ print $3 }')
    image_name_tag="${image_name}:${image_tag}"

    if [[ ! " ${CONFIG_IMAGES[*]} " =~ \ ${image_name_tag}\  ]]; then
      echo "Removing container ${image_name_tag}"
      run delete container image "${image_id}"
    fi
  done
}

# Function to restart containers with updated configurations
restart_updated_containers() {
  for container in ${restart_containers}; do
    run restart container "${container}"
  done
}

# Function to clean up overlay directories
cleanup_overlay_folders() {
  sudo find "/config" -name "overlay*" -type d -prune -exec rm -rf "{}" \;
}

# Main function
main() {
  check_user_context
  parse_arguments "$@"
  load_env_vars
  apply_environment_to_configs
  load_vyos_config
  process_config_scripts

  echo "Changes to running config:"
  compare

  if "${dry_run}"; then
    exit 0
  else
    commit_and_save
    clean_obsolete_images
    restart_updated_containers
  fi

  cleanup_overlay_folders
}

# Execute the main function
main "$@"
