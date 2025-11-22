# ComfyUI Vast.AI Provisioning Scripts

## Architecture

```mermaid
graph TD
    A[ai-dock Container] -->|Upload| B{Provisioning Entry Point}
    B -->|Flux| C[provisioning-flux.sh]
    B -->|VibeVoice| D[provisioning-vibevoice.sh]
    B -->|WAN| E[provisioning-wan-infinitytalk.sh]
    
    C --> F[lib/common.sh]
    D --> F
    E --> F
    
    C --> G[lib/flux-install.sh]
    D --> H[lib/vibevoice-install.sh]
    E --> I[lib/wan-install.sh]
    
    F --> J[Shared Functions]
    G --> K[Flux Models<br/>19 models ~ 22GB]
    H --> L[VibeVoice Models<br/>3 models ~ 5GB]
    I --> M[WAN Models<br/>6 models ~ 14GB]
    
    J --> N[download_model]
    J --> O[get_nodes]
    J --> P[install_python_packages]
    
    style B fill:#f9f,stroke:#333,stroke-width:4px
    style F fill:#bbf,stroke:#333,stroke-width:2px
    style J fill:#bfb,stroke:#333,stroke-width:2px
```

## File Structure

```mermaid
graph LR
    A[VastAI/] --> B[lib/]
    A --> C[Provisioning Scripts]
    
    B --> D[common.sh]
    B --> E[*-install.sh]
    B --> F[*-uninstall.sh]
    
    C --> G[provisioning-flux.sh]
    C --> H[provisioning-vibevoice.sh]
    C --> I[provisioning-wan-infinitytalk.sh]
    
    style A fill:#f9f,stroke:#333,stroke-width:4px
    style B fill:#bbf,stroke:#333,stroke-width:2px
    style C fill:#bbf,stroke:#333,stroke-width:2px
```

## Installation Flow

```mermaid
flowchart TD
    A[Start: User uploads provisioning-X.sh] --> B[ai-dock executes script]
    B --> C{lib/ exists?}
    C -->|No| D[Clone GitHub repo]
    C -->|Yes| E[Use existing lib/]
    D --> E
    E --> F[Source lib/common.sh]
    F --> G[Source lib/X-install.sh]
    G --> H[Load configuration arrays]
    H --> I[Install QoL nodes<br/>14 common nodes]
    I --> J[For each model in array]
    J --> K{File exists?}
    K -->|Yes| L{Size matches?}
    L -->|Yes| M[Skip download]
    L -->|No| N[Remove incomplete file]
    K -->|No| N
    N --> O[Download model]
    O --> P[Verify size]
    P --> Q{Size correct?}
    Q -->|Yes| R[Next model]
    Q -->|No| S[Error: Abort]
    M --> R
    R --> T{More models?}
    T -->|Yes| J
    T -->|No| U[Setup directories & symlinks]
    U --> V[Complete]
    
    style A fill:#bfb,stroke:#333,stroke-width:2px
    style V fill:#bfb,stroke:#333,stroke-width:2px
    style S fill:#fbb,stroke:#333,stroke-width:2px
```

## Uninstallation Flow

```mermaid
flowchart TD
    A[Start: ./lib/X-uninstall.sh] --> B[Source lib/X-install.sh]
    B --> C[Load configuration arrays]
    C --> D[Remove custom nodes]
    D --> E[For each model in array]
    E --> F{File exists?}
    F -->|Yes| G[Delete file]
    F -->|No| H[Skip]
    G --> I[Next model]
    H --> I
    I --> J{More models?}
    J -->|Yes| E
    J -->|No| K[Complete]
    
    style A fill:#fbb,stroke:#333,stroke-width:2px
    style K fill:#bfb,stroke:#333,stroke-width:2px
```

## Switching Setups

```mermaid
sequenceDiagram
    participant U as User
    participant FU as flux-uninstall.sh
    participant WI as wan-install.sh
    participant C as common.sh
    
    U->>FU: ./lib/flux-uninstall.sh
    FU->>FU: Load Flux arrays
    FU->>U: Remove Flux nodes & models
    Note over U: Flux completely removed
    
    U->>WI: ./lib/wan-install.sh
    WI->>C: Use download_model()
    C->>U: Download WAN models
    WI->>U: Install WAN nodes
    Note over U: WAN ready to use
```

