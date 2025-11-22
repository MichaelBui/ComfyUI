#!/bin/bash

################################################################################
# WAN 2.1 with InfinityTalk Installation Library for Vast.AI
#
# This file contains WAN-specific models and nodes
# Source this file from provisioning-wan-infinitytalk.sh
#
# Total size: ~13.77 GB
################################################################################

# WAN-specific custom nodes
WAN_NODES=(
    "https://github.com/kijai/ComfyUI-WanVideoWrapper"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/kijai/ComfyUI-MelBandRoFormer"
)

# WAN Model URLs and metadata (matching MacOS wan-install.sh structure)
declare -a WAN_MODELS_URL WAN_MODELS_DEST WAN_MODELS_SIZE WAN_MODELS_DESC

# Model 1: Wan2.1 I2V 14B 480P (Q4_0) - 9.54 GB
WAN_MODELS_URL+=("https://huggingface.co/city96/Wan2.1-I2V-14B-480P-gguf/resolve/main/wan2.1-i2v-14b-480p-Q4_0.gguf?download=true")
WAN_MODELS_DEST+=("diffusion_models/wan2.1-i2v-14b-480p-Q4_0.gguf")
WAN_MODELS_SIZE+=(10247552384)
WAN_MODELS_DESC+=("Wan2.1 I2V 14B 480P (Q4_0) - 9.54 GB")

# Model 2: Wan2.1 InfiniteTalk Single (Q8) - 2.46 GB
WAN_MODELS_URL+=("https://huggingface.co/Kijai/WanVideo_comfy_GGUF/resolve/main/InfiniteTalk/Wan2_1-InfiniteTalk_Single_Q8.gguf?download=true")
WAN_MODELS_DEST+=("diffusion_models/Wan2_1-InfiniteTalk_Single_Q8.gguf")
WAN_MODELS_SIZE+=(2646330016)
WAN_MODELS_DESC+=("Wan2.1 InfiniteTalk Single (Q8) - 2.46 GB")

# Model 3: Lightx2v Lora - 0.17 GB
WAN_MODELS_URL+=("https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank16_bf16.safetensors?download=true")
WAN_MODELS_DEST+=("loras/lightx2v_I2V_14B_480p_cfg_step_distill_rank16_bf16.safetensors")
WAN_MODELS_SIZE+=(191132936)
WAN_MODELS_DESC+=("Lightx2v Lora - 0.17 GB")

# Model 4: Wan 2.1 VAE - 0.23 GB
WAN_MODELS_URL+=("https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors?download=true")
WAN_MODELS_DEST+=("vae/wan_2.1_vae.safetensors")
WAN_MODELS_SIZE+=(253815318)
WAN_MODELS_DESC+=("Wan 2.1 VAE - 0.23 GB")

# Model 5: CLIP Vision H - 1.17 GB
WAN_MODELS_URL+=("https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors?download=true")
WAN_MODELS_DEST+=("clip_vision/clip_vision_h.safetensors")
WAN_MODELS_SIZE+=(1264219396)
WAN_MODELS_DESC+=("CLIP Vision H - 1.17 GB")

# Model 6: Wav2Vec2 Chinese Base (FP16) - 0.17 GB
WAN_MODELS_URL+=("https://huggingface.co/Kijai/wav2vec2_safetensors/resolve/main/wav2vec2-chinese-base_fp16.safetensors?download=true")
WAN_MODELS_DEST+=("wav2vec2/wav2vec2-chinese-base_fp16.safetensors")
WAN_MODELS_SIZE+=(190115368)
WAN_MODELS_DESC+=("Wav2Vec2 Chinese Base (FP16) - 0.17 GB")

################################################################################
# WAN Installation Function with File Size Validation
################################################################################

function install_wan() {
    printf "\n=== Installing WAN 2.1 + InfinityTalk Models and Nodes ===\n\n"
    
    # Install WAN-specific nodes
    printf "Installing WAN custom nodes...\n"
    get_nodes "${WAN_NODES[@]}"
    
    # Create necessary directories
    mkdir -p /workspace/storage/stable_diffusion/models/diffusion_models
    mkdir -p /workspace/storage/stable_diffusion/models/loras
    mkdir -p /workspace/storage/stable_diffusion/models/vae
    mkdir -p /workspace/storage/stable_diffusion/models/clip_vision
    mkdir -p /workspace/storage/stable_diffusion/models/wav2vec2
    
    # Download WAN models with size validation
    printf "\nDownloading WAN models (this may take a while)...\n"
    local total_models=${#WAN_MODELS_URL[@]}
    
    for ((i=0; i<$total_models; i++)); do
        local url="${WAN_MODELS_URL[$i]}"
        local dest_path="/workspace/storage/stable_diffusion/models/${WAN_MODELS_DEST[$i]}"
        local expected_size="${WAN_MODELS_SIZE[$i]}"
        local description="${WAN_MODELS_DESC[$i]}"
        
        # Use shared download function from common.sh
        if ! download_model "$url" "$dest_path" "$expected_size" "$description" "$((i+1))" "$total_models"; then
            printf "✗ Failed to install WAN model: %s\n" "$description"
            return 1
        fi
    done
    
    printf "\n✓ WAN installation complete\n\n"
}

################################################################################
# Main Execution (when run directly)
################################################################################

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Source common.sh for shared functions
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/common.sh"
    
    # Install WAN
    install_wan
fi

