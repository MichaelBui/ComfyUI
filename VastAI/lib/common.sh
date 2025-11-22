#!/bin/bash

################################################################################
# Common Library for ComfyUI Vast.AI Provisioning
# 
# This file contains shared functions and configurations used by all
# provisioning scripts (Flux, VibeVoice, WAN+InfinityTalk)
#
# DO NOT run this file directly - it should be sourced by provisioning scripts
################################################################################

################################################################################
# Environment Variables (with defaults for standalone execution)
################################################################################

# These are normally provided by ai-dock/comfyui runtime
# But we set defaults for standalone script execution
: ${WORKSPACE:="/workspace"}
: ${AUTO_UPDATE:="true"}
: ${COMFYUI_VENV_PIP:="pip"}

# pip_install function compatible with ai-dock
function pip_install() {
    if [[ -z $MAMBA_BASE ]]; then
        "$COMFYUI_VENV_PIP" install --no-cache-dir "$@"
    else
        micromamba run -n comfyui pip install --no-cache-dir "$@"
    fi
}

################################################################################
# Python Packages (Common across all setups)
################################################################################

PYTHON_PACKAGES=(
    "insightface==0.7.3"
)

################################################################################
# QoL Custom Nodes (Common across all setups)
################################################################################

QOL_NODES=(
    # Core Management
    "https://github.com/ltdrdata/ComfyUI-Manager"
    
    # QoL Utilities
    "https://github.com/crystian/ComfyUI-Crystools"                 # System Stats
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"               # Utilities Suite
    "https://github.com/ltdrdata/ComfyUI-Inspire-Pack"              # Utilities Suite
    "https://github.com/WASasquatch/was-node-suite-comfyui"         # Utilities Suite
    "https://github.com/rgthree/rgthree-comfy"                      # Utilities Suite
    "https://github.com/cubiq/ComfyUI_essentials"                   # Essential Utilities
    "https://github.com/chrisgoringe/cg-use-everywhere"             # Anything Everywhere
    "https://github.com/Fannovel16/comfyui_controlnet_aux"          # Pre-Processors
    "https://github.com/pythongosssss/ComfyUI-Custom-Scripts"       # Export Workflow
    "https://github.com/kijai/ComfyUI-KJNodes"                      # Empty Latent
    "https://github.com/adieyal/comfyui-dynamicprompts"             # Dynamic Prompts
    "https://github.com/Jcd1230/rembg-comfyui-node"                 # Remove Background
    "https://github.com/erosDiffusion/ComfyUI-enricos-nodes"        # Image Compositor
)

################################################################################
# Shared Functions
################################################################################

# Get custom nodes with auto-update support
function get_nodes() {
    local nodes=("$@")
    
    for repo in "${nodes[@]}"; do
        dir="${repo##*/}"
        path="/opt/ComfyUI/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                    pip_install -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                pip_install -r "${requirements}"
            fi
        fi
    done
}

# Install Python packages
function install_python_packages() {
    if [ ${#PYTHON_PACKAGES[@]} -gt 0 ]; then
        pip_install ${PYTHON_PACKAGES[*]}
    fi
}

# Download model with size validation (idempotent)
# Usage: download_model <url> <dest_path> <expected_size> <description> <index> <total>
function download_model() {
    local url="$1"
    local dest_path="$2"
    local expected_size="$3"
    local description="$4"
    local index="${5:-}"
    local total="${6:-}"
    
    # Display progress if index and total provided
    if [[ -n "$index" ]] && [[ -n "$total" ]]; then
        printf "\n[%d/%d] %s\n" "$index" "$total" "$description"
    else
        printf "\n%s\n" "$description"
    fi
    
    # Check if file exists with correct size
    if [[ -f "$dest_path" ]]; then
        local actual_size=$(stat -c%s "$dest_path" 2>/dev/null || stat -f%z "$dest_path" 2>/dev/null || echo "0")
        
        if [[ "$actual_size" -eq "$expected_size" ]]; then
            printf "✓ Already downloaded with correct size, skipping\n"
            return 0
        else
            printf "⚠ Incomplete download detected (expected: %s, got: %s)\n" "$expected_size" "$actual_size"
            printf "  Removing incomplete file and re-downloading...\n"
            rm -f "$dest_path"
        fi
    fi
    
    # Download the file
    local dest_dir=$(dirname "$dest_path")
    mkdir -p "$dest_dir"
    printf "Downloading from HuggingFace...\n"
    wget -qnc --content-disposition --show-progress -e dotbytes="4M" -O "$dest_path" "$url" || {
        printf "✗ Failed to download: %s\n" "$description"
        return 1
    }
    
    # Verify downloaded file size
    local final_size=$(stat -c%s "$dest_path" 2>/dev/null || stat -f%z "$dest_path" 2>/dev/null || echo "0")
    if [[ "$final_size" -ne "$expected_size" ]]; then
        printf "✗ Download size mismatch! Expected: %s, Got: %s\n" "$expected_size" "$final_size"
        return 1
    fi
    
    printf "✓ Downloaded successfully\n"
}

# Legacy function for backwards compatibility (will be deprecated)
function get_models() {
    if [[ -z $2 ]]; then return 1; fi
    
    local dir="$1"
    mkdir -p "$dir"
    shift
    
    local arr=("$@")
    
    printf "Processing %s model(s) for %s...\n" "${#arr[@]}" "$dir"
    
    for url in "${arr[@]}"; do
        # Extract filename from URL
        local filename=$(basename "$url" | sed 's/?download=true//')
        local filepath="$dir/$filename"
        
        # Check if file already exists
        if [[ -f "$filepath" ]]; then
            printf "✓ Already exists (skipping): %s\n" "$filename"
        else
            printf "Downloading: %s\n" "${url}"
            provisioning_download "${url}" "${dir}"
        fi
    done
    printf "\n"
}

# Download from $1 URL to $2 directory
function provisioning_download() {
    wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
}

# Print provisioning header
function print_header() {
    local purpose="$1"
    printf "\n##############################################\n"
    printf "#                                            #\n"
    printf "#    Provisioning ComfyUI for %-14s#\n" "$purpose"
    printf "#                                            #\n"
    printf "#         This will take some time           #\n"
    printf "#                                            #\n"
    printf "# Your container will be ready on completion #\n"
    printf "#                                            #\n"
    printf "##############################################\n\n"
}

# Print provisioning end
function print_end() {
    printf "\nProvisioning complete: Web UI will start now\n\n"
}

# Create necessary directories
function create_base_directories() {
    mkdir -p /workspace/storage/stable_diffusion/models/unet
    mkdir -p /workspace/storage/stable_diffusion/models/controlnet
    mkdir -p /workspace/storage/stable_diffusion/models/pulid
    mkdir -p /workspace/storage/stable_diffusion/models/insightface/models
    mkdir -p /workspace/ComfyUI/custom_nodes/Plush-for-ComfyUI
}

# Create symlinks for special model directories
function create_symlinks() {
    ln -sf /workspace/storage/stable_diffusion/models/inpaint /workspace/ComfyUI/models/ 2>/dev/null || true
    ln -sf /workspace/storage/stable_diffusion/models/pulid /workspace/ComfyUI/models/ 2>/dev/null || true
    ln -sf /workspace/storage/stable_diffusion/models/insightface /workspace/ComfyUI/models/ 2>/dev/null || true
}