## Model Download Logic

```mermaid
flowchart LR
    A[download_model] --> B{File exists?}
    B -->|No| C[Download with wget]
    B -->|Yes| D[Get actual size]
    D --> E{Size == expected?}
    E -->|Yes| F[Skip download]
    E -->|No| G[Remove file]
    G --> C
    C --> H[Verify downloaded size]
    H --> I{Size correct?}
    I -->|Yes| J[Success]
    I -->|No| K[Error]
    F --> J
    
    style J fill:#bfb,stroke:#333,stroke-width:2px
    style K fill:#fbb,stroke:#333,stroke-width:2px
```

## Data Flow

```mermaid
graph LR
    A[HuggingFace] -->|x-linked-size| B[Configuration Arrays]
    B --> C[MODEL_URLS]
    B --> D[MODEL_DESTS]
    B --> E[MODEL_SIZES]
    B --> F[MODEL_DESCS]
    
    C --> G[download_model]
    D --> G
    E --> G
    F --> G
    
    G --> H[Idempotent Download]
    H --> I[Size Validation]
    I --> J[Success]
    
    style A fill:#f9f,stroke:#333,stroke-width:2px
    style B fill:#bbf,stroke:#333,stroke-width:2px
    style J fill:#bfb,stroke:#333,stroke-width:2px
```

## Quick Reference

### Usage
```bash
# Initial provisioning (ai-dock)
# Upload: provisioning-flux.sh (or vibevoice, or wan)

# Switch setups (inside container)
cd /workspace/comfyui-scripts/VastAI
./lib/flux-uninstall.sh
./lib/wan-install.sh
```

### Model Sizes

| Setup | Size | Models | Components |
|-------|------|--------|------------|
| Flux | 22 GB | 19 | UNET, CLIP, Loras, VAE, ESRGAN |
| VibeVoice | 5 GB | 3 | TTS-Audio-Suite, VibeVoice 1.5B |
| WAN | 14 GB | 6 | WAN 2.1, InfinityTalk, Loras, VAE |

### Directory Paths

| Type | Path |
|------|------|
| Models | `/workspace/storage/stable_diffusion/models/` |
| Custom Nodes | `/opt/ComfyUI/custom_nodes/` |
| Scripts | `/workspace/comfyui-scripts/VastAI/` |

### Environment Variables (ai-dock)

- `$WORKSPACE` - Workspace root
- `$PIP_INSTALL` - Pip command with flags
- `$AUTO_UPDATE` - Auto-update toggle

## Configuration Format

```bash
# In lib/*-install.sh (top of file)
declare -a MODEL_URLS MODEL_DESTS MODEL_SIZES MODEL_DESCS

MODEL_URLS+=("https://huggingface.co/.../model?download=true")
MODEL_DESTS+=("subdir/model.safetensors")
MODEL_SIZES+=(1234567890)  # Exact bytes
MODEL_DESCS+=("Model Name - X.XX GB")
```

## Error Handling

```mermaid
graph TD
    A[Function Call] --> B{Success?}
    B -->|Yes| C[return 0]
    B -->|No| D[Log error]
    D --> E[return 1]
    E --> F[Caller checks return code]
    F --> G{Error?}
    G -->|Yes| H[Abort installation]
    G -->|No| I[Continue]
    
    style C fill:#bfb,stroke:#333,stroke-width:2px
    style H fill:#fbb,stroke:#333,stroke-width:2px
```

## Maintenance

### Add Model

1. Get size: `curl -I "URL" | grep x-linked-size`
2. Edit `lib/X-install.sh`: Append to 4 arrays
3. Uninstall auto-syncs (sources install script)

### Add Setup

1. Create `lib/newsetup-install.sh` with arrays + `install_newsetup()`
2. Create `lib/newsetup-uninstall.sh` with `uninstall_newsetup()`
3. Create `provisioning-newsetup.sh` entry point

## Key Features

- ✅ **Idempotent**: Rerun = instant (skips existing)
- ✅ **Size Validation**: Detects incomplete downloads
- ✅ **Modular**: Shared `download_model()` function
- ✅ **Declarative**: Edit arrays, not code
- ✅ **Auto-sync**: Uninstall reads install arrays
- ✅ **Bandwidth Efficient**: No redundant downloads
- ✅ **Cost Efficient**: Fast reruns save cloud costs
