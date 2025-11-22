#!/bin/zsh

################################################################################
# ComfyUI Uninstall Script
# This script removes ComfyUI and its conda environment completely
################################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}⚠️  ComfyUI Uninstallation${NC}"
echo ""
echo "This will remove:"
echo "  • ComfyUI installation directory: $HOME/ComfyUI"
echo "  • Conda environment: comfyui"
echo ""
echo "This will NOT affect:"
echo "  • Homebrew installation"
echo "  • Conda installation"
echo "  • System packages (git, wget, portaudio)"
echo ""
echo -n "Are you sure you want to continue? (y/N): "
read
echo

if [[ ! ${REPLY:0:1} =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

echo ""
echo -e "${GREEN}Starting uninstallation...${NC}"
echo ""

# Remove conda environment
echo -e "${YELLOW}[1/2]${NC} Removing conda environment 'comfyui'..."
if conda env list | grep -q "^comfyui "; then
    conda env remove -n comfyui -y
    echo -e "${GREEN}✓${NC} Conda environment removed"
else
    echo -e "${YELLOW}⚠${NC} Conda environment 'comfyui' not found (already removed?)"
fi

# Remove installation directory
echo -e "${YELLOW}[2/2]${NC} Removing ComfyUI directory..."
if [[ -d "$HOME/ComfyUI" ]]; then
    rm -rf "$HOME/ComfyUI"
    echo -e "${GREEN}✓${NC} ComfyUI directory removed"
else
    echo -e "${YELLOW}⚠${NC} ComfyUI directory not found (already removed?)"
fi

echo ""
echo -e "${GREEN}✓ ComfyUI has been completely uninstalled.${NC}"
echo ""
echo "Your system packages (Homebrew, Conda, git, wget, portaudio) remain installed."
echo ""

