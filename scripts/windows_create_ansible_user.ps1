param(
  [string]$Username = "ansible",
  [string]$Password # pass by   --parameters "password=StrongP@ss1!"
)

# skip if already present
if (Get-LocalUser -Name $Username -ErrorAction SilentlyContinue) { return }

$secpass = ConvertTo-SecureString $Password -AsPlainText -Force
New-LocalUser -Name $Username -Password $secpass
Add-LocalGroupMember -Group Administrators -Member $Username

# Enable WinRM HTTPS on 5986 (self-signed cert)
if (-not (Get-ChildItem WSMan:\localhost\Listener | ? { $_.Keys -like '*Transport=HTTPS*' })) {
    $cert = New-SelfSignedCertificate -DnsName $env:COMPUTERNAME -CertStoreLocation Cert:\LocalMachine\My
    New-WSManInstance -ResourceURI winrm/config/Listener -SelectorSet @{Address="*";Transport="HTTPS"} `
        -ValueSet @{Hostname=$env:COMPUTERNAME;CertificateThumbprint=$cert.Thumbprint}
    Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
    Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $false
}
