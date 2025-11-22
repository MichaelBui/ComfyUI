#!/bin/bash

################################################################################
# VibeVoice Installation Library for Vast.AI
#
# This file contains VibeVoice (TTS-Audio-Suite) models and setup
# Source this file from provisioning-vibevoice.sh
################################################################################

################################################################################
# CONFIGURATION - Models to Download
################################################################################

# VibeVoice-specific custom nodes
VIBEVOICE_NODES=(
    "https://github.com/diodiogod/TTS-Audio-Suite"
)

# VibeVoice model arrays: URL, DEST_SUBDIR, SIZE_BYTES, DESCRIPTION
declare -a VIBEVOICE_MODEL_URLS VIBEVOICE_MODEL_DESTS VIBEVOICE_MODEL_SIZES VIBEVOICE_MODEL_DESCS

VIBEVOICE_BASE_URL="https://huggingface.co/microsoft/VibeVoice-1.5B/resolve/main"

# Main safetensors models (with size validation)
VIBEVOICE_MODEL_URLS+=("${VIBEVOICE_BASE_URL}/model-00001-of-00003.safetensors")
VIBEVOICE_MODEL_DESTS+=("TTS/VibeVoice/vibevoice-1.5B/model-00001-of-00003.safetensors")
VIBEVOICE_MODEL_SIZES+=(1975317828)
VIBEVOICE_MODEL_DESCS+=("VibeVoice Model Part 1/3 - 1.84 GB")

VIBEVOICE_MODEL_URLS+=("${VIBEVOICE_BASE_URL}/model-00002-of-00003.safetensors")
VIBEVOICE_MODEL_DESTS+=("TTS/VibeVoice/vibevoice-1.5B/model-00002-of-00003.safetensors")
VIBEVOICE_MODEL_SIZES+=(1983051688)
VIBEVOICE_MODEL_DESCS+=("VibeVoice Model Part 2/3 - 1.85 GB")

VIBEVOICE_MODEL_URLS+=("${VIBEVOICE_BASE_URL}/model-00003-of-00003.safetensors")
VIBEVOICE_MODEL_DESTS+=("TTS/VibeVoice/vibevoice-1.5B/model-00003-of-00003.safetensors")
VIBEVOICE_MODEL_SIZES+=(1449832938)
VIBEVOICE_MODEL_DESCS+=("VibeVoice Model Part 3/3 - 1.35 GB")

# Configuration files (small, no size validation needed)
VIBEVOICE_CONFIG_FILES=(
    "model.safetensors.index.json"
    "config.json"
    "preprocessor_config.json"
    "tokenizer.json"
    "tokenizer_config.json"
    "vocab.json"
    "special_tokens_map.json"
)

################################################################################
# VibeVoice Installation Function
################################################################################

function install_vibevoice() {
    printf "\n=== Installing VibeVoice Models and Nodes ===\n\n"
    
    # Install TTS-Audio-Suite node
    printf "Installing TTS-Audio-Suite custom node...\n"
    get_nodes "${VIBEVOICE_NODES[@]}"
    
    # Run TTS-Audio-Suite installer if install.py exists
    local tts_path="/opt/ComfyUI/custom_nodes/TTS-Audio-Suite"
    if [[ -f "$tts_path/install.py" ]]; then
        printf "Running TTS-Audio-Suite installation script...\n"
        cd "$tts_path"
        micromamba -n comfyui run python install.py || {
            printf "Warning: TTS-Audio-Suite install.py had issues (may be optional)\n"
        }
    fi
    
    # Download main VibeVoice models with size validation
    printf "\nDownloading VibeVoice 1.5B models (~5.0 GB)...\n"
    local total_models=${#VIBEVOICE_MODEL_URLS[@]}
    
    for ((i=0; i<$total_models; i++)); do
        local url="${VIBEVOICE_MODEL_URLS[$i]}"
        local dest_path="/workspace/ComfyUI/models/${VIBEVOICE_MODEL_DESTS[$i]}"
        local expected_size="${VIBEVOICE_MODEL_SIZES[$i]}"
        local description="${VIBEVOICE_MODEL_DESCS[$i]}"
        
        # Use shared download function from common.sh
        if ! download_model "$url" "$dest_path" "$expected_size" "$description" "$((i+1))" "$total_models"; then
            printf "✗ Failed to install VibeVoice model: %s\n" "$description"
            return 1
        fi
    done
    
    # Download configuration files (small files, no size validation)
    printf "\nDownloading VibeVoice configuration files...\n"
    local config_dir="/workspace/ComfyUI/models/TTS/VibeVoice/vibevoice-1.5B"
    mkdir -p "$config_dir"
    
    for file in "${VIBEVOICE_CONFIG_FILES[@]}"; do
        local filepath="$config_dir/$file"
        
        if [[ -f "$filepath" ]]; then
            printf "✓ Already exists (skipping): %s\n" "$file"
        else
            printf "Downloading: %s\n" "$file"
            wget -qnc --show-progress -P "$config_dir" "${VIBEVOICE_BASE_URL}/${file}" || {
                printf "Warning: Failed to download %s (may not be required)\n" "$file"
            }
        fi
    done
    
    printf "\n✓ VibeVoice installation complete\n\n"
}

################################################################################
# Main Execution (when run directly)
################################################################################

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Source common.sh for shared functions
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/common.sh"
    
    # Install VibeVoice
    install_vibevoice
fi
