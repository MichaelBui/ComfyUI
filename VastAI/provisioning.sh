#!/bin/bash

# This file will be sourced in init.sh

# https://raw.githubusercontent.com/ai-dock/comfyui/main/config/provisioning/default.sh

# Tue Nov 26 01:17:33 2024 - fp8 + T5 fp8
# +---------------------------------------------------------------------------------------+
# | NVIDIA-SMI 535.113.01             Driver Version: 535.113.01   CUDA Version: 12.2     |
# |-----------------------------------------+----------------------+----------------------+
# | GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
# | Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
# |                                         |                      |               MIG M. |
# |=========================================+======================+======================|
# |   0  NVIDIA GeForce RTX 3090        On  | 00000000:81:00.0 Off |                  N/A |
# | 72%   81C    P2             348W / 350W |  17946MiB / 24576MiB |    100%      Default |
# |                                         |                      |                  N/A |
# +-----------------------------------------+----------------------+----------------------+

# Wed Nov 27 04:58:39 2024 - GGUF Q8 + T5 fp16
# +---------------------------------------------------------------------------------------+
# | NVIDIA-SMI 535.113.01             Driver Version: 535.113.01   CUDA Version: 12.2     |
# |-----------------------------------------+----------------------+----------------------+
# | GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
# | Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
# |                                         |                      |               MIG M. |
# |=========================================+======================+======================|
# |   0  NVIDIA GeForce RTX 3090        On  | 00000000:81:00.0 Off |                  N/A |
# | 49%   74C    P2             348W / 350W |  22905MiB / 24576MiB |    100%      Default |
# |                                         |                      |                  N/A |
# +-----------------------------------------+----------------------+----------------------+

# Thu Nov 28 06:46:20 2024 - GGUF Q8 + T5 fp16 + PulID
# +---------------------------------------------------------------------------------------+
# | NVIDIA-SMI 535.113.01             Driver Version: 535.113.01   CUDA Version: 12.2     |
# |-----------------------------------------+----------------------+----------------------+
# | GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
# | Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
# |                                         |                      |               MIG M. |
# |=========================================+======================+======================|
# |   0  NVIDIA GeForce RTX 3090        On  | 00000000:81:00.0 Off |                  N/A |
# | 30%   53C    P2             149W / 350W |  24022MiB / 24576MiB |     21%      Default |
# |                                         |                      |                  N/A |
# +-----------------------------------------+----------------------+----------------------+

# Mon Dec  2 00:19:30 2024 - GGUF Q8 + T5xxl fp16
# +-----------------------------------------------------------------------------------------+
# | NVIDIA-SMI 560.35.03              Driver Version: 560.35.03      CUDA Version: 12.6     |
# |-----------------------------------------+------------------------+----------------------+
# | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
# | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
# |                                         |                        |               MIG M. |
# |=========================================+========================+======================|
# |   0  NVIDIA GeForce RTX 3060        On  |   00000000:03:00.0 Off |                  N/A |
# | 59%   73C    P0            168W /  170W |   11487MiB /  12288MiB |    100%      Default |
# |                                         |                        |                  N/A |
# +-----------------------------------------+------------------------+----------------------+

# Sun Dec  8 02:21:23 2024 - Jib Mix Q8 + T5xxl fp16 @ 1024x1536
# +-----------------------------------------------------------------------------------------+
# | NVIDIA-SMI 550.120                Driver Version: 550.120        CUDA Version: 12.4     |
# |-----------------------------------------+------------------------+----------------------+
# | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
# | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
# |                                         |                        |               MIG M. |
# |=========================================+========================+======================|
# |   0  NVIDIA GeForce RTX 3090        On  |   00000000:24:00.0 Off |                  N/A |
# | 62%   61C    P2            349W /  350W |   21291MiB /  24576MiB |    100%      Default |
# |                                         |                        |                  N/A |
# +-----------------------------------------+------------------------+----------------------+

PYTHON_PACKAGES=(
    #"opencv-python==4.7.0.72"
    "insightface==0.7.3"
)

