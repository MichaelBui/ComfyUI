#!/bin/zsh

################################################################################
# WAN 2.1 with InfinityTalk Installation Script
# For ComfyUI on macOS M4 (Apple Silicon)
#
# To add/remove models: Edit the WAN_MODELS array below
# To uninstall: Run wan-uninstall.sh
################################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

# Base paths (will be set after environment validation)
COMFYUI_DIR="$HOME/ComfyUI"
MODELS_DIR="$COMFYUI_DIR/models"

################################################################################
# WAN MODELS CONFIGURATION
# 
# Format: Each model is defined with 4 fields on separate lines:
#   - URL: HuggingFace download URL
#   - DEST: Destination path (relative to $MODELS_DIR)
#   - SIZE: Expected file size in bytes (for validation)
#   - DESC: Human-readable description with size
#
# Total size: 13.77 GB
################################################################################

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
# END OF USER CONFIGURATION
################################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_download() {
    echo -e "${CYAN}[DOWNLOAD]${NC} $1"
}

log_model() {
    echo -e "${MAGENTA}[MODEL]${NC} $1"
}

################################################################################
# Common Download Function with Validation
################################################################################

# Downloads a model file with size validation to prevent redundant downloads
# Usage: download_model_with_validation <URL> <DEST_PATH> <EXPECTED_SIZE> <DESCRIPTION> <INDEX> <TOTAL>
download_model_with_validation() {
    local url="$1"
    local dest_path="$2"
    local expected_size="$3"
    local description="$4"
    local index="${5:-}"
    local total="${6:-}"
    
    # Display progress if index and total provided
    if [[ -n "$index" ]] && [[ -n "$total" ]]; then
        log_model "[$index/$total] $description"
    else
        log_model "$description"
    fi
    
    # Check if file exists
    if [[ -f "$dest_path" ]]; then
        # Validate file size
        local actual_size=$(stat -f%z "$dest_path" 2>/dev/null || echo "0")
        
        if [[ "$actual_size" -eq "$expected_size" ]]; then
            log_success "Already downloaded with correct size ($(echo "scale=2; $expected_size/1073741824" | bc) GB), skipping"
            return 0
        else
            log_warning "Incomplete download detected"
            log_info "Expected: $expected_size bytes, Got: $actual_size bytes"
            log_info "Removing incomplete file and re-downloading..."
            rm -f "$dest_path"
        fi
    fi
    
    # Download the file
    log_download "Downloading $(echo "scale=2; $expected_size/1073741824" | bc) GB from HuggingFace..."
    if wget --progress=bar:force:noscroll -O "$dest_path" "$url"; then
        log_success "Downloaded successfully"
        
        # Verify downloaded file size
        local final_size=$(stat -f%z "$dest_path" 2>/dev/null || echo "0")
        if [[ "$final_size" -ne "$expected_size" ]]; then
            log_error "Download size mismatch! Expected: $expected_size, Got: $final_size"
            return 1
        fi
    else
        log_error "Failed to download: $description"
        return 1
    fi
}

################################################################################
# STEP 0: Environment Validation
################################################################################

log_info "Starting WAN 2.1 with InfinityTalk installation..."
echo ""

CUSTOM_NODES_DIR="$COMFYUI_DIR/custom_nodes"

# Check if ComfyUI is installed
if [[ ! -d "$COMFYUI_DIR" ]]; then
    log_error "ComfyUI not found at: $COMFYUI_DIR"
    log_error "Please run install.sh first to install ComfyUI"
    exit 1
fi

# Check if conda environment exists
if ! conda env list | grep -q "^comfyui "; then
    log_error "Conda environment 'comfyui' not found"
    log_error "Please run install.sh first to create the environment"
    exit 1
fi

log_success "✓ ComfyUI installation found"
log_success "✓ Conda environment 'comfyui' exists"
echo ""

# Activate conda environment
CONDA_BASE=$(conda info --base)
source "$CONDA_BASE/etc/profile.d/conda.sh"
conda activate comfyui || {
    log_error "Failed to activate conda environment 'comfyui'"
    exit 1
}

log_success "✓ Conda environment activated"
echo ""

################################################################################
# STEP 1: Create Model Directories
################################################################################

log_info "Creating model directories..."

mkdir -p "$MODELS_DIR/diffusion_models"
mkdir -p "$MODELS_DIR/loras"
mkdir -p "$MODELS_DIR/vae"
mkdir -p "$MODELS_DIR/clip_vision"
mkdir -p "$MODELS_DIR/wav2vec2"

log_success "Model directories created"
echo ""

################################################################################
# STEP 2: Download All Models
################################################################################

log_info "Downloading WAN models (this may take a while)..."
echo ""

