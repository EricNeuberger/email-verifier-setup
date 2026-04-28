const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('electronAPI', {
  onInstallProgress: (callback) => ipcRenderer.on('install-progress', callback),
  checkNode: () => ipcRenderer.invoke('check-node'),
  downloadNode: (version) => ipcRenderer.invoke('download-node', version),
  installDependencies: (workDir) => ipcRenderer.invoke('install-dependencies', workDir),
  launchEmailVerifier: (workDir) => ipcRenderer.invoke('launch-email-verifier', workDir),
  openExcelSetup: () => ipcRenderer.invoke('open-excel-setup'),
});