NODES=(
    # Core Nodes
    "https://github.com/ltdrdata/ComfyUI-Manager"

    # QOL Nodes
    "https://github.com/crystian/ComfyUI-Crystools" # System Stats
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack" # Too many utilities
    "https://github.com/ltdrdata/ComfyUI-Inspire-Pack" # Too many utilities
    "https://github.com/WASasquatch/was-node-suite-comfyui" # Too many utilities
    "https://github.com/rgthree/rgthree-comfy" # Too many utilities
    "https://github.com/cubiq/ComfyUI_essentials" # Too many utilities
    "https://github.com/chrisgoringe/cg-use-everywhere" # Anything everywhere
    "https://github.com/Fannovel16/comfyui_controlnet_aux" # Pre-Processors for Depth, Canny,...
    "https://github.com/pythongosssss/ComfyUI-Custom-Scripts" # Export workflow as image
    "https://github.com/kijai/ComfyUI-KJNodes" # Empty lantent
    "https://github.com/adieyal/comfyui-dynamicprompts" # Dynamic Prompts
    # "https://github.com/spacepxl/ComfyUI-Florence-2" # Image description & segmentation
    # "https://github.com/coolzilj/ComfyUI-Photopea" # Integrated photo editor
    https://github.com/Jcd1230/rembg-comfyui-node # Remove Background
    https://github.com/erosDiffusion/ComfyUI-enricos-nodes # Image Compositor

    # Flux
    "https://github.com/city96/ComfyUI-GGUF"
    "https://github.com/ShmuelRonen/ComfyUI-Apply_Style_Model_Adjust"
    "https://github.com/sipie800/ComfyUI-PuLID-Flux-Enhanced"
    # "https://github.com/fairy-root/Flux-Prompt-Generator"

    # "https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes"
    # "https://github.com/royceschultz/ComfyUI-Notifications"
    # "https://github.com/failfa-st/failfast-comfyui-extensions"

    # "https://github.com/pythongosssss/ComfyUI-WD14-Tagger"

    # SDXL Nodes
    # "https://github.com/cubiq/ComfyUI_IPAdapter_plus" # ✅
    # "https://github.com/shadowcz007/comfyui-mixlab-nodes"
    # "https://github.com/jags111/efficiency-nodes-comfyui" # ✅
    # "https://github.com/hinablue/ComfyUI_3dPoseEditor"
    # "https://github.com/ZHO-ZHO-ZHO/ComfyUI-YoloWorld-EfficientSAM" ❗️ INCOMPATIBLE
    # "https://github.com/Acly/comfyui-inpaint-nodes" # ✅
    # "https://github.com/storyicon/comfyui_segment_anything"
    # "https://github.com/ssitu/ComfyUI_UltimateSDUpscale" # ✅
    # "https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch" # ✅
    # "https://github.com/kijai/ComfyUI-SUPIR" # ✅
    # "https://github.com/11cafe/comfyui-workspace-manager" ❗️ Not working
)
# UUID=$(cat /proc/sys/kernel/random/uuid)
CHECKPOINT_MODELS=(
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/autismmixSDXL_autismmixConfetti.safetensors?download=true" # PDXL
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/forartisticxl_v01Fp16.safetensors?download=true" # Bad results
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/animaPencilXL_v500.safetensors?download=true" # Bad results
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/animagineXLV31_v31.safetensors?download=true" # Bad results
    # "https://civitai.com/api/download/models/369130?type=Model&format=SafeTensor&size=full&fp=fp16" # _CHEYENNE_
    # "https://drive.usercontent.google.com/download?id=1S-Rd_Uc5_7j0R6G2OW7WUb9xIWscDyll&export=download&confirm=t&uuid=${UUID}" # _CHEYENNE_
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/upscalers/SUPIR-v0Q_fp16.safetensors?download=true" # Quality
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/SUPIR-v0F_fp16.safetensors?download=true" # Fedility ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/leosamsHelloworldXL_helloworldXL70.safetensors?download=true" # Good but not great
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/albedobaseXL_v21.safetensors?download=true" # Good but not great
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/demonCORESFWNSFW_41MIDGARDBEAST.safetensors?download=true"  # Good but not great
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/haveallsdxl_v10.safetensors?download=true" # Good but not great
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/wildcardxXLFusion_fusionOG.safetensors?download=true" # Good but not great
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/zavychromaxl_v80.safetensors?download=true" # Old version
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/CHEYENNE_v16.safetensors?download=true" # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/halcyonSDXL_v17.safetensors?download=true" # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/zavychromaxl_v90.safetensors?download=true" # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/mannEDreams_v004.safetensors?download=true" # 832x832 DPP SDE Karras 8 steps

    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/flux/flux_dev_fp8_scaled_diffusion_model.safetensors?download=true" # 11.9 GB
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/flux/pixelwave_flux1Dev03.safetensors?download=true" # 11.9 GB
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/flux/stoiqoNewrealityFLUXSD35_f1DAlphaTwo.safetensors?download=true" # 11.9 GB
)

