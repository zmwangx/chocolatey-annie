$ErrorActionPreference = 'Stop'

$packageArgs = @{
  PackageName    = 'annie'
  Url            = 'https://github.com/iawia002/annie/releases/download/v0.11.0/annie_0.11.0_Windows_32-bit.zip'
  Url64bit       = 'https://github.com/iawia002/annie/releases/download/v0.11.0/annie_0.11.0_Windows_64-bit.zip'
  Checksum       = '25283efae11b9694260eceab308957ea4e8299a2b4f5be06be16336d4d562c92'
  ChecksumType   = 'sha256'
  Checksum64     = '46caaed6ce774a01b861c6b32fb6483b1f7ec802bc1c41854431327d9183ae52'
  ChecksumType64 = 'sha256'
  UnzipLocation  = "$(split-path -parent $MyInvocation.MyCommand.Definition)"
}

Install-ChocolateyZipPackage @packageArgs
