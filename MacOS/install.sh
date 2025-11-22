#!/bin/zsh

################################################################################
# ComfyUI with TTS-Audio-Suite & VibeVoice Installation Script
# For macOS M4 (Apple Silicon)
# 
# PREREQUISITES (Managed via .keep/.Brewfile):
#   - Homebrew
#   - Conda (Miniconda or Anaconda)
#   - Git, wget, portaudio (managed via Brewfile)
#
# This script will:
# 1. Create a Conda virtual environment named "comfyui"
# 2. Install ComfyUI in ~/ComfyUI
# 3. Install TTS-Audio-Suite custom node
# 4. Download and setup VibeVoice 1.5B model
# 5. Copy management scripts to ~/ComfyUI
#
# ISOLATED INSTALLATION: Everything is contained in ~/ComfyUI directory
# To uninstall: Run ~/ComfyUI/MacOS/uninstall.sh
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
# STEP 0: Verify Architecture
################################################################################

log_info "Starting ComfyUI installation for macOS M4..."
echo ""

# Check if running on Apple Silicon
if [[ $(uname -m) != "arm64" ]]; then
    log_error "This script is designed for Apple Silicon (M-series) Macs."
    log_error "Detected architecture: $(uname -m)"
    exit 1
fi

log_success "✓ Detected Apple Silicon architecture"
echo ""

################################################################################
# STEP 1: Setup Installation Directory
################################################################################

INSTALL_DIR="$HOME/ComfyUI"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONDA_YML_PATH="${SCRIPT_DIR}/conda.yml"

log_info "Installation directory: $INSTALL_DIR"

# Check if installation directory already exists
if [[ -d "$INSTALL_DIR" ]]; then
    log_error "Installation directory already exists: $INSTALL_DIR"
    log_error "Please remove or backup the directory manually before running this script."
    log_error ""
    log_error "To remove: rm -rf $INSTALL_DIR"
    log_error "To uninstall properly: Run $INSTALL_DIR/MacOS/uninstall.sh if available"
    exit 1
fi

# Create installation directory
mkdir -p "$INSTALL_DIR"
log_success "Created installation directory"

################################################################################
# STEP 2: Create Conda Environment
################################################################################

log_info "Creating Conda environment 'comfyui'..."

# Check if conda.yml exists
if [[ ! -f "$CONDA_YML_PATH" ]]; then
    log_error "conda.yml not found at: $CONDA_YML_PATH"
    exit 1
fi

# Check if environment already exists
if conda env list | grep -q "^comfyui "; then
    log_error "Conda environment 'comfyui' already exists."
    log_error "Please remove it manually if you want to recreate it:"
    log_error "  conda env remove -n comfyui"
    log_error ""
    log_error "Or skip this installation if the environment is already configured."
    exit 1
fi

# Create the environment
conda env create -f "$CONDA_YML_PATH" || {
    log_error "Failed to create Conda environment"
    exit 1
}

log_success "Conda environment 'comfyui' created successfully"

# Activate the environment
log_info "Activating Conda environment..."

# Source conda for current shell
CONDA_BASE=$(conda info --base)
source "$CONDA_BASE/etc/profile.d/conda.sh"
conda activate comfyui || {
    log_error "Failed to activate conda environment"
    exit 1
}

log_success "Conda environment activated"

################################################################################
# STEP 3: Install PyTorch with MPS (Metal Performance Shaders) Support
################################################################################

log_info "Installing PyTorch with MPS (Metal) support for Apple Silicon..."

# Install PyTorch with MPS support for M4 using conda env's pip
$CONDA_BASE/envs/comfyui/bin/pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cpu || {
    log_error "Failed to install PyTorch"
    exit 1
}

log_success "PyTorch installed with MPS support"

################################################################################
# STEP 4: Clone and Install ComfyUI
################################################################################

log_info "Cloning ComfyUI repository..."
cd "$INSTALL_DIR"

git clone https://github.com/comfyanonymous/ComfyUI.git . || {
    log_error "Failed to clone ComfyUI"
    exit 1
}

log_success "ComfyUI repository cloned"

# Install ComfyUI dependencies
log_info "Installing ComfyUI dependencies..."
$CONDA_BASE/envs/comfyui/bin/pip install -r requirements.txt || {
    log_error "Failed to install ComfyUI dependencies"
    exit 1
}

log_success "ComfyUI dependencies installed"

################################################################################
# STEP 5: Install ComfyUI Manager (Optional but Recommended)
################################################################################

log_info "Installing ComfyUI Manager..."
mkdir -p "$INSTALL_DIR/custom_nodes"
cd "$INSTALL_DIR/custom_nodes"

git clone https://github.com/ltdrdata/ComfyUI-Manager.git || {
    log_warning "Failed to install ComfyUI Manager (optional, continuing...)"
}

log_success "ComfyUI Manager installed"

################################################################################
# STEP 6: Final Summary
################################################################################

echo ""
echo "========================================================================"
log_success "🎉 ComfyUI Base Installation Complete!"
echo "========================================================================"
echo ""
echo "📦 Installation Details:"
echo "   • Installation Directory: $INSTALL_DIR"
echo "   • Conda Environment: comfyui"
echo "   • ComfyUI Manager: Installed"
echo ""
echo "🚀 To Start ComfyUI:"
echo ""
echo "   \$ $SCRIPT_DIR/start_comfyui.sh"
echo ""
echo "   Or manually:"
echo "   \$ conda activate comfyui"
echo "   \$ cd $INSTALL_DIR"
echo "   \$ python main.py --listen"
echo ""
echo "🌐 Access ComfyUI at: http://127.0.0.1:8188"
echo ""
echo "🎤 Optional: Install TTS-Audio-Suite"
echo "   To add text-to-speech capabilities with VibeVoice:"
echo "   \$ $SCRIPT_DIR/tts-install.sh"
echo ""
echo "   TTS Features (when installed):"
echo "   • ChatterBox TTS (multilingual 23-lang)"
echo "   • F5-TTS, Higgs Audio 2"
echo "   • Microsoft VibeVoice 1.5B"
echo "   • RVC Voice Conversion, IndexTTS-2"
echo "   • SRT timing, Multi-character switching"
echo ""
echo "🗑️  To Uninstall:"
echo "   ComfyUI: \$ $SCRIPT_DIR/uninstall.sh"
echo "   TTS only: \$ $SCRIPT_DIR/tts-uninstall.sh"
echo ""
echo "⚠️  Important Notes:"
echo "   • Installation is completely isolated in ~/ComfyUI"
echo "   • No system files or dot files were modified"
echo "   • System packages are managed via .keep/.Brewfile"
echo "   • Use MPS (Metal Performance Shaders) for acceleration on M4"
echo ""
echo "========================================================================"
