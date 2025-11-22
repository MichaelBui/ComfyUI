#!/bin/zsh

################################################################################
# ComfyUI Quality-of-Life (QoL) Custom Nodes Installation Script
# For macOS M4 (Apple Silicon)
#
# This script installs essential QoL custom nodes to enhance ComfyUI workflow
# 
# PREREQUISITES:
#   - ComfyUI must be installed at ~/ComfyUI (run install.sh first)
#   - Conda environment 'comfyui' must exist
#
# NODES INSTALLED:
#   1. Crystools - System stats and monitoring
#   2. ComfyUI-Impact-Pack - Utilities suite
#   3. ComfyUI-Inspire-Pack - Utilities suite
#   4. WAS Node Suite - Utilities suite
#   5. rgthree-comfy - Utilities suite
#   6. ComfyUI_essentials - Essential utilities
#   7. cg-use-everywhere - Anything everywhere functionality
#   8. ComfyUI-Custom-Scripts - Export workflow as image
#   9. ComfyUI-KJNodes - Empty latent and more
#  10. ComfyUI-dynamicprompts - Dynamic prompt generation
#  11. rembg-comfyui-node - Remove background from images
#  12. ComfyUI-enricos-nodes - Image compositor
#
# To uninstall: Manually remove folders from ~/ComfyUI/custom_nodes/
################################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

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

log_node() {
    echo -e "${CYAN}[NODE]${NC} $1"
}

################################################################################
# STEP 0: Environment Validation
################################################################################

log_info "Starting QoL Custom Nodes installation..."
echo ""

COMFYUI_DIR="$HOME/ComfyUI"
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

# Create custom_nodes directory if it doesn't exist
mkdir -p "$CUSTOM_NODES_DIR"

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
# STEP 1: Define QoL Nodes
################################################################################

# Array of repositories with format: "URL | Description"
# The pipe separator with spaces makes it human-readable
declare -a QOL_NODES=(
    "https://github.com/crystian/ComfyUI-Crystools                   | System Stats & Monitoring"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack                 | Comprehensive Utilities Suite"
    "https://github.com/ltdrdata/ComfyUI-Inspire-Pack                | Creative Utilities Suite"
    "https://github.com/WASasquatch/was-node-suite-comfyui           | WAS Utilities Suite"
    "https://github.com/rgthree/rgthree-comfy                        | rgthree Utilities Suite"
    "https://github.com/cubiq/ComfyUI_essentials                     | Essential Utilities"
    "https://github.com/chrisgoringe/cg-use-everywhere               | Anything Everywhere"
    "https://github.com/pythongosssss/ComfyUI-Custom-Scripts         | Export Workflow as Image"
    "https://github.com/kijai/ComfyUI-KJNodes                        | Empty Latent & More"
    "https://github.com/adieyal/comfyui-dynamicprompts               | Dynamic Prompts"
    "https://github.com/Jcd1230/rembg-comfyui-node                   | Remove Background"
    "https://github.com/erosDiffusion/ComfyUI-enricos-nodes          | Image Compositor"
)

TOTAL_NODES=${#QOL_NODES[@]}
INSTALLED_COUNT=0
FAILED_COUNT=0
declare -a INSTALLED_NODES=()
declare -a FAILED_NODES=()

################################################################################
# STEP 2: Install Each Node
################################################################################

log_info "Installing $TOTAL_NODES QoL custom nodes..."
echo ""

for i in {1..$TOTAL_NODES}; do
    NODE_INFO="${QOL_NODES[$i]}"
    # Split by pipe and trim whitespace
    REPO_URL=$(echo "${NODE_INFO%|*}" | xargs)
    DESCRIPTION=$(echo "${NODE_INFO#*|}" | xargs)
    NODE_NAME=$(basename "$REPO_URL")
    
    echo "========================================================================"
    log_node "[$i/$TOTAL_NODES] $NODE_NAME"
    log_info "Description: $DESCRIPTION"
    log_info "Repository: $REPO_URL"
    echo ""
    
    NODE_PATH="$CUSTOM_NODES_DIR/$NODE_NAME"
    
    # Check if node already exists
    if [[ -d "$NODE_PATH" ]]; then
        log_warning "Node already exists, skipping: $NODE_NAME"
        INSTALLED_NODES+=("$NODE_NAME (already installed)")
        ((INSTALLED_COUNT++))
        echo ""
        continue
    fi
    
    # Clone the repository
    log_info "Cloning repository..."
    if git clone "$REPO_URL" "$NODE_PATH" 2>&1; then
        log_success "Repository cloned successfully"
        
        # Check for requirements.txt and install dependencies
        if [[ -f "$NODE_PATH/requirements.txt" ]]; then
            log_info "Installing node dependencies..."
            if $CONDA_BASE/envs/comfyui/bin/pip install -r "$NODE_PATH/requirements.txt" 2>&1; then
                log_success "Dependencies installed"
            else
                log_warning "Some dependencies failed to install (may be optional)"
            fi
        else
            log_info "No requirements.txt found (node may not need dependencies)"
        fi
        
        # Check for install.py and run it
        if [[ -f "$NODE_PATH/install.py" ]]; then
            log_info "Running node-specific installation script..."
            if cd "$NODE_PATH" && $CONDA_BASE/envs/comfyui/bin/python install.py 2>&1; then
                log_success "Installation script completed"
            else
                log_warning "Installation script had issues (may be optional)"
            fi
            cd "$CUSTOM_NODES_DIR"
        fi
        
        log_success "✓ $NODE_NAME installed successfully"
        INSTALLED_NODES+=("$NODE_NAME")
        ((INSTALLED_COUNT++))
    else
        log_error "✗ Failed to clone $NODE_NAME"
        FAILED_NODES+=("$NODE_NAME")
        ((FAILED_COUNT++))
    fi
    
    echo ""
done

################################################################################
# STEP 3: Final Summary
################################################################################

echo ""
echo "========================================================================"
log_success "🎉 QoL Custom Nodes Installation Complete!"
echo "========================================================================"
echo ""
echo "📊 Installation Summary:"
echo "   • Total Nodes: $TOTAL_NODES"
echo "   • Successfully Installed: $INSTALLED_COUNT"
echo "   • Failed: $FAILED_COUNT"
echo ""

if [[ $INSTALLED_COUNT -gt 0 ]]; then
    echo "✅ Installed Nodes:"
    for node in "${INSTALLED_NODES[@]}"; do
        echo "   • $node"
    done
    echo ""
fi

if [[ $FAILED_COUNT -gt 0 ]]; then
    echo "❌ Failed Nodes:"
    for node in "${FAILED_NODES[@]}"; do
        echo "   • $node"
    done
    echo ""
    log_warning "Some nodes failed to install. You can try installing them manually."
fi

echo "📁 Custom Nodes Location: $CUSTOM_NODES_DIR"
echo ""
echo "🚀 Next Steps:"
echo "   1. Restart ComfyUI to load the new nodes"
echo "   2. Check ComfyUI UI for the new node categories"
echo "   3. If any nodes are not working, check ComfyUI console for errors"
echo ""
echo "💡 To Start ComfyUI:"
echo "   \$ $(cd "$(dirname "$0")" && pwd)/start_comfyui.sh"
echo ""
echo "========================================================================"

