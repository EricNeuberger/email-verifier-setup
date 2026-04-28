const { app, BrowserWindow, Menu, ipcMain } = require('electron');
const path = require('path');
const fs = require('fs');
const { spawn } = require('child_process');

let setupWindow;
let emailVerifierProcess;

// Use bundled Node.js - no external installation needed
const nodeDir = path.join(process.resourcesPath, 'node-portable');
const npmCmd = process.platform === 'win32' ? 
  path.join(nodeDir, 'npm.cmd') : 
  path.join(nodeDir, 'bin', 'npm');

function createSetupWindow() {
  setupWindow = new BrowserWindow({
    width: 600,
    height: 700,
    webPreferences: {
      preload: path.join(__dirname, 'setup-preload.js'),
      contextIsolation: true,
    },
  });

  setupWindow.loadFile('setup.html');
  setupWindow.on('closed', () => {
    setupWindow = null;
    if (emailVerifierProcess) {
      emailVerifierProcess.kill();
    }
  });
}

app.on('ready', createSetupWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});

// Check if bundled Node.js is available
ipcMain.handle('check-node', async () => {
  return new Promise((resolve) => {
    const nodeExe = process.platform === 'win32' ? 
      path.join(nodeDir, 'node.exe') : 
      path.join(nodeDir, 'bin', 'node');
    
    // Check if bundled node exists
    fs.stat(nodeExe, (err) => {
      resolve(!err); // true if exists, false if error
    });
  });
});

ipcMain.handle('get-work-directory', async () => {
  // email-verifier-electron is bundled with the app
  return path.join(process.resourcesPath, 'email-verifier-electron');
});

// Install dependencies using bundled npm
ipcMain.handle('install-dependencies', async (event, workDir) => {
  return new Promise((resolve, reject) => {
    const child = spawn(npmCmd, ['install'], {
      cwd: workDir,
      stdio: 'pipe',
      shell: true,
    });

    let output = '';
    child.stdout.on('data', (data) => {
      output += data.toString();
      event.sender.send('install-progress', data.toString());
    });

    child.stderr.on('data', (data) => {
      output += data.toString();
      event.sender.send('install-progress', data.toString());
    });

    child.on('close', (code) => {
      if (code === 0) {
        resolve('Dependencies installed successfully');
      } else {
        reject(new Error(`Installation failed. Code: ${code}`));
      }
    });
  });
});

// Launch Email Verifier using bundled npm
ipcMain.handle('launch-email-verifier', async (event, workDir) => {
  return new Promise((resolve, reject) => {
    emailVerifierProcess = spawn(npmCmd, ['start'], {
      cwd: workDir,
      stdio: 'pipe',
      shell: true,
    });

    let started = false;
    const timeout = setTimeout(() => {
      if (!started) {
        started = true;
        resolve('Email Verifier launched');
      }
    }, 3000);

    emailVerifierProcess.stdout.on('data', (data) => {
      const output = data.toString();
      if ((output.includes('running') || output.includes('listening')) && !started) {
        started = true;
        clearTimeout(timeout);
        resolve('Email Verifier launched successfully');
      }
      event.sender.send('launch-progress', output);
    });

    emailVerifierProcess.stderr.on('data', (data) => {
      event.sender.send('launch-progress', data.toString());
    });

    emailVerifierProcess.on('error', reject);
  });
});

ipcMain.handle('open-excel-setup', async () => {
  const { shell } = require('electron');
  shell.openExternal('https://support.microsoft.com/en-us/office/');
  return true;
});