UNET_MODELS=(
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/flux/flux_dev_fp8_scaled_diffusion_model.safetensors?download=true" # 11.9 GB
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/flux/stoiqoNewrealityFLUXSD35_f1DAlphaTwo.safetensors?download=true" # 11.9 GB
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/flux/jibMixFlux_v5ItsAliveQ4GGUF.safetensors?download=true" # 11.9 GB

    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/flux/flux1-dev-Q8_0.gguf?download=true" # 12.7 GB
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/flux/jibMixFlux_v6RealPix.gguf?download=true" # 12.7 GB
    "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/flux/flux1-dev-Q5_K_S.gguf?download=true" # 8.29 GB
    # "https://huggingface.co/city96/FLUX.1-dev-gguf/resolve/main/flux1-dev-Q6_K.gguf?download=true" # 9.8 GB

    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/flux/flux1-fill-dev-Q8_0.gguf?download=true" # 12.7 GB # Inpaint/Outpaint
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/flux/flux1-fill-dev-Q5_K_S.gguf?download=true" # 8.29 GB
)

CLIP_MODELS=(
    "https://huggingface.co/MichaelBui/Collection/resolve/main/clip/clip_l.safetensors?download=true" # 0.25 GB
    "https://huggingface.co/MichaelBui/Collection/resolve/main/clip/ViT-L-14-BEST-smooth-GmP-TE-only-HF-format.safetensors?download=true" # 0.33 GB
    "https://huggingface.co/MichaelBui/Collection/resolve/main/clip/ViT-L-14-TEXT-detail-improved-hiT-GmP-TE-only-HF.safetensors?download=true" # 0.33 GB
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/clip/Jib_Mix_XL_Clip_G_clip_g_00001_.safetensors?download=true" # 1.39 GB

    # "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors?download=true" # 4.89 GB
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/clip/t5xxl_fp16.safetensors?download=true" # 9.79 GB
    "https://huggingface.co/MichaelBui/Collection/resolve/main/clip/t5xxl_fp8_e4m3fn_scaled.safetensors?download=true" # 5.16 GB

    # "https://huggingface.co/city96/t5-v1_1-xxl-encoder-gguf/resolve/main/t5-v1_1-xxl-encoder-f16.gguf?download=true" # 9.53 GB
    "https://huggingface.co/city96/t5-v1_1-xxl-encoder-gguf/resolve/main/t5-v1_1-xxl-encoder-Q8_0.gguf?download=true" # 5.06 GB
)

STYLE_MODELS=(
    "https://huggingface.co/MichaelBui/Collection/resolve/main/style_models/flux1-redux-dev.safetensors?download=true" # 0.13 GB
)

PULID_MODELS=(
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/pulid/pulid_flux_v0.9.1.safetensors?download=true" # 1.14 GB
)

INSIGHTFACE_MODELS=(
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/insightface/antelopev2.zip?download=true" # 0.37 GB
)

