#!/bin/bash

echo "$(whoami)@$(hostname)"
echo ""

if [ -f /etc/os-release ]; then
  source /etc/os-release
  echo "OS: $NAME $(uname -m)"
else
  echo "OS: Unknown"
fi

product_name_file="/sys/class/dmi/id/product_name"
product_version_file="/sys/class/dmi/id/product_version"

product_name="Unknown"
product_version="Unknown"

if [ -f "$product_name_file" ]; then
  product_name=$(cat "$product_name_file" | sed 's/ *$//')
fi

if [ -f "$product_version_file" ]; then
  product_version=$(cat "$product_version_file")
fi

echo "Host: $product_name ($product_version)"
echo "Kernel: $(uname -s) $(uname -r)"
uptime -p | sed 's/up/Uptime:/'

if command -v pacman >/dev/null 2>&1; then
  pkg_count=$(pacman -Qq | wc -l)
  branch=$(grep '^Branch =' /etc/pacman-mirrors.conf 2>/dev/null | cut -d' ' -f3 || echo stable)
  echo "Packages: $pkg_count (pacman)[$branch]"
else
  echo "Packages: pacman not found"
fi

shell_name=$(basename "$SHELL")
bash_version="${BASH_VERSION:-N/A}"
echo "Shell: $shell_name $bash_version"

cpu_model=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2- | sed 's/^ //')
cpu_count=$(grep -c '^processor' /proc/cpuinfo)
cpu_ghz=$(awk -F: '/cpu MHz/ {printf "%.2f", $2/1000; exit}' /proc/cpuinfo)
echo "CPU: $cpu_model ($cpu_count) @ ${cpu_ghz} GHz"

if command -v lspci >/dev/null 2>&1; then
  mapfile -t gpus < <(lspci | grep -E 'VGA|3D')
  for ((i=0; i<${#gpus[@]}; i++)); do
    gpu=$(echo "${gpus[i]}" | cut -d ':' -f3- | sed 's/^ //; s/ (rev.*//')
    echo "GPU $((i+1)): $gpu"
  done

  wifi=$(lspci | grep -i 'network' | cut -d ':' -f3- | sed 's/^ //')
  if [ -n "$wifi" ]; then
    echo "Wifi adapter: $wifi"
  else
    echo "Wifi adapter: Not found"
  fi
else
  echo "lspci command not found."
fi

echo "Locale: $LANG"
