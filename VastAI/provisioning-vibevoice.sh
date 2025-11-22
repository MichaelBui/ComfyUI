#!/bin/bash

################################################################################
# VibeVoice Provisioning Script for ai-dock/comfyui
#
# This is the main entry point for VibeVoice (TTS) setup on Vast.AI
# Upload this file to ai-dock as the provisioning script
#
# The script will:
# 1. Clone the ComfyUI repo to get lib files
# 2. Source common functions and VibeVoice-specific setup
# 3. Install QoL nodes, TTS-Audio-Suite, and VibeVoice models
################################################################################

# This file will be sourced in init.sh
set -e

# Determine the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# If running from ai-dock, clone the repo to get lib files
if [[ ! -d "$SCRIPT_DIR/lib" ]]; then
    printf "Cloning ComfyUI scripts repository...\n"
    cd /workspace
    git clone https://github.com/MichaelBui/ComfyUI.git comfyui-scripts || {
        printf "Failed to clone repository\n"
        exit 1
    }
    SCRIPT_DIR="/workspace/comfyui-scripts/VastAI"
fi

# Source common library
source "$SCRIPT_DIR/lib/common.sh"

# Source VibeVoice-specific library
source "$SCRIPT_DIR/lib/vibevoice-install.sh"

################################################################################
# Main Provisioning Function
################################################################################

function provisioning_start() {
    DISK_GB_AVAILABLE=$(($(df --output=avail -m "${WORKSPACE}" | tail -n1) / 1000))
    DISK_GB_USED=$(($(df --output=used -m "${WORKSPACE}" | tail -n1) / 1000))
    DISK_GB_ALLOCATED=$(($DISK_GB_AVAILABLE + $DISK_GB_USED))
    
    print_header "VibeVoice"
    
    # Install Python packages
    install_python_packages
    
    # Install QoL nodes (common across all setups)
    printf "\nInstalling QoL custom nodes...\n"
    get_nodes "${QOL_NODES[@]}"
    
    # Install VibeVoice-specific setup
    install_vibevoice
    
    # Create base directories and symlinks
    create_base_directories
    create_symlinks
    
    print_end
}

# Start provisioning
provisioning_start

