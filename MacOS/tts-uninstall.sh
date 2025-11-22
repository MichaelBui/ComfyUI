#!/bin/zsh

################################################################################
# TTS-Audio-Suite Uninstall Script
# This script removes TTS-Audio-Suite custom node and all TTS models
################################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

COMFYUI_DIR="$HOME/ComfyUI"

echo -e "${YELLOW}⚠️  TTS-Audio-Suite Uninstallation${NC}"
echo ""
echo "This will remove:"
echo "  • TTS-Audio-Suite custom node: $COMFYUI_DIR/custom_nodes/TTS-Audio-Suite"
echo "  • All TTS models: $COMFYUI_DIR/models/TTS"
echo ""
echo "This will NOT affect:"
echo "  • ComfyUI base installation"
echo "  • Other custom nodes"
echo "  • Conda environment"
echo "  • System packages (Homebrew, libsamplerate, portaudio)"
echo ""
echo -n "Are you sure you want to continue? (y/N): "
read
echo

if [[ ! ${REPLY:0:1} =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

echo ""
echo -e "${GREEN}Starting TTS uninstallation...${NC}"
echo ""

# Remove TTS-Audio-Suite custom node
echo -e "${YELLOW}[1/2]${NC} Removing TTS-Audio-Suite custom node..."
if [[ -d "$COMFYUI_DIR/custom_nodes/TTS-Audio-Suite" ]]; then
    rm -rf "$COMFYUI_DIR/custom_nodes/TTS-Audio-Suite"
    echo -e "${GREEN}✓${NC} TTS-Audio-Suite custom node removed"
else
    echo -e "${YELLOW}⚠${NC} TTS-Audio-Suite not found (already removed?)"
fi

# Remove TTS models directory
echo -e "${YELLOW}[2/2]${NC} Removing TTS models..."
if [[ -d "$COMFYUI_DIR/models/TTS" ]]; then
    rm -rf "$COMFYUI_DIR/models/TTS"
    echo -e "${GREEN}✓${NC} TTS models removed"
else
    echo -e "${YELLOW}⚠${NC} TTS models directory not found (already removed?)"
fi

echo ""
echo -e "${GREEN}✓ TTS-Audio-Suite has been completely uninstalled.${NC}"
echo ""
echo "Your ComfyUI base installation remains intact."
echo "To reinstall TTS components, run: $(dirname "$0")/tts-install.sh"
echo ""

