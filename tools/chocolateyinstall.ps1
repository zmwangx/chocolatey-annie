﻿$ErrorActionPreference = 'Stop'

$packageArgs = @{
  PackageName    = 'annie'
  Url            = 'https://github.com/iawia002/annie/releases/download/0.10.0/annie_0.10.0_Windows_32-bit.zip'
  Url64bit       = 'https://github.com/iawia002/annie/releases/download/0.10.0/annie_0.10.0_Windows_64-bit.zip'
  Checksum       = 'b65b4d2d6aa93d53e0787aae09f383423c09d6f6996d35ddd0e3965c7fd061f7'
  ChecksumType   = 'sha256'
  Checksum64     = 'd4f4bb5d22df0229b16ba9b48f771be60e2775263bee5c793c2f0865ce94ebb8'
  ChecksumType64 = 'sha256'
  UnzipLocation  = "$(split-path -parent $MyInvocation.MyCommand.Definition)"
}

Install-ChocolateyZipPackage @packageArgs
