#!/bin/bash

# Ghostty Shader Color Preset Updater
# Interactive menu-driven color theme selector

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRESET_FILE="$SCRIPT_DIR/color-presets.conf"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

clear

echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  ${BOLD}Ghostty Shader Color Theme Selector${NC}${CYAN}  ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
echo ""

# Get available presets
PRESETS=()
while IFS= read -r preset; do
    PRESETS+=("$preset")
done < <(grep -E "^[a-z-]+\|" "$PRESET_FILE" | cut -d'|' -f1 | sort -u)

if [ ${#PRESETS[@]} -eq 0 ]; then
    echo -e "${RED}Error: No presets found in $PRESET_FILE${NC}"
    exit 1
fi

echo -e "${BOLD}Available Themes:${NC}"
echo ""

# Display menu with descriptions
idx=1
for preset in "${PRESETS[@]}"; do
    case $preset in
        neon-ice-fire)
            desc="Extreme contrast - Electric cyan + Hot orange"
            ;;
        subtle-ice-fire)
            desc="Gentle balance - Soft blues with warm accents"
            ;;
        fire-heavy)
            desc="Warm dominant - Oranges and reds take over"
            ;;
        purple-ice)
            desc="Fantasy vibes - Purple crystals + Pink fire"
            ;;
        matrix-green)
            desc="Classic Matrix - Green terminal aesthetic"
            ;;
        *)
            desc="Custom theme"
            ;;
    esac

    echo -e "  ${BOLD}$idx)${NC} ${YELLOW}$preset${NC}"
    echo -e "     ${CYAN}→${NC} $desc"
    echo ""
    ((idx++))
done

echo -e "  ${BOLD}0)${NC} ${RED}Exit${NC}"
echo ""
echo -ne "${BOLD}Select a theme [0-${#PRESETS[@]}]:${NC} "

read -r choice

# Validate input
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 0 ] || [ "$choice" -gt ${#PRESETS[@]} ]; then
    echo -e "\n${RED}Invalid selection. Exiting.${NC}"
    exit 1
fi

# Exit if 0
if [ "$choice" -eq 0 ]; then
    echo -e "\n${YELLOW}No changes made. Goodbye!${NC}"
    exit 0
fi

# Get selected preset
PRESET="${PRESETS[$((choice-1))]}"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Applying theme:${NC} ${YELLOW}$PRESET${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Function to get color from preset
get_color() {
    local var_name=$1
    grep "^${PRESET}|${var_name}|" "$PRESET_FILE" | cut -d'|' -f3
}

# Function to update a shader variable
update_shader() {
    local shader_file=$1
    local shader_var=$2
    local generic_var=$3

    local color_value=$(get_color "$generic_var")

    if [ -z "$color_value" ]; then
        return 1
    fi

    local shader_path="$SCRIPT_DIR/$shader_file"

    if [ ! -f "$shader_path" ]; then
        return 1
    fi

    if ! grep -q "const vec4 $shader_var = vec4(" "$shader_path"; then
        return 1
    fi

    sed -i.bak "s/const vec4 $shader_var = vec4([^)]*)/const vec4 $shader_var = vec4($color_value)/" "$shader_path"
    rm "${shader_path}.bak"

    echo -e "${GREEN}✓${NC} Updated ${BOLD}$shader_file${NC} ($shader_var)"
    return 0
}

# Update each shader file
updated_count=0

# cursor_blaze.glsl
update_shader "cursor_blaze.glsl" "TRAIL_COLOR" "ICE_MAIN" && ((updated_count++)) || true
update_shader "cursor_blaze.glsl" "TRAIL_COLOR_ACCENT" "FIRE_CORE" && ((updated_count++)) || true

# cursor_blaze_no_trail.glsl
update_shader "cursor_blaze_no_trail.glsl" "TRAIL_COLOR" "ICE_MAIN" && ((updated_count++)) || true
update_shader "cursor_blaze_no_trail.glsl" "TRAIL_COLOR_ACCENT" "FIRE_CORE" && ((updated_count++)) || true

# cursor_smear.glsl
update_shader "cursor_smear.glsl" "TRAIL_COLOR" "ICE_ELECTRIC" && ((updated_count++)) || true

# cursor_smear_fade.glsl
update_shader "cursor_smear_fade.glsl" "TRAIL_COLOR" "ICE_BRIGHT" && ((updated_count++)) || true

# cursor_tail.glsl
update_shader "cursor_tail.glsl" "TRAIL_COLOR" "ICE_FROZEN" && ((updated_count++)) || true

# cursor_sweep.glsl
update_shader "cursor_sweep.glsl" "TRAIL_COLOR" "ICE_GLOW" && ((updated_count++)) || true

# cursor_warp.glsl
update_shader "cursor_warp.glsl" "TRAIL_COLOR" "ICE_COOL" && ((updated_count++)) || true

# ripple_cursor.glsl
update_shader "ripple_cursor.glsl" "COLOR" "ICE_DEEP" && ((updated_count++)) || true

# sonic_boom_cursor.glsl
update_shader "sonic_boom_cursor.glsl" "COLOR" "ICE_FROST" && ((updated_count++)) || true

# rectangle_boom_cursor.glsl
update_shader "rectangle_boom_cursor.glsl" "COLOR" "ICE_GLOW_INTENSE" && ((updated_count++)) || true

# ripple_rectangle_cursor.glsl
update_shader "ripple_rectangle_cursor.glsl" "COLOR" "ICE_CRYSTAL" && ((updated_count++)) || true

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}✨ Success!${NC} Updated ${BOLD}$updated_count${NC} shader variable(s)"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Auto-reload Ghostty config
echo -e "${CYAN}🔄 Reloading Ghostty configuration...${NC}"

# Try multiple methods to reload Ghostty
if command -v ghostty &> /dev/null; then
    # Method 1: Use Ghostty CLI if available
    ghostty +reload-config &> /dev/null && echo -e "${GREEN}✓${NC} Config reloaded via CLI" || true
fi

# Method 2: Send Cmd+, via AppleScript (works if Ghostty is running)
if osascript -e 'tell application "System Events"
    if (name of processes) contains "Ghostty" then
        tell process "Ghostty"
            keystroke "," using {command down}
        end tell
        return true
    else
        return false
    end if
end tell' 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Config reloaded successfully"
else
    echo -e "${YELLOW}⚠${NC} Ghostty not running or reload failed - press ${BOLD}Cmd+,${NC} manually"
fi

echo ""
echo -e "${GREEN}🎨 Theme applied! Enjoy your new colors!${NC}"
echo ""
