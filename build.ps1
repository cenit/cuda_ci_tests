#!/usr/bin/env pwsh

$number_of_build_workers=8
$vstype="Community"

$env:CUDACXX="$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0\bin"
$env:CMAKE_CUDA_COMPILER="$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0\bin"
$env:CUDA_TOOLKIT_ROOT_DIR="$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0"
$env:CUDA_PATH="$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0"
$env:CUDA_PATH_V10_1="$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0"
$env:PATH="$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0\nvvm\bin;$env:PATH"
$env:PATH="$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0\bin;$env:PATH"


if ((Get-Command "cl.exe" -ErrorAction SilentlyContinue) -eq $null)
{
  pushd "C:\Program Files (x86)\Microsoft Visual Studio\2017\${vstype}\Common7\Tools"
  cmd /c "VsDevCmd.bat -arch=x64 & set" |
    foreach {
    if ($_ -match "=") {
      $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
    }
  }
  popd
  Write-Host "Visual Studio 2017 ${vstype} Command Prompt variables set.`n" -ForegroundColor Yellow
}

if (Test-Path env:VCPKG_ROOT) {
  # DEBUG
  New-Item -Path .\build_win_debug -ItemType directory -Force
  Set-Location build_win_debug
  cmake -G "Visual Studio 15 2017" -T "host=x64" -A "x64" "-DCMAKE_TOOLCHAIN_FILE=$env:VCPKG_ROOT\scripts\buildsystems\vcpkg.cmake" "-DVCPKG_TARGET_TRIPLET=$env:VCPKG_DEFAULT_TRIPLET"   "-DCMAKE_BUILD_TYPE=Debug" ..
  Set-Location ..
}
else {
  Write-Host "Skipping vcpkg-enabled builds because the VCPKG_ROOT environment variable is not defined`n" -ForegroundColor Yellow
}

