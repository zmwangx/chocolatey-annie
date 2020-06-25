$ErrorActionPreference = 'Stop'

$packageArgs = @{
  PackageName    = 'annie'
  Url            = 'https://github.com/iawia002/annie/releases/download/0.10.2/annie_0.10.2_Windows_32-bit.zip'
  Url64bit       = 'https://github.com/iawia002/annie/releases/download/0.10.2/annie_0.10.2_Windows_64-bit.zip'
  Checksum       = '985ddf50ffc0cde78599606c43d82f593a5399c60566af998a7a589fc3bfcfc3'
  ChecksumType   = 'sha256'
  Checksum64     = 'f01315fee2afb69f616ede541c9ad8ed48168cde0c57cf1b2d39eebb1a177336'
  ChecksumType64 = 'sha256'
  UnzipLocation  = "$(split-path -parent $MyInvocation.MyCommand.Definition)"
}

Install-ChocolateyZipPackage @packageArgs
