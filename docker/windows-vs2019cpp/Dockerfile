# escape=`

# Use the latest Windows Server Core image with .NET Framework 4.8.
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

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
RUN curl -SL --output 7z1900-x64.exe https://www.7-zip.org/a/7z1900-x64.exe
RUN curl -SL --output PowerShell-7.1.5-win-x64.msi https://github.com/PowerShell/PowerShell/releases/download/v7.1.5/PowerShell-7.1.5-win-x64.msi
RUN curl -SL --output Git-2.33.1-64-bit.exe https://objects.githubusercontent.com/github-production-release-asset-2e65be/23216272/5cc99ec7-ee82-4076-98be-be4e327603cd?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20211106%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20211106T124623Z&X-Amz-Expires=300&X-Amz-Signature=c6e22a2d5bffd3deee07fb78c024081cd2a515bd44497051f35df3a2eb3830bd&X-Amz-SignedHeaders=host&actor_id=1905370&key_id=0&repo_id=23216272&response-content-disposition=attachment%3B%20filename%3DGit-2.33.1-64-bit.exe&response-content-type=application%2Foctet-stream
RUN 7z1900-x64.exe /S
RUN Git-2.33.1-64-bit.exe /VERYSILENT /NORESTART
RUN msiexec.exe /package PowerShell-7.1.5-win-x64.msi /quiet

# set path
RUN echo %PATH% && powershell -Command ./set_path.ps1
RUN echo %PATH%
RUN echo %VS2019_INSTALL_PATH%
RUN echo %VCPKG_CMAKE_PATH%

# prepare ninja, cmake
RUN curl -SL --output ninja-win.zip https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-win.zip
RUN curl -SL --output cmake-3.22.0-rc2-windows-x86_64.zip  https://github.com/Kitware/CMake/releases/download/v3.22.0-rc2/cmake-3.22.0-rc2-windows-x86_64.zip
RUN 7z e ninja-win.zip -o./ninja-win && `
  7z e cmake-3.22.0-rc2-windows-x86_64.zip -o./cmake-3.22.0-rc2-windows-x86_64 -y


# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
# ENTRYPOINT ["C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
ENTRYPOINT ["pwsh"]


LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/containers
