# escape=`

# Use the latest Windows Server Core image with .NET Framework 4.8.
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

WORKDIR "C:\\workspace"

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Install Build Tools with the Microsoft.VisualStudio.Workload.VCTools workload with clang components.
RUN curl -SL --output vs_buildtools.exe https://aka.ms/vs/16/release/vs_buildtools.exe 
RUN start /w vs_buildtools.exe --quiet --wait --norestart --nocache `
  --add Microsoft.VisualStudio.Workload.VCTools;includeRecommended `
  --add Microsoft.VisualStudio.Component.VC.Llvm.Clang `
  --add Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset `
  --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Llvm.Clang `
  || IF "%ERRORLEVEL%"=="3010" EXIT 0
# Cleanup
#    && del /q vs_buildtools.exe

# install latest tools
#   7z: https://www.7-zip.org/a/7z1900-x64.exe
#   git: https://git-scm.com/download/win
# COPY *.exe ./
RUN curl -SL --output 7z1900-x64.exe https://www.7-zip.org/a/7z1900-x64.exe
RUN 7z1900-x64.exe /S
#RUN Git-2.33.1-64-bit.exe /VERYSILENT /NORESTART

# install latest powershell7
RUN curl -SL --output PowerShell-7.1.5-win-x64.msi https://github.com/PowerShell/PowerShell/releases/download/v7.1.5/PowerShell-7.1.5-win-x64.msi
# COPY PowerShell-7.1.5-win-x64.msi ./
RUN msiexec.exe /package PowerShell-7.1.5-win-x64.msi /quiet


# prepare ninja, cmake
RUN curl -SL --output ninja-win.zip https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-win.zip
RUN curl -SL --output cmake-3.22.0-rc2-windows-x86_64.zip  https://github.com/Kitware/CMake/releases/download/v3.22.0-rc2/cmake-3.22.0-rc2-windows-x86_64.zip
# COPY *.zip ./
RUN set PATH=%PATH%;"C:\\Program Files\\7-Zip" && `
  7z e ninja-win.zip -o./ninja-win `
  7z e cmake-3.22.0-rc2-windows-x86_64.zip -o./cmake-3.22.0-rc2-windows-x86_64


# set env
RUN powershell && `
  [environment]::SetEnvironmentvariable("VS2019_INSTALL_PATH", "C:\Program Files (x86)\Microsoft Visual studio\2019\BuildTools", "Machine") && `
  #[environment]::SetEnvironmentvariable("VCPKG_CMAKE_PATH", "C:\workspace\vcpkg\scripts\buildsystems\vcpkg.cmake", "Machine") && `
  [environment]::SetEnvironmentvariable("PATH", "$([environment]::GetEnvironmentvariable("Path", "Machine"));C:\\Program Files\\7-Zip;C:\\workspace\\ninja-win;C:\\workspace\\cmake-3.22.0-rc2-windows-x86_64\\bin", "Machine")
RUN pwsh && $ENV:VS2019_INSTALL_PATH && $ENV:PATH


# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
# ENTRYPOINT ["C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
ENTRYPOINT ["pwsh"]


LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/containers
