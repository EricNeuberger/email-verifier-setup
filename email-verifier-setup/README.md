# Email Verifier Setup Wizard — NO ADMIN RIGHTS NEEDED

**Complete one-click setup. Node.js bundled inside. Zero external dependencies.**

## What This Is

A setup wizard that:
- ✓ Automatically downloads Node.js
- ✓ Bundles Node.js inside the installer
- ✓ No admin rights needed for users
- ✓ No separate Node.js installation required
- ✓ Everything with button clicks

## For Users

**Just download and run `EmailVerifier-Setup.exe` or `EmailVerifier-Setup.dmg`**

The installer includes everything needed. No additional installations required.

## For Developers (YOU)

### Step 1: Install Node.js on YOUR Machine (For Building Only)
You (the developer) need Node.js to build the installer, but **your users won't need it**.

Download from: https://nodejs.org/ (LTS version)

### Step 2: Run the Build Script

**Windows:**
```
Double-click: build.bat
```

**Mac/Linux:**
```
bash build.sh
```

### What the Script Does Automatically:
1. ✓ Downloads portable Node.js
2. ✓ Bundles it inside the installer
3. ✓ Installs npm dependencies
4. ✓ Creates your installer
5. ✓ Cleans up temporary files

**Takes 5-10 minutes. Just wait.**

## After Building

Your installer will be in the `dist` folder:
- `EmailVerifier-Setup.exe` (Windows)
- `EmailVerifier-Setup.dmg` (Mac)

**Give this file to your users.** They run it without needing admin rights or Node.js installed.

## Why This Works Without Admin Rights

- **Bundled Node.js:** Node.js is inside the installer, not installed system-wide
- **Portable:** Everything runs from the app directory
- **Self-contained:** No external dependencies or system installations

Users can:
- ✓ Download the installer on a restricted device
- ✓ Run it without admin password
- ✓ Use Email Verifier immediately
- ✓ Uninstall like any normal program

## Files in This Package

- `build.bat` — Windows build script (run this on Windows)
- `build.sh` — Mac/Linux build script (run this on Mac)
- `main.js` — Electron app (uses bundled Node.js)
- `setup.html` — GUI wizard
- `setup-preload.js` — Security
- `package.json` — Config with bundled Node.js paths
- `README.md` — This file

## How Users Install

1. Download `EmailVerifier-Setup.exe` (Windows) or `.dmg` (Mac)
2. Double-click to run
3. Follow the 4-step wizard
4. Done!

No command prompt. No configuration. No admin rights. Just clicks.

## Building Process

```
You (Developer)          Users
─────────────────       ─────────────────
Install Node.js    →    (Node.js included)
Run build.bat      →    Download installer
Wait for build     →    Double-click
Get installer      →    Follow wizard
Give to users      →    Use immediately
```

## Support

For issues building the installer, make sure you have Node.js 16+ installed on your development machine.

---

**Bottom line:** You build once with Node.js. Your users run it without any installation.**
