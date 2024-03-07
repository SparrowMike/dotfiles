#!/usr/bin/env bash 

echo its working

plugin_path="$(tmux show-env -g TMUX_PLUGIN_MANAGER_PATH | cut -f2 -d=)"
# ls -1 "$plugin_path"

tmux_sessions="$(tmux list-sessions | awk '{print $1}')"
# echo "$tmux_sessions"


# List of items
items=("Item 1" "Item 2" "Item 3" "Item 4" "Item 5")

# Index of the selected item
selected=0


# Display the list in a popup window
# display_list() {
#     # Clear the screen
#     clear
#
#     # Loop through the items
#     for (( i=0; i<"${#items[@]}"; i++ )); do
#         # Highlight the selected item
#         if [ $i -eq $selected ]; then
#             echo "> ${items[$i]}"
#         else
#             echo "  ${items[$i]}"
#         fi
#     done
# }
#

# Handle user input
while false; do
    # tmux display-popup "$(display_list)"
    # tmux display-popup ls -1 "$plugin_path"
    tmux display-popup ls -1 "$tmux_sessions"


    # Read user input
    read -rsn1 key

    # Navigate through the list
    case "$key" in
        "A") ((selected--));;
        "B") ((selected++));;
        "")  break;;  # Exit loop on Enter key
    esac

    # Ensure selected index stays within bounds
    if [ $selected -lt 0 ]; then
        selected=$((${#items[@]} - 1))
    elif [ $selected -ge ${#items[@]} ]; then
        selected=0
    fi
done

# Perform action based on selected item
# echo "Selected item: ${items[$selected]}"

exit 0
