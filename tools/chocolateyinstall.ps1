$ErrorActionPreference = 'Stop'

$packageArgs = @{
  PackageName    = 'annie'
  Url            = 'https://github.com/iawia002/annie/releases/download/0.10.3/annie_0.10.3_Windows_32-bit.zip'
  Url64bit       = 'https://github.com/iawia002/annie/releases/download/0.10.3/annie_0.10.3_Windows_64-bit.zip'
  Checksum       = 'bc864400e601659424c69df99afa28a36e931b0b88282dcd268be30d7118fb55'
  ChecksumType   = 'sha256'
  Checksum64     = '79a6ab2ce98175b295778e820cc462452c9f23a08f44cbba3d631018fe2f2f1e'
  ChecksumType64 = 'sha256'
  UnzipLocation  = "$(split-path -parent $MyInvocation.MyCommand.Definition)"
}

Install-ChocolateyZipPackage @packageArgs
