#!/bin/zsh

################################################################################
# WAN 2.1 with InfinityTalk Uninstallation Script
# For ComfyUI on macOS M4 (Apple Silicon)
#
# This script safely removes WAN 2.1 models and custom nodes
# Models to remove are defined in the same format as wan-install.sh
################################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

# Base paths
COMFYUI_DIR="$HOME/ComfyUI"
MODELS_DIR="$COMFYUI_DIR/models"

################################################################################
# WAN MODELS TO REMOVE (must match wan-install.sh)
################################################################################

declare -a WAN_MODELS_DEST WAN_MODELS_DESC

# Model 1: Wan2.1 I2V 14B 480P (Q4_0) - 9.54 GB
WAN_MODELS_DEST+=("diffusion_models/wan2.1-i2v-14b-480p-Q4_0.gguf")
WAN_MODELS_DESC+=("Wan2.1 I2V 14B 480P (Q4_0) - 9.54 GB")

# Model 2: Wan2.1 InfiniteTalk Single (Q8) - 2.46 GB
WAN_MODELS_DEST+=("diffusion_models/Wan2_1-InfiniteTalk_Single_Q8.gguf")
WAN_MODELS_DESC+=("Wan2.1 InfiniteTalk Single (Q8) - 2.46 GB")

# Model 3: Lightx2v Lora - 0.17 GB
WAN_MODELS_DEST+=("Loras/lightx2v_I2V_14B_480p_cfg_step_distill_rank16_bf16.safetensors")
WAN_MODELS_DESC+=("Lightx2v Lora - 0.17 GB")

# Model 4: Wan 2.1 VAE - 0.23 GB
WAN_MODELS_DEST+=("vae/wan_2.1_vae.safetensors")
WAN_MODELS_DESC+=("Wan 2.1 VAE - 0.23 GB")

# Model 5: CLIP Vision H - 1.17 GB
WAN_MODELS_DEST+=("clip_vision/clip_vision_h.safetensors")
WAN_MODELS_DESC+=("CLIP Vision H - 1.17 GB")

# Model 6: Wav2Vec2 Chinese Base (FP16) - 0.17 GB
WAN_MODELS_DEST+=("wav2vec2/wav2vec2-chinese-base_fp16.safetensors")
WAN_MODELS_DESC+=("Wav2Vec2 Chinese Base (FP16) - 0.17 GB")

# Custom Nodes to Remove
declare -a WAN_NODES=(
    "ComfyUI-WanVideoWrapper"
    "ComfyUI-VideoHelperSuite"
    "ComfyUI-MelBandRoFormer"
)

################################################################################
# END OF CONFIGURATION
################################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

################################################################################
# SAFETY: Path Validation Function
################################################################################

# Validates that a path is within the expected ComfyUI directory
# This prevents accidental deletion of system files
validate_path() {
    local path="$1"
    local comfyui_base="$HOME/ComfyUI"
    
    # Resolve to absolute path
    if [[ ! -e "$path" ]]; then
        return 1  # Path doesn't exist
    fi
    
    local abs_path=$(cd "$(dirname "$path")" && pwd)/$(basename "$path")
    
    # Check if path is within ComfyUI directory
    if [[ "$abs_path" != "$comfyui_base"* ]]; then
        log_error "SAFETY: Path is outside ComfyUI directory: $abs_path"
        return 1
    fi
    
    # Check if path contains sensitive directories
    if [[ "$abs_path" == *"/System/"* ]] || [[ "$abs_path" == *"/usr/"* ]] || [[ "$abs_path" == *"/bin/"* ]]; then
        log_error "SAFETY: Path contains system directory: $abs_path"
        return 1
    fi
    
    return 0
}

################################################################################
# STEP 0: Environment Validation
################################################################################

log_warning "WAN 2.1 with InfinityTalk Uninstallation"
echo ""

CUSTOM_NODES_DIR="$COMFYUI_DIR/custom_nodes"

# Check if ComfyUI directory exists
if [[ ! -d "$COMFYUI_DIR" ]]; then
    log_error "ComfyUI not found at: $COMFYUI_DIR"
    log_error "Nothing to uninstall"
    exit 1
fi

log_info "ComfyUI installation found at: $COMFYUI_DIR"
echo ""

################################################################################
# STEP 1: Display What Will Be Removed
################################################################################

echo "========================================================================"
log_warning "The following WAN-related files will be removed:"
echo "========================================================================"
echo ""

echo "📦 Models (~13.77 GB):"
for desc in "${WAN_MODELS_DESC[@]}"; do
    echo "   • $desc"
done
echo ""

