#!/bin/zsh

################################################################################
# TTS-Audio-Suite Installation Script
# For macOS M4 (Apple Silicon)
# 
# This script installs TTS-Audio-Suite custom node and VibeVoice model
# 
# PREREQUISITES:
#   - ComfyUI must be installed at ~/ComfyUI
#   - Conda environment 'comfyui' must exist
#   - Homebrew packages: libsamplerate, portaudio (managed via .keep/.Brewfile)
################################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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
# STEP 0: Verify Prerequisites
################################################################################

log_info "Starting TTS-Audio-Suite installation..."
echo ""

COMFYUI_DIR="$HOME/ComfyUI"

# Check if ComfyUI directory exists
if [[ ! -d "$COMFYUI_DIR" ]]; then
    log_error "ComfyUI directory not found at: $COMFYUI_DIR"
    log_error "Please install ComfyUI first using install.sh"
    exit 1
fi

log_success "✓ ComfyUI directory found"

# Check if conda environment exists
if ! conda env list | grep -q "^comfyui "; then
    log_error "Conda environment 'comfyui' not found"
    log_error "Please run install.sh first to create the environment"
    exit 1
fi

log_success "✓ Conda environment 'comfyui' found"
echo ""

################################################################################
# STEP 1: Install TTS-Audio-Suite Custom Node
################################################################################

log_info "Installing TTS-Audio-Suite custom node..."
mkdir -p "$COMFYUI_DIR/custom_nodes"
cd "$COMFYUI_DIR/custom_nodes"

# Check if already installed
if [[ -d "TTS-Audio-Suite" ]]; then
    log_warning "TTS-Audio-Suite already exists. Pulling latest changes..."
    cd TTS-Audio-Suite
    git pull
else
    log_info "Cloning TTS-Audio-Suite repository..."
    git clone https://github.com/diodiogod/TTS-Audio-Suite.git || {
        log_error "Failed to clone TTS-Audio-Suite"
        exit 1
    }
    cd TTS-Audio-Suite
fi

log_success "TTS-Audio-Suite cloned"

# Activate conda environment
log_info "Activating Conda environment..."
CONDA_BASE=$(conda info --base)
source "$CONDA_BASE/etc/profile.d/conda.sh"
conda activate comfyui || {
    log_error "Failed to activate conda environment"
    exit 1
}

# Run the TTS-Audio-Suite installer
log_info "Running TTS-Audio-Suite installation script..."
# Export DYLD_LIBRARY_PATH so conda Python can find Homebrew libraries
export DYLD_LIBRARY_PATH="/opt/homebrew/lib:${DYLD_LIBRARY_PATH:-}"
python install.py || {
    log_error "Failed to run TTS-Audio-Suite installer"
    exit 1
}

log_success "TTS-Audio-Suite installed successfully"

################################################################################
# STEP 2: Download VibeVoice 1.5B Model
################################################################################

log_info "Setting up VibeVoice 1.5B model..."
VIBEVOICE_DIR="$COMFYUI_DIR/models/TTS/VibeVoice/vibevoice-1.5B"
mkdir -p "$VIBEVOICE_DIR"
cd "$VIBEVOICE_DIR"

# Check if model files already exist
if [[ -f "model-00001-of-00003.safetensors" ]] && \
   [[ -f "model-00002-of-00003.safetensors" ]] && \
   [[ -f "model-00003-of-00003.safetensors" ]]; then
    log_warning "VibeVoice model files already exist. Skipping download..."
else
    log_info "Downloading VibeVoice 1.5B model files (this may take a while, ~5.4GB)..."
    
    # Download model files
    MODEL_BASE_URL="https://huggingface.co/microsoft/VibeVoice-1.5B/resolve/main"
    
    MODEL_FILES=(
        "model-00001-of-00003.safetensors"
        "model-00002-of-00003.safetensors"
        "model-00003-of-00003.safetensors"
        "model.safetensors.index.json"
        "config.json"
        "preprocessor_config.json"
        "tokenizer.json"
        "tokenizer_config.json"
        "vocab.json"
        "special_tokens_map.json"
    )
    
    for file in "${MODEL_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            log_info "File $file already exists, skipping..."
        else
            log_info "Downloading $file..."
            wget -q --show-progress "${MODEL_BASE_URL}/${file}" || {
                log_warning "Failed to download $file (may not be required, continuing...)"
            }
        fi
    done
    
    log_success "VibeVoice 1.5B model downloaded successfully"
fi

################################################################################
# STEP 3: Final Summary
################################################################################

echo ""
echo "========================================================================"
log_success "🎉 TTS-Audio-Suite Installation Complete!"
echo "========================================================================"
echo ""
echo "📦 Installed Components:"
echo "   • TTS-Audio-Suite: $COMFYUI_DIR/custom_nodes/TTS-Audio-Suite"
echo "   • VibeVoice Model: $VIBEVOICE_DIR"
echo ""
echo "📚 TTS-Audio-Suite Features:"
echo "   • ChatterBox TTS (classic and multilingual 23-lang)"
echo "   • F5-TTS"
echo "   • Higgs Audio 2"
echo "   • Microsoft VibeVoice 1.5B"
echo "   • RVC Voice Conversion"
echo "   • IndexTTS-2"
echo "   • SRT timing support"
echo "   • Multi-character switching"
echo ""
echo "📖 Example Workflows:"
echo "   $COMFYUI_DIR/custom_nodes/TTS-Audio-Suite/example_workflows/"
echo ""
echo "🗑️  To Uninstall TTS Components:"
echo "   \$ $(dirname "$0")/tts-uninstall.sh"
echo ""
echo "========================================================================"

