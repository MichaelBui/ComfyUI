#!/bin/bash

################################################################################
# WAN 2.1 with InfinityTalk Uninstallation for Vast.AI
#
# Usage: ./lib/wan-uninstall.sh
# This removes WAN-specific models and nodes
################################################################################

set -e  # Exit on error

# Source install script to get model arrays
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/wan-install.sh"

function uninstall_wan() {
    printf "\n=== Uninstalling WAN 2.1 + InfinityTalk Models and Nodes ===\n\n"
    
    # Remove WAN-specific custom nodes
    printf "Removing WAN custom nodes...\n"
    rm -rf /opt/ComfyUI/custom_nodes/ComfyUI-WanVideoWrapper
    rm -rf /opt/ComfyUI/custom_nodes/ComfyUI-VideoHelperSuite
    rm -rf /opt/ComfyUI/custom_nodes/ComfyUI-MelBandRoFormer
    printf "✓ Nodes removed\n\n"
    
    # Remove WAN models using declarative arrays from install script
    printf "Removing WAN models...\n"
    local total_models=${#WAN_MODELS_DEST[@]}
    local removed_count=0
    
    for ((i=0; i<$total_models; i++)); do
        local dest_path="/workspace/storage/stable_diffusion/models/${WAN_MODELS_DEST[$i]}"
        local description="${WAN_MODELS_DESC[$i]}"
        
        if [[ -f "$dest_path" ]]; then
            rm -f "$dest_path"
            removed_count=$((removed_count + 1))
            printf "  [%d/%d] Removed: %s\n" "$((i+1))" "$total_models" "$description"
        else
            printf "  [%d/%d] Not found (skipping): %s\n" "$((i+1))" "$total_models" "$description"
        fi
    done
    
    printf "\n✓ WAN uninstallation complete (%d files removed)\n\n" "$removed_count"
}

# Execute if run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    uninstall_wan
fi

