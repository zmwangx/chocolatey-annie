$ErrorActionPreference = 'Stop'

$packageArgs = @{
  PackageName    = 'annie'
  Url            = 'https://github.com/iawia002/annie/releases/download/0.9.3/annie_0.9.3_Windows_32-bit.zip'
  Url64bit       = 'https://github.com/iawia002/annie/releases/download/0.9.3/annie_0.9.3_Windows_64-bit.zip'
  Checksum       = 'e4b5a87f01b26d3c135105a39f70986cc2be6329676da651c871734e26f149b2'
  ChecksumType   = 'sha256'
  Checksum64     = '8a1feba060f488d714df32c65541b0fad1eb78a246962782fff05f150b773cf3'
  ChecksumType64 = 'sha256'
  UnzipLocation  = "$(split-path -parent $MyInvocation.MyCommand.Definition)"
}

Install-ChocolateyZipPackage @packageArgs
