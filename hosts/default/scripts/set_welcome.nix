{ pkgs }:

pkgs.writeShellScriptBin "set_welcome.sh" '' 
#!/bin/sh
greetings=("Hello Yarych" "Wassupp myman" "Welcome" "Feeling good?" "Добрий день" "Здоров Панас" "Let's do some coding" "Ure ure ure" "Go touch some grass" "Get a job" "Omae wa mu sindeiru" "Get a life" "Nice weather innit?" "Доброго здоров'я" "Слава Ісусу Христу" "Здоров" "Хелоу" "Hello" "Greetings" "Go hard or go home" "Let's do it")

# Get the number of elements in the array
num_greets=''${#greetings[@]}

# Generate a random index between 0 and the last index of the array
random_index=$((RANDOM % num_greets))

greeting=''${greetings[$random_index]}

echo "$greeting"

echo "\$greeting = $greeting" > ~/.config/hypr/greeting.conf

sed -i  "s/^.*HeaderText=.*$/HeaderText=''${greeting}/" ~/nixos/hosts/default/sddm/sddm-sugar-dark/theme.conf
''
