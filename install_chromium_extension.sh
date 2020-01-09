#!/bin/bash

install_chromium_extension () {
   
  preferences_dir_path="~/.config/chromium/Default/Extensions"
  pref_file_path="$preferences_dir_path/$1.json"
  upd_url="https://clients2.google.com/service/update2/crx"
  mkdir -p "$preferences_dir_path"
  echo "{" > "$pref_file_path"
  echo "  \"external_update_url\": \"$upd_url\"" >> "$pref_file_path"
  echo "}" >> "$pref_file_path"
  echo Added \""$pref_file_path"\" ["$2"]
}

install_chromium_extension "aeblfdkhhhdcdjpifhhbdiojplfjncoa" "1passwordX"