LORA_MODELS=(
    #"https://civitai.com/api/download/models/16576"
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/ip-adapter-faceid-plusv2_sdxl_lora.safetensors?download=true" # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/Nada_Namie-PonyXL-1024px.safetensors?download=true" # PDXL
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/chibi-p.safetensors?download=true" # PDXL
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/stickersXL.safetensors?download=true" #PDXL
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/qban-nig.safetensors?download=true" # Fried
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/Designer_BlindBox-000015.safetensors?download=true" # Fried
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/chibi_v0.0.1.safetensors?download=true" # Too simple
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/ChibiRay.safetensors?download=true"
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/Pop_Art_Pony-000019.safetensors?download=true"
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/StickersRedmond.safetensors?download=true" # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/mengwa.safetensors?download=true" # chibi # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/zavy-ctflt-sdxl.safetensors?download=true" # zavy-ctflt, drawing # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/J_illustration.safetensors?download=true" # J_illustration # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/EldritchComicsXL1.2.safetensors?download=true" # comic book
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/Illustration_style.safetensors?download=true" # illustrStyle
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/Graphic_Novel_Illustration-000007.safetensors?download=true" # graphic novel illustration
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/CartoonStyle_Hap_XL.safetensors?download=true" # cartoon style,  clip 1, str 1.6

    "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/FLUX.1-Turbo-Alpha.safetensors?download=true" # 0.70 GB
    "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/flux1-canny-dev-lora.safetensors?download=true" # 1.24 GB
    "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/flux1-depth-dev-lora.safetensors?download=true" # 1.24 GB

    "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/aidmaMJ6.1-FLUX-v0.4.safetensors?download=true" # 0.08 GB # "aidmaMJ6.1"
    "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/Niji%20B.safetensors?download=true" # 0.22 GB "Niji Stan Katayama Style"
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/Flux.1_Turbo_Detailer.safetensors?download=true" # 0.04 GB
    "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/Funtik.safetensors?download=true" # 0.08 GB # "Funtik_Style" - Hand drawn cartoon 80s style
    "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/flat-illus-flux-v1.safetensors?download=true" # 0.07 GB # "anime, 2d, flat illustration, flat color"
    "https://huggingface.co/MichaelBui/Collection/resolve/main/loras/flux/boFLUX%20Double%20Exposure%20Magic%20v2.safetensors?download=true" # 0.02 GB # "bo-exposure, double exposure,"

    "https://huggingface.co/Shakker-Labs/FLUX.1-dev-LoRA-Logo-Design/resolve/main/FLUX-dev-lora-Logo-Design.safetensors?download=true" # 0.04 GB
    "https://huggingface.co/Shakker-Labs/FLUX.1-dev-LoRA-add-details/resolve/main/FLUX-dev-lora-add_details.safetensors?download=true" # 0.69 GB

    # "https://huggingface.co/strangerzonehf/Flux-Cute-3D-Kawaii-LoRA/resolve/main/Cute-3d-Kawaii.safetensors?download=true" # 0.62GB # Cute 3D chibi
    # "https://huggingface.co/strangerzonehf/Flux-Midjourney-Mix2-LoRA/resolve/main/mjV6.safetensors?download=true" # 0.62 GB

    # "https://huggingface.co/XLabs-AI/flux-lora-collection/resolve/main/anime_lora_comfy_converted.safetensors?download=true" # 0.05 GB
    # "https://huggingface.co/XLabs-AI/flux-lora-collection/resolve/main/mjv6_lora_comfy_converted.safetensors?download=true" # 0.05 GB
    # "https://huggingface.co/XLabs-AI/flux-lora-collection/resolve/main/art_lora_comfy_converted.safetensors?download=true" # 0.36 GB
)

VAE_MODELS=(
    # "https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors"
    # "https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors"
    # "https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"
    # "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors?download=true" # 0.34 GB
    "https://huggingface.co/MichaelBui/Collection/resolve/main/vae/ae.safetensors?download=true" # 0.34 GB
)

ESRGAN_MODELS=(
    "https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/4x-UltraSharp.pth?download=true" # 0.07 GB # ✅ Realistic
    "https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/4x_foolhardy_Remacri.pth?download=true" # 0.07 GB # ✅ Anime    
    "https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/8x_NMKD-Superscale_150000_G.pth?download=true" # 0.07 GB # ✅ Denoise 0.2-0.35
)

CONTROLNET_MODELS=(
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/controlnets/xinsir-controlnet-openpose-sdxl-1.0.safetensors?download=true"
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/controlnets/xinsir-controlnet-canny-sdxl-1.0.safetensors?download=true"
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/controlnets/xinsir-controlnet-depth-sdxl-1.0.safetensors?download=true"
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/controlnetsthibaud-controlnet-openpose-sdxl-1.0.safetensors?download=true"
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/controlnets/thibaud-controlnet-openpose-sdxl-1.0-rank256.safetensors?download=true"
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/controlnets/sai-controlnet-canny-sdxl-rank256.safetensors?download=true"
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/controlnets/sai-controlnet-depth-sdxl-rank256.safetensors?download=true"
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/controlnets/mistoline-controlnet-sdxl-1.0.safetensors?download=true"
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/controlnets/mistoline-controlnet-sdxl-1.0-rank256.safetensors?download=true"
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/controlnets/xinsir-controlnet-union-1.0.safetensors?download=true" # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/controlnets/xinsir-controlnet-union-promax-1.0.safetensors.safetensors?download=true"

    # "https://huggingface.co/MichaelBui/Collection/resolve/main/controlnets/flux/FLUX.1-dev-ControlNet-Union-Pro.safetensors?download=true" # 6.6 GB
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/controlnets/flux/Shakker-Labs_FLUX.1-dev-ControlNet-Union-Pro-fp8.safetensors?download=true" # 3.3 GB
)

