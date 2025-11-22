#!/bin/bash

################################################################################
# Flux Installation Library for Vast.AI
#
# This file contains Flux-specific models and nodes
# Source this file from provisioning-flux.sh
################################################################################

################################################################################
# CONFIGURATION - Models to Download
################################################################################

# Flux-specific custom nodes
FLUX_NODES=(
    "https://github.com/city96/ComfyUI-GGUF"
    "https://github.com/ShmuelRonen/ComfyUI-Apply_Style_Model_Adjust"
    "https://github.com/sipie800/ComfyUI-PuLID-Flux-Enhanced"
)

# Model arrays: URL, DEST_SUBDIR, SIZE_BYTES, DESCRIPTION
declare -a FLUX_MODEL_URLS FLUX_MODEL_DESTS FLUX_MODEL_SIZES FLUX_MODEL_DESCS

# UNET Models
FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/flux/flux1-dev-Q5_K_S.gguf?download=true")
FLUX_MODEL_DESTS+=("unet/flux1-dev-Q5_K_S.gguf")
FLUX_MODEL_SIZES+=(8285267232)
FLUX_MODEL_DESCS+=("Flux1-Dev Q5_K_S UNET - 7.72 GB")

# CLIP Models
FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/clip/clip_l.safetensors?download=true")
FLUX_MODEL_DESTS+=("clip/clip_l.safetensors")
FLUX_MODEL_SIZES+=(246144152)
FLUX_MODEL_DESCS+=("CLIP L - 0.23 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/clip/ViT-L-14-BEST-smooth-GmP-TE-only-HF-format.safetensors?download=true")
FLUX_MODEL_DESTS+=("clip/ViT-L-14-BEST-smooth-GmP-TE-only-HF-format.safetensors")
FLUX_MODEL_SIZES+=(323409740)
FLUX_MODEL_DESCS+=("ViT-L-14 BEST Smooth - 0.30 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/clip/ViT-L-14-TEXT-detail-improved-hiT-GmP-TE-only-HF.safetensors?download=true")
FLUX_MODEL_DESTS+=("clip/ViT-L-14-TEXT-detail-improved-hiT-GmP-TE-only-HF.safetensors")
FLUX_MODEL_SIZES+=(323409740)
FLUX_MODEL_DESCS+=("ViT-L-14 TEXT Detail - 0.30 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors?download=true")
FLUX_MODEL_DESTS+=("clip/t5xxl_fp8_e4m3fn.safetensors")
FLUX_MODEL_SIZES+=(4893934904)
FLUX_MODEL_DESCS+=("T5XXL FP8 E4M3FN - 4.56 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/city96/t5-v1_1-xxl-encoder-gguf/resolve/main/t5-v1_1-xxl-encoder-Q8_0.gguf?download=true")
FLUX_MODEL_DESTS+=("clip/t5-v1_1-xxl-encoder-Q8_0.gguf")
FLUX_MODEL_SIZES+=(5061584064)
FLUX_MODEL_DESCS+=("T5 v1.1 XXL Encoder Q8_0 - 4.71 GB")

# Style Models
FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/style_models/flux1-redux-dev.safetensors?download=true")
FLUX_MODEL_DESTS+=("style_models/flux1-redux-dev.safetensors")
FLUX_MODEL_SIZES+=(129063232)
FLUX_MODEL_DESCS+=("Flux1 Redux Dev - 0.12 GB")