TOTAL_MODELS=${#WAN_MODELS_URL[@]}

for ((i=0; i<$TOTAL_MODELS; i++)); do
    # Get model metadata from parallel arrays
    URL="${WAN_MODELS_URL[$i]}"
    DEST_PATH="$MODELS_DIR/${WAN_MODELS_DEST[$i]}"
    SIZE="${WAN_MODELS_SIZE[$i]}"
    DESCRIPTION="${WAN_MODELS_DESC[$i]}"
    
    # Download with validation
    download_model_with_validation "$URL" "$DEST_PATH" "$SIZE" "$DESCRIPTION" "$((i+1))" "$TOTAL_MODELS" || {
        log_error "Critical: Failed to download required model"
        exit 1
    }
    echo ""
done

log_success "✓ All models downloaded successfully"
echo ""

################################################################################
# STEP 4: Install Custom Nodes
################################################################################

log_info "Installing custom nodes..."
echo ""

# Array of custom nodes with format: "URL | Description"
declare -a WAN_NODES=(
    "https://github.com/kijai/ComfyUI-WanVideoWrapper        | WAN Video Integration"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite | Video Processing Utilities"
    "https://github.com/ZHO-ZHO-ZHO/ComfyUI-MelBandRoFormer  | Audio Separation"
)

TOTAL_NODES=${#WAN_NODES[@]}
INSTALLED_COUNT=0
FAILED_COUNT=0

for i in {1..$TOTAL_NODES}; do
    NODE_INFO="${WAN_NODES[$i]}"
    REPO_URL=$(echo "${NODE_INFO%|*}" | xargs)
    DESCRIPTION=$(echo "${NODE_INFO#*|}" | xargs)
    NODE_NAME=$(basename "$REPO_URL")
    
    echo "--------------------------------------------------------------------"
    log_model "[$i/$TOTAL_NODES] $NODE_NAME"
    log_info "$DESCRIPTION"
    echo ""
    
    NODE_PATH="$CUSTOM_NODES_DIR/$NODE_NAME"
    
    if [[ -d "$NODE_PATH" ]]; then
        log_warning "Node already exists, skipping: $NODE_NAME"
        ((INSTALLED_COUNT++))
        echo ""
        continue
    fi
    
    log_download "Cloning repository..."
    if git clone "$REPO_URL" "$NODE_PATH" 2>&1; then
        log_success "Repository cloned"
        
        # Install dependencies if requirements.txt exists
        if [[ -f "$NODE_PATH/requirements.txt" ]]; then
            log_info "Installing dependencies..."
            if $CONDA_BASE/envs/comfyui/bin/pip install -r "$NODE_PATH/requirements.txt" 2>&1; then
                log_success "Dependencies installed"
            else
                log_warning "Some dependencies failed (may be optional)"
            fi
        fi
        
        # Run install.py if exists
        if [[ -f "$NODE_PATH/install.py" ]]; then
            log_info "Running installation script..."
            if cd "$NODE_PATH" && $CONDA_BASE/envs/comfyui/bin/python install.py 2>&1; then
                log_success "Installation script completed"
            else
                log_warning "Installation script had issues (may be optional)"
            fi
            cd "$CUSTOM_NODES_DIR"
        fi
        
        log_success "✓ $NODE_NAME installed"
        ((INSTALLED_COUNT++))
    else
        log_error "✗ Failed to clone $NODE_NAME"
        ((FAILED_COUNT++))
    fi
    echo ""
done

################################################################################
# STEP 5: Final Summary
################################################################################

echo ""
echo "========================================================================"
log_success "🎉 WAN 2.1 with InfinityTalk Installation Complete!"
echo "========================================================================"
echo ""
echo "📦 Installation Summary:"
echo ""
echo "🤖 Models Installed:"
echo "   • Wan2.1 I2V 14B 480P (Q4_0) - 9.54 GB - Main video model"
echo "   • Wan2.1 InfiniteTalk Single (Q8) - 2.46 GB - Talk generation"
echo "   • Lightx2v Lora - 0.17 GB - Enhancement lora"
echo "   • Wan 2.1 VAE - 0.23 GB - Video autoencoder"
echo "   • CLIP Vision H - 1.17 GB - Vision encoding"
echo "   • Wav2Vec2 Chinese Base - 0.17 GB - Audio processing"
echo ""
echo "🔌 Custom Nodes:"
echo "   • Installed: $INSTALLED_COUNT/$TOTAL_NODES"
if [[ $FAILED_COUNT -gt 0 ]]; then
    echo "   • Failed: $FAILED_COUNT (may need manual installation)"
fi
echo ""
echo "📁 Model Locations:"
echo "   • Diffusion Models: $MODELS_DIR/diffusion_models/"
echo "   • Loras: $MODELS_DIR/loras/"
echo "   • VAE: $MODELS_DIR/vae/"
echo "   • CLIP Vision: $MODELS_DIR/clip_vision/"
echo "   • Wav2Vec2: $MODELS_DIR/wav2vec2/"
echo ""
echo "🚀 Next Steps:"
echo "   1. Restart ComfyUI to load new nodes and models"
echo "   2. Look for 'WAN' nodes in the node menu"
echo "   3. Load the example workflows from WanVideoWrapper"
echo ""
echo "💡 To Start ComfyUI:"
echo "   \$ $(cd "$(dirname "$0")" && pwd)/start_comfyui.sh"
echo ""
echo "🗑️  To Uninstall:"
echo "   \$ $(cd "$(dirname "$0")" && pwd)/wan-uninstall.sh"
echo ""
echo "⚠️  Important Notes:"
echo "   • Models require ~17GB disk space (actual: 13.77GB + buffer)"
echo "   • First inference may take time to load models"
echo "   • Q4/Q8 quantized models optimize memory usage"
echo "   • Apple Silicon uses MPS acceleration"
echo ""
echo "========================================================================"

