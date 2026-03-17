# Apple Automation Scripts

This repository contains **Apple macOS automation scripts** designed to work with **Service Station** or **Automator**.  
These scripts help you manage files, videos, and system tasks quickly and efficiently directly from Finder.

Each script is described below with its functionality, usage, and requirements.

> **Note:** All scripts are AppleScript (`.scpt` or `.applescript`) files.


## 🎵 Audio Extract

Extract audio tracks from video files using **ffmpeg**.

### What it does
- Analyzes selected video files for audio codec compatibility  
- Instant copy for compatible codecs (**AAC, MP3, AC3, DTS, Opus**)  
- Re-encodes to **AAC 320kbps** for other codecs  
- Shows estimated processing time based on your CPU (**Apple Silicon / Intel**)  
- Outputs `.m4a` files in the same folder  

### Supported formats
`mp4 · mov · mkv · avi · webm · m4v · mpg · mpeg · flv · wmv · ts · m2ts · 3gp · ogv · vob`  

### Requirements
- **Bash**  
- Install ffmpeg via Homebrew:  
  ```bash
  brew install ffmpeg

## 📝 Rename

Batch rename files or folders with sequential numbering or a custom suffix.

### What it does
- Select between **files** or **folders** for renaming  
- Two renaming modes:  
  - **Full rename**: Replace names with base name + sequential number  
  - **Partial rename**: Append custom suffix to existing names  
- Preserves file extensions automatically  
- Shows completion notification with renamed items count  

### Renaming modes

| Mode          | Example                                  |
|---------------|------------------------------------------|
| Full rename   | `photo.jpg` → `image_1.jpg`, `image_2.jpg`, … |
| Partial rename| `photo.jpg` → `photo_backup.jpg`         |

## 🔢 Rename files
Rename multiple files with sequential numbering and optional leading zeros.

### What it does
- Renames selected files or lets you choose files via dialog  
- Adds sequential numbers with optional leading zeros (`01, 02…` or `001, 002…`)  
- Supports custom base name or numbers-only mode  
- Preserves original file extensions  
- Auto-calculates digit padding based on file count  

### Examples

| Files | Base name | Leading zeros | Result                                  |
|-------|-----------|---------------|----------------------------------------|
| 5     | photo     | Yes           | `photo1.jpg` … `photo5.jpg`           |
| 100   | img_      | Yes           | `img_001.jpg` … `img_100.jpg`         |
| 12    | (empty)   | Yes           | `01.jpg` … `12.jpg`                    |
| 8     | file      | No            | `file1.jpg` … `file8.jpg`             |

## 👻 Hidden Files

Show or hide hidden system files in Finder with one click.

### What it does
- Toggles visibility of hidden files (**dotfiles**, system files)  
- Automatically restarts Finder to apply changes  
- Simple **TRUE/FALSE** button interface  

## 📝 New Text File

Quickly create a new `.txt` file in the current Finder window.

### What it does
- Creates a blank text file in the active Finder folder  
- Prompts for filename (extension added automatically)  
- Opens in native TextEdit-compatible format  
