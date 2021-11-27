# escape=`

# Use the latest Windows Server Core image 
FROM mcr.microsoft.com/windows/servercore:ltsc2019

WORKDIR "C:\\workspace"

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Install VS2019 Build Tools with the Microsoft.VisualStudio.Workload.VCTools workload with clang components.
RUN curl -SL --output vs_buildtools.exe https://aka.ms/vs/16/release/vs_buildtools.exe 
RUN start /w vs_buildtools.exe --quiet --wait --norestart --nocache `
  --add Microsoft.VisualStudio.Workload.VCTools;includeRecommended `
  --add Microsoft.VisualStudio.Component.VC.Llvm.Clang `
  --add Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset `
  --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Llvm.Clang `
  || IF "%ERRORLEVEL%"=="3010" EXIT 0
# Cleanup
#    && del /q vs_buildtools.exe


COPY . ./

# install latest tools
#   7z: https://www.7-zip.org/a/7z1900-x64.exe
#   git: https://git-scm.com/download/win
#   powershell7: https://github.com/PowerShell/PowerShell/releases/download/v7.1.5/PowerShell-7.1.5-win-x64.msi
RUN IF NOT EXIST "7z1900-x64.exe" ( curl -SL --output 7z1900-x64.exe https://www.7-zip.org/a/7z1900-x64.exe )
RUN IF NOT EXIST "PowerShell-7.1.5-win-x64.msi" ( curl -SL --output PowerShell-7.1.5-win-x64.msi https://github.com/PowerShell/PowerShell/releases/download/v7.1.5/PowerShell-7.1.5-win-x64.msi )
RUN IF NOT EXIST "Git-2.34.0-32-bit.exe" ( curl -SL --output Git-2.34.0-32-bit.exe https://github.com/git-for-windows/git/releases/download/v2.34.0.windows.1/Git-2.34.0-32-bit.exe )
RUN 7z1900-x64.exe /S
RUN Git-2.34.0-32-bit.exe /VERYSILENT /NORESTART
RUN msiexec.exe /package PowerShell-7.1.5-win-x64.msi /quiet

# set path
RUN echo %PATH% && powershell -Command ./set_path.ps1
RUN echo %PATH%
RUN echo %VS2019_INSTALL_PATH%
RUN echo %VCPKG_CMAKE_PATH%

# prepare ninja, cmake
RUN IF NOT EXIST "ninja-win.zip" ( curl -SL --output ninja-win.zip https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-win.zip )
RUN IF NOT EXIST "cmake-3.22.0-rc2-windows-x86_64.zip" ( curl -SL --output cmake-3.22.0-rc2-windows-x86_64.zip  https://github.com/Kitware/CMake/releases/download/v3.22.0-rc2/cmake-3.22.0-rc2-windows-x86_64.zip )
RUN 7z x ninja-win.zip -o./ninja-win && `
  7z x cmake-3.22.0-rc2-windows-x86_64.zip -y

# install vcpkg
RUN git clone https://github.com/microsoft/vcpkg && `
  .\vcpkg\bootstrap-vcpkg.bat -disableMetrics
  # powershell -Command .\vcpkg\vcpkg.exe install ffmpeg:x86-windows-static libwebsockets:x86-windows-static

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
# ENTRYPOINT ["C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
ENTRYPOINT ["pwsh"]

LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/containers