IPADAPTER_MODELS=(
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/ipadapters/ip-adapter-faceid-plusv2_sdxl.bin?download=true" # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/ipadapters/ip-adapter-plus-face_sdxl_vit-h.safetensors?download=true" # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/ipadapters/ip-adapter-plus_sdxl_vit-h.safetensors?download=true" # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/ipadapters/ip-adapter_sdxl_vit-h.safetensors?download=true" # ✅
)

EMBEDDING_MODELS=(
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/embeddings/SimplePositiveXLv2.safetensors?download=true" # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/embeddings/negativeXL_D.safetensors?download=true" # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/embeddings/unaestheticXL_bp5.safetensors?download=true" # ✅
)

INPAINT_MODELS=(
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/inpaint/fooocus_inpaint_head.pth?download=true" # ✅
    # "https://huggingface.co/MichaelBui/Collection/resolve/main/inpaint/inpaint_v26.fooocus.patch?download=true" # ✅
)

CLIP_VISION_MODELS=(
    # "https://huggingface.co/dstnrsh/CLIP-ViT-H-14-laion2B-s32B-b79K/resolve/main/CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors" # ✅
    # "https://huggingface.co/google/siglip-so400m-patch14-384/resolve/main/model.safetensors?download=true" # 3.51 GB
    "https://huggingface.co/MichaelBui/Collection/resolve/main/clip_vision/sigclip_vision_patch14_384.safetensors?download=true" # 0.86 GB
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    DISK_GB_AVAILABLE=$(($(df --output=avail -m "${WORKSPACE}" | tail -n1) / 1000))
    DISK_GB_USED=$(($(df --output=used -m "${WORKSPACE}" | tail -n1) / 1000))
    DISK_GB_ALLOCATED=$(($DISK_GB_AVAILABLE + $DISK_GB_USED))
    provisioning_print_header
    provisioning_get_nodes
    provisioning_install_python_packages
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/ckpt" \
        "${CHECKPOINT_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/unet" \
        "${UNET_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/clip" \
        "${CLIP_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/lora" \
        "${LORA_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/style_models" \
        "${STYLE_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/pulid" \
        "${PULID_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/insightface/models" \
        "${INSIGHTFACE_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/ipadapter" \
        "${IPADAPTER_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/embeddings" \
        "${EMBEDDING_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/inpaint" \
        "${INPAINT_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/clip_vision" \
        "${CLIP_VISION_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/vae" \
        "${VAE_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/esrgan" \
        "${ESRGAN_MODELS[@]}"
    provisioning_print_end
}

function provisioning_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="/opt/ComfyUI/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                    micromamba -n comfyui run ${PIP_INSTALL} -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                micromamba -n comfyui run ${PIP_INSTALL} -r "${requirements}"
            fi
        fi
    done
}

function provisioning_install_python_packages() {
    if [ ${#PYTHON_PACKAGES[@]} -gt 0 ]; then
        micromamba -n comfyui run ${PIP_INSTALL} ${PYTHON_PACKAGES[*]}
    fi
}

function provisioning_get_models() {
    if [[ -z $2 ]]; then return 1; fi
    dir="$1"
    mkdir -p "$dir"
    shift
    if [[ $DISK_GB_ALLOCATED -ge $DISK_GB_REQUIRED ]]; then
        arr=("$@")
    else
        printf "WARNING: Low disk space allocation - Only the first model will be downloaded!\n"
        arr=("$1")
    fi
    
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
    if [[ $DISK_GB_ALLOCATED -lt $DISK_GB_REQUIRED ]]; then
        printf "WARNING: Your allocated disk size (%sGB) is below the recommended %sGB - Some models will not be downloaded\n" "$DISK_GB_ALLOCATED" "$DISK_GB_REQUIRED"
    fi
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Web UI will start now\n\n"
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
}

# syncthing cli --gui-address="127.0.0.1:18384" --gui-apikey="${WEB_TOKEN}" show system
# mkdir -p /workspace/ComfyUI/output
# deviceId="RIDMC6H-5DRTF5D-BLZVWVI-ZR2GCHS-45NJSXV-KKPJOAT-RVDPQSS-LMEMRQT"
# folderId=$(head -c 6 /dev/urandom | xxd -p)
# syncthing cli config folders add --id $folderId --path /workspace/ComfyUI/output
# syncthing cli config devices add --device-id $deviceId
# syncthing cli config folders $folderId devices add --device-id $deviceId
# (comfyui) root@C.13865316:/workspace$ syncthing cli show system
# syncthing: error: reading device ID: open /root/.local/state/syncthing/cert.pem: no such file or directory
# (comfyui) root@C.13865316:/workspace$ folderId=$(head -c 6 /dev/urandom | xxd -p)
# (comfyui) root@C.13865316:/workspace$ syncthing cli config folders add --id $folderId --path /workspace/ComfyUI/output
# syncthing: error: reading device ID: open /root/.local/state/syncthing/cert.pem: no such file or directory
# (comfyui) root@C.13865316:/workspace$ syncthing cli config devices add --device-id $deviceId^C
# (comfyui) root@C.13865316:/workspace$ deviceId="RIDMC6H-5DRTF5D-BLZVWVI-ZR2GCHS-45NJSXV-KKPJOAT-RVDPQSS-LMEMRQT"
# (comfyui) root@C.13865316:/workspace$ syncthing cli config devices add --device-id $deviceId
# syncthing: error: reading device ID: open /root/.local/state/syncthing/cert.pem: no such file or directory

# PROVISIONING
provisioning_start

mkdir -p /workspace/storage/stable_diffusion/models/unet
mkdir -p /workspace/storage/stable_diffusion/models/controlnet
mkdir -p /workspace/storage/stable_diffusion/models/pulid
mkdir -p /workspace/ComfyUI/custom_nodes/Plush-for-ComfyUI

ln -sf /workspace/storage/stable_diffusion/models/inpaint /workspace/ComfyUI/models/
ln -sf /workspace/storage/stable_diffusion/models/pulid /workspace/ComfyUI/models/
ln -sf /workspace/storage/stable_diffusion/models/insightface /workspace/ComfyUI/models/

# Will fail the plugin installation
# touch /workspace/ComfyUI/custom_nodes/Plush-for-ComfyUI/opt_models.txt
# echo "gemini-1.5-flash\\ngemini-1.5-pro\\ngemini-exp-1121\\ngemini-exp-1206\\n" > /workspace/ComfyUI/custom_nodes/Plush-for-ComfyUI/opt_models.txt

# unzip /workspace/storage/stable_diffusion/models/insightface/models/antelopev2.zip -d /workspace/storage/stable_diffusion/models/insightface/models/
# wget -qnc --content-disposition --show-progress -e dotbytes="4M" -P /workspace/storage/stable_diffusion/models/unet/ "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/flux/flux1-fill-dev-Q8_0.gguf?download=true"
# wget -qnc --content-disposition --show-progress -e dotbytes="4M" -P /workspace/storage/stable_diffusion/models/unet/ "https://huggingface.co/MichaelBui/Collection/resolve/main/checkpoints/flux/flux1-dev-Q8_0.gguf?download=true"
# wget -qnc --content-disposition --show-progress -e dotbytes="4M" -P /workspace/storage/stable_diffusion/models/pulid/ "https://huggingface.co/MichaelBui/Collection/resolve/main/pulid/pulid_flux_v0.9.1.safetensors?download=true"
# wget -qnc --content-disposition --show-progress -e dotbytes="4M" -P /workspace/storage/stable_diffusion/models/controlnet/ "https://huggingface.co/MichaelBui/Collection/resolve/main/controlnets/flux/Shakker-Labs_FLUX.1-dev-ControlNet-Union-Pro-fp8.safetensors?download=true"
