#!/bin/zsh

################################################################################
# ComfyUI Startup Script
# This script activates the conda environment and starts ComfyUI
################################################################################

COMFYUI_DIR="$HOME/ComfyUI"

echo "🎨 Starting ComfyUI with TTS-Audio-Suite..."
echo ""

# Source conda
CONDA_BASE=$(conda info --base)
source "$CONDA_BASE/etc/profile.d/conda.sh"

# Activate conda environment
conda activate comfyui || {
    echo "❌ Failed to activate conda environment 'comfyui'"
    echo "Please ensure the conda environment exists: conda env list"
    exit 1
}

# Export DYLD_LIBRARY_PATH so conda Python can find Homebrew libraries
# This is required for TTS-Audio-Suite to access libsamplerate and portaudio
export DYLD_LIBRARY_PATH="/opt/homebrew/lib:${DYLD_LIBRARY_PATH:-}"

# Navigate to ComfyUI directory
cd "$COMFYUI_DIR" || {
    echo "❌ ComfyUI directory not found: $COMFYUI_DIR"
    exit 1
}

# Start ComfyUI
echo "🚀 Launching ComfyUI..."
echo "📍 URL: http://127.0.0.1:8188"
echo ""
echo "Press Ctrl+C to stop ComfyUI"
echo ""
python main.py --listen

