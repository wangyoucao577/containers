[Environment]::SetEnvironmentvariable("PATH", $ENV:PATH + ";C:\Program Files\7-Zip;C:\workspace\ninja-win;C:\workspace\cmake-3.22.0-rc2-windows-x86_64\bin", [EnvironmentVariableTarget]::Machine)
[environment]::SetEnvironmentvariable("VS2019_INSTALL_PATH", "C:\Program Files (x86)\Microsoft Visual studio\2019\BuildTools", "Machine")
[environment]::SetEnvironmentvariable("VCPKG_CMAKE_PATH", "C:\workspace\vcpkg\scripts\buildsystems\vcpkg.cmake", "Machine")