echo "🔌 Custom Nodes:"
for node in "${WAN_NODES[@]}"; do
    echo "   • $node"
done
echo ""

echo "⚠️  ComfyUI core files will NOT be touched"
echo "⚠️  Other models and custom nodes will remain intact"
echo ""
echo "========================================================================"
echo ""

################################################################################
# STEP 2: User Confirmation
################################################################################

read -p "Are you sure you want to proceed with uninstallation? (yes/no): " CONFIRM

if [[ "$CONFIRM" != "yes" ]] && [[ "$CONFIRM" != "y" ]] && [[ "$CONFIRM" != "Y" ]]; then
    log_info "Uninstallation cancelled by user"
    exit 0
fi

echo ""
log_info "Proceeding with uninstallation..."
echo ""

################################################################################
# STEP 3: Remove Models (with Safety Checks)
################################################################################

log_info "Removing WAN models..."
echo ""

REMOVED_COUNT=0
FAILED_COUNT=0
TOTAL_MODELS=${#WAN_MODELS_DEST[@]}

for ((i=0; i<$TOTAL_MODELS; i++)); do
    MODEL_PATH="$MODELS_DIR/${WAN_MODELS_DEST[$i]}"
    DESCRIPTION="${WAN_MODELS_DESC[$i]}"
    
    if [[ -f "$MODEL_PATH" ]]; then
        # Safety check before removal
        if validate_path "$MODEL_PATH"; then
            log_info "[$((i+1))/$TOTAL_MODELS] Removing: $DESCRIPTION"
            if rm -f "$MODEL_PATH"; then
                log_success "✓ Removed: $(basename "$MODEL_PATH")"
                ((REMOVED_COUNT++))
            else
                log_error "✗ Failed to remove: $(basename "$MODEL_PATH")"
                ((FAILED_COUNT++))
            fi
        else
            log_error "✗ Safety check failed for: $MODEL_PATH"
            ((FAILED_COUNT++))
        fi
    else
        log_warning "[$((i+1))/$TOTAL_MODELS] Not found (may already be removed): $(basename "$MODEL_PATH")"
    fi
done

echo ""
log_success "Models removal complete: $REMOVED_COUNT removed, $FAILED_COUNT failed"
echo ""

################################################################################
# STEP 4: Remove Custom Nodes (with Safety Checks)
################################################################################

log_info "Removing WAN custom nodes..."
echo ""

NODE_REMOVED_COUNT=0
NODE_FAILED_COUNT=0
TOTAL_NODES=${#WAN_NODES[@]}

for ((i=0; i<$TOTAL_NODES; i++)); do
    node_name="${WAN_NODES[$i]}"
    NODE_PATH="$CUSTOM_NODES_DIR/$node_name"
    
    if [[ -d "$NODE_PATH" ]]; then
        # Safety check before removal
        if validate_path "$NODE_PATH"; then
            log_info "[$((i+1))/$TOTAL_NODES] Removing node: $node_name"
            if rm -rf "$NODE_PATH"; then
                log_success "✓ Removed: $node_name"
                ((NODE_REMOVED_COUNT++))
            else
                log_error "✗ Failed to remove: $node_name"
                ((NODE_FAILED_COUNT++))
            fi
        else
            log_error "✗ Safety check failed for: $NODE_PATH"
            ((NODE_FAILED_COUNT++))
        fi
    else
        log_warning "[$((i+1))/$TOTAL_NODES] Not found (may already be removed): $node_name"
    fi
done

echo ""
log_success "Custom nodes removal complete: $NODE_REMOVED_COUNT removed, $NODE_FAILED_COUNT failed"
echo ""

################################################################################
# STEP 5: Final Summary
################################################################################

echo ""
echo "========================================================================"
log_success "🎉 WAN 2.1 Uninstallation Complete!"
echo "========================================================================"
echo ""
echo "📊 Removal Summary:"
echo "   • Models: $REMOVED_COUNT removed, $FAILED_COUNT failed"
echo "   • Custom Nodes: $NODE_REMOVED_COUNT removed, $NODE_FAILED_COUNT failed"
echo ""

if [[ $FAILED_COUNT -gt 0 ]] || [[ $NODE_FAILED_COUNT -gt 0 ]]; then
    log_warning "Some files failed to remove. You may need to remove them manually."
    echo ""
fi

echo "✅ ComfyUI core installation remains intact"
echo "✅ Other models and custom nodes are preserved"
echo ""
echo "💡 To reinstall WAN 2.1:"
echo "   \$ $(cd "$(dirname "$0")" && pwd)/wan-install.sh"
echo ""
echo "========================================================================"