# Lora Models
FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/FLUX.1-Turbo-Alpha.safetensors?download=true")
FLUX_MODEL_DESTS+=("lora/FLUX.1-Turbo-Alpha.safetensors")
FLUX_MODEL_SIZES+=(694082424)
FLUX_MODEL_DESCS+=("FLUX.1 Turbo Alpha LoRA - 0.65 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/flux1-canny-dev-lora.safetensors?download=true")
FLUX_MODEL_DESTS+=("lora/flux1-canny-dev-lora.safetensors")
FLUX_MODEL_SIZES+=(1244443944)
FLUX_MODEL_DESCS+=("Flux1 Canny Dev LoRA - 1.16 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/flux1-depth-dev-lora.safetensors?download=true")
FLUX_MODEL_DESTS+=("lora/flux1-depth-dev-lora.safetensors")
FLUX_MODEL_SIZES+=(1244440512)
FLUX_MODEL_DESCS+=("Flux1 Depth Dev LoRA - 1.16 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/aidmaMJ6.1-FLUX-v0.4.safetensors?download=true")
FLUX_MODEL_DESTS+=("lora/aidmaMJ6.1-FLUX-v0.4.safetensors")
FLUX_MODEL_SIZES+=(76810376)
FLUX_MODEL_DESCS+=("AidmaMJ 6.1 FLUX LoRA - 0.07 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/Niji%20B.safetensors?download=true")
FLUX_MODEL_DESTS+=("lora/Niji B.safetensors")
FLUX_MODEL_SIZES+=(211012684)
FLUX_MODEL_DESCS+=("Niji B LoRA - 0.20 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/Funtik.safetensors?download=true")
FLUX_MODEL_DESTS+=("lora/Funtik.safetensors")
FLUX_MODEL_SIZES+=(76771176)
FLUX_MODEL_DESCS+=("Funtik LoRA - 0.07 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/flat-illus-flux-v1.safetensors?download=true")
FLUX_MODEL_DESTS+=("lora/flat-illus-flux-v1.safetensors")
FLUX_MODEL_SIZES+=(67280620)
FLUX_MODEL_DESCS+=("Flat Illustration Flux LoRA - 0.06 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/boFLUX%20Double%20Exposure%20Magic%20v2.safetensors?download=true")
FLUX_MODEL_DESTS+=("lora/boFLUX Double Exposure Magic v2.safetensors")
FLUX_MODEL_SIZES+=(19441896)
FLUX_MODEL_DESCS+=("boFLUX Double Exposure Magic LoRA - 0.02 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/Shakker-Labs/FLUX.1-dev-LoRA-Logo-Design/resolve/main/FLUX-dev-lora-Logo-Design.safetensors?download=true")
FLUX_MODEL_DESTS+=("lora/FLUX-dev-lora-Logo-Design.safetensors")
FLUX_MODEL_SIZES+=(38404800)
FLUX_MODEL_DESCS+=("FLUX Logo Design LoRA - 0.04 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/Shakker-Labs/FLUX.1-dev-LoRA-add-details/resolve/main/FLUX-dev-lora-add_details.safetensors?download=true")
FLUX_MODEL_DESTS+=("lora/FLUX-dev-lora-add_details.safetensors")
FLUX_MODEL_SIZES+=(687476088)
FLUX_MODEL_DESCS+=("FLUX Add Details LoRA - 0.64 GB")

# VAE Model
FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/vae/ae.safetensors?download=true")
FLUX_MODEL_DESTS+=("vae/ae.safetensors")
FLUX_MODEL_SIZES+=(335304388)
FLUX_MODEL_DESCS+=("Flux VAE - 0.31 GB")

# ESRGAN Upscaler Models
FLUX_MODEL_URLS+=("https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/4x-UltraSharp.pth?download=true")
FLUX_MODEL_DESTS+=("esrgan/4x-UltraSharp.pth")
FLUX_MODEL_SIZES+=(66961958)
FLUX_MODEL_DESCS+=("4x UltraSharp ESRGAN - 0.06 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/4x_foolhardy_Remacri.pth?download=true")
FLUX_MODEL_DESTS+=("esrgan/4x_foolhardy_Remacri.pth")
FLUX_MODEL_SIZES+=(67025055)
FLUX_MODEL_DESCS+=("4x Foolhardy Remacri ESRGAN - 0.06 GB")

FLUX_MODEL_URLS+=("https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/8x_NMKD-Superscale_150000_G.pth?download=true")
FLUX_MODEL_DESTS+=("esrgan/8x_NMKD-Superscale_150000_G.pth")
FLUX_MODEL_SIZES+=(67106707)
FLUX_MODEL_DESCS+=("8x NMKD Superscale ESRGAN - 0.06 GB")

# CLIP Vision Model
FLUX_MODEL_URLS+=("https://huggingface.co/MichaelBui/Collection/resolve/main/clip_vision/sigclip_vision_patch14_384.safetensors?download=true")
FLUX_MODEL_DESTS+=("clip_vision/sigclip_vision_patch14_384.safetensors")
FLUX_MODEL_SIZES+=(856505640)
FLUX_MODEL_DESCS+=("SigCLIP Vision Patch14 384 - 0.80 GB")

################################################################################
# Flux Installation Function
################################################################################

function install_flux() {
    printf "\n=== Installing Flux Models and Nodes ===\n\n"
    
    # Install Flux-specific nodes
    printf "Installing Flux custom nodes...\n"
    get_nodes "${FLUX_NODES[@]}"
    
    # Download models with size validation
    printf "\nDownloading Flux models (this may take a while)...\n"
    local total_models=${#FLUX_MODEL_URLS[@]}
    
    for ((i=0; i<$total_models; i++)); do
        local url="${FLUX_MODEL_URLS[$i]}"
        local dest_path="/workspace/storage/stable_diffusion/models/${FLUX_MODEL_DESTS[$i]}"
        local expected_size="${FLUX_MODEL_SIZES[$i]}"
        local description="${FLUX_MODEL_DESCS[$i]}"
        
        # Use shared download function from common.sh
        if ! download_model "$url" "$dest_path" "$expected_size" "$description" "$((i+1))" "$total_models"; then
            printf "✗ Failed to install Flux model: %s\n" "$description"
            return 1
        fi
    done
    
    printf "\n✓ Flux installation complete\n\n"
}

################################################################################
# Main Execution (when run directly)
################################################################################

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Source common.sh for shared functions
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/common.sh"
    
    # Install Flux
    install_flux
fi
