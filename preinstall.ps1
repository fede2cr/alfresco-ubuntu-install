Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing
Add-AppxPackage .\Ubuntu.appx

$params = @{
  Name = "alfresco"
  BinaryPathName = '"wsl -u root -e /opt/alfresco/alfresco-service.sh servicestart"'
  DependsOn = "NetLogon"
  DisplayName = "Alfresco"
  StartupType = "AutomaticDelayedStart"
  Description = "Alfresco Content Manager"
}
New-Service @params


