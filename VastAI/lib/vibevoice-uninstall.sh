#!/bin/bash

################################################################################
# VibeVoice Uninstallation for Vast.AI
#
# Usage: ./lib/vibevoice-uninstall.sh
# This removes VibeVoice-specific models and nodes
################################################################################

set -e  # Exit on error

# Source install script to get model arrays
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/vibevoice-install.sh"

function uninstall_vibevoice() {
    printf "\n=== Uninstalling VibeVoice Models and Nodes ===\n\n"
    
    # Remove TTS-Audio-Suite node
    printf "Removing TTS-Audio-Suite custom node...\n"
    rm -rf /opt/ComfyUI/custom_nodes/TTS-Audio-Suite
    printf "✓ Node removed\n\n"
    
    # Remove VibeVoice models using declarative arrays from install script
    printf "Removing VibeVoice models...\n"
    local total_models=${#VIBEVOICE_MODEL_DESTS[@]}
    local removed_count=0
    
    for ((i=0; i<$total_models; i++)); do
        local dest_path="/workspace/ComfyUI/models/${VIBEVOICE_MODEL_DESTS[$i]}"
        local description="${VIBEVOICE_MODEL_DESCS[$i]}"
        
        if [[ -f "$dest_path" ]]; then
            rm -f "$dest_path"
            removed_count=$((removed_count + 1))
            printf "  [%d/%d] Removed: %s\n" "$((i+1))" "$total_models" "$description"
        else
            printf "  [%d/%d] Not found (skipping): %s\n" "$((i+1))" "$total_models" "$description"
        fi
    done
    
    # Remove configuration files
    printf "\nRemoving configuration files...\n"
    local config_dir="/workspace/ComfyUI/models/TTS/VibeVoice/vibevoice-1.5B"
    
    for file in "${VIBEVOICE_CONFIG_FILES[@]}"; do
        local filepath="$config_dir/$file"
        if [[ -f "$filepath" ]]; then
            rm -f "$filepath"
            printf "  Removed: %s\n" "$file"
        fi
    done
    
    # Remove directory if empty
    if [[ -d "$config_dir" ]] && [[ -z "$(ls -A "$config_dir")" ]]; then
        rmdir "$config_dir"
        printf "  Removed empty directory: vibevoice-1.5B\n"
    fi
    
    printf "\n✓ VibeVoice uninstallation complete (%d models removed)\n\n" "$removed_count"
}

# Execute if run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    uninstall_vibevoice
fi
