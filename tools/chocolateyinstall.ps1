$ErrorActionPreference = 'Stop'

$packageArgs = @{
  PackageName    = 'annie'
  Url            = 'https://github.com/iawia002/annie/releases/download/0.9.4/annie_0.9.4_Windows_32-bit.zip'
  Url64bit       = 'https://github.com/iawia002/annie/releases/download/0.9.4/annie_0.9.4_Windows_64-bit.zip'
  Checksum       = '99d73d061bbc128bdf44473405f1a94eefa1836b442d4766371fa6669a3e4519'
  ChecksumType   = 'sha256'
  Checksum64     = 'b9b71b70e74656db84acfdbee2ba8cab3a283e723097de57525394c2ab9099e1'
  ChecksumType64 = 'sha256'
  UnzipLocation  = "$(split-path -parent $MyInvocation.MyCommand.Definition)"
}

Install-ChocolateyZipPackage @packageArgs
