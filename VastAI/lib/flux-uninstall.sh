#!/bin/bash

################################################################################
# Flux Uninstallation for Vast.AI
#
# Usage: ./lib/flux-uninstall.sh
# This removes Flux-specific models and nodes
################################################################################

set -e  # Exit on error

# Source install script to get model arrays
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/flux-install.sh"

function uninstall_flux() {
    printf "\n=== Uninstalling Flux Models and Nodes ===\n\n"
    
    # Remove Flux-specific custom nodes
    printf "Removing Flux custom nodes...\n"
    rm -rf /opt/ComfyUI/custom_nodes/ComfyUI-GGUF
    rm -rf /opt/ComfyUI/custom_nodes/ComfyUI-Apply_Style_Model_Adjust
    rm -rf /opt/ComfyUI/custom_nodes/ComfyUI-PuLID-Flux-Enhanced
    printf "✓ Nodes removed\n\n"
    
    # Remove Flux models using declarative arrays from install script
    printf "Removing Flux models...\n"
    local total_models=${#FLUX_MODEL_DESTS[@]}
    local removed_count=0
    
    for ((i=0; i<$total_models; i++)); do
        local dest_path="/workspace/storage/stable_diffusion/models/${FLUX_MODEL_DESTS[$i]}"
        local description="${FLUX_MODEL_DESCS[$i]}"
        
        if [[ -f "$dest_path" ]]; then
            rm -f "$dest_path"
            removed_count=$((removed_count + 1))
            printf "  [%d/%d] Removed: %s\n" "$((i+1))" "$total_models" "$description"
        else
            printf "  [%d/%d] Not found (skipping): %s\n" "$((i+1))" "$total_models" "$description"
        fi
    done
    
    printf "\n✓ Flux uninstallation complete (%d files removed)\n\n" "$removed_count"
}

# Execute if run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    uninstall_flux
fi
