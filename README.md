# HLL Branch Switcher

A simple Windows `*.bat` switcher for **Hell Let Loose** (`APPID 686810`) that lets you switch quickly between the **NORMAL** and **EXPERIMENTAL** Steam branches without having to redownload the entire game every time.

## Why this tool was created

When switching branches for **Hell Let Loose** in Steam, Steam starts downloading the game again, the full installation.

This script was created to avoid that.

Instead of forcing a full redownload every time you move between **NORMAL** and **EXPERIMENTAL**, it keeps both branch states locally and swaps them instantly by renaming the game folder and the Steam manifest files.

In most cases, Steam only needs to run a small patch or file check afterward.

## What the script does

The script manages two local installation states:

- `Hell Let Loose_normal`
- `Hell Let Loose_experimental`

It also manages the matching Steam manifest files:

- `appmanifest_686810_normal.acf`
- `appmanifest_686810_experimental.acf`

When you switch branches, the script renames the **active** installation and manifest to the opposite backup state, then restores the target branch as the active Steam installation.

That makes Steam see the desired branch immediately, without needing to download the whole game again.

## Features

- Switch between **NORMAL** and **EXPERIMENTAL**
- Save the current live installation as a backup for a branch
- Automatically closes:
  - `HLL-Win64-Shipping.exe`
  - `Steam.exe`
- Automatically restarts Steam after switching
- Stores the configured paths in a config file next to the batch file:
  - `HLL_BranchSwitcher.cfg`

## Requirements

- Windows
- Steam version of **Hell Let Loose**
- Enough disk space to keep **both branch installations locally**
- Access to your `steam.exe` path
- Access to your `steamapps` folder

Typical paths look like this:

```text
C:\Program Files (x86)\Steam\steam.exe
C:\Program Files (x86)\Steam\steamapps
```

## Important files and folders

The batch file works with these paths:

```text
steamapps\appmanifest_686810.acf
steamapps\appmanifest_686810_normal.acf
steamapps\appmanifest_686810_experimental.acf
steamapps\common\Hell Let Loose
steamapps\common\Hell Let Loose_normal
steamapps\common\Hell Let Loose_experimental
```

## Setup

### 1. Start the batch file

Run `HLL_Branch_Switcher.bat`.

### 2. Set the Steam path

From the menu choose:

- `4) Setup Steam Path (steam.exe)`

Then enter the full path to `steam.exe`.

### 3. Set the SteamApps path

From the menu choose:

- `5) Setup SteamApps Path (steamapps)`

Then enter the full path to your `steamapps` folder.

---

## First-time setup

To make fast switching work properly, you need:

- **one branch saved as a backup**
- **the other branch installed as the currently active live version**

After that, the script can build and maintain the second backup automatically during your first real switch.

### Scenario A: You currently have NORMAL installed

1. In the menu, choose:
   - `7) Save CURRENT installation as NORMAL`
2. This saves your current live installation as the **NORMAL** backup.
3. Start Steam.
4. Switch to the **EXPERIMENTAL** branch in Steam.
5. Let Steam **fully download/install EXPERIMENTAL once**.
6. After that, you have:
   - `NORMAL` saved as a backup
   - `EXPERIMENTAL` as the active live installation
7. Now perform your first real switch with:
   - `1) Switch to NORMAL`

During that switch, the currently active EXPERIMENTAL installation is automatically stored as the **EXPERIMENTAL** backup.

### Scenario B: You currently have EXPERIMENTAL installed

1. In the menu, choose:
   - `8) Save CURRENT installation as EXPERIMENTAL`
2. This saves your current live installation as the **EXPERIMENTAL** backup.
3. Start Steam.
4. Switch to the **NORMAL** branch in Steam.
5. Let Steam **fully download/install NORMAL once**.
6. After that, you have:
   - `EXPERIMENTAL` saved as a backup
   - `NORMAL` as the active live installation
7. Now perform your first real switch with:
   - `2) Switch to EXPERIMENTAL`

During that switch, the currently active NORMAL installation is automatically stored as the **NORMAL** backup.

---

## Normal usage

Once the initial setup is done, everyday use is simple:

- `1) Switch to NORMAL`
- `2) Switch to EXPERIMENTAL`

What happens during a switch:

1. The script closes Hell Let Loose and Steam.
2. The active folders and manifest files are renamed.
3. Steam is started again.
4. Steam detects the selected branch state.
5. If needed, Steam only runs a smaller validation or patch.

## Menu overview

- `1)` Switch to **NORMAL**
- `2)` Switch to **EXPERIMENTAL**
- `4)` Set the path to `steam.exe`
- `5)` Set the path to the `steamapps` folder
- `7)` Save the current live installation as **NORMAL**
- `8)` Save the current live installation as **EXPERIMENTAL**
- `9)` Exit

## Notes

- The script is specifically made for **Hell Let Loose** with **APPID 686810**.
- Before the tool becomes truly useful, the other branch must have been fully downloaded in Steam at least once.
- The tool does not copy huge amounts of data across the drive. It mainly works by renaming folders and manifest files.
- If Steam detects changed files or if a branch has received updates since the backup was created, a patch or validation may still be required.
- If a target backup folder already exists, the script aborts on purpose to avoid overwriting anything accidentally.

## Safety / backup recommendation

Use this tool at your own risk.

Before using it for the first time, it is recommended to back up:

- `steamapps\appmanifest_686810.acf`
- `steamapps\common\Hell Let Loose`

---

## Steam Guides/Workshop Page

https://steamcommunity.com/sharedfiles/filedetails/?id=3603977728
