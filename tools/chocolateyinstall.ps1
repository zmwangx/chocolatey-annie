$ErrorActionPreference = 'Stop'

$packageArgs = @{
  PackageName    = 'annie'
  Url            = 'https://github.com/iawia002/annie/releases/download/0.10.1/annie_0.10.1_Windows_32-bit.zip'
  Url64bit       = 'https://github.com/iawia002/annie/releases/download/0.10.1/annie_0.10.1_Windows_64-bit.zip'
  Checksum       = '0f6af860cc38b0f00b11efbfe7dfb019b5aaa38006b2d2007eb9e8075cdf7f8c'
  ChecksumType   = 'sha256'
  Checksum64     = 'e28cc077f663bf4581bdab1714dcb39135b0449dd44029fdae1d8fa1394a3bf1'
  ChecksumType64 = 'sha256'
  UnzipLocation  = "$(split-path -parent $MyInvocation.MyCommand.Definition)"
}

Install-ChocolateyZipPackage @packageArgs
