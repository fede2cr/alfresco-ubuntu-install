Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing
Add-AppxPackage .\Ubuntu.appx

$params = @{
  Name = "alfresco"
  BinaryPathName = '"wsl -u alfresco -e /opt/alfresco/alfresco-service.sh servicestart"'
  DependsOn = "NetLogon"
  DisplayName = "Alfresco"
  StartupType = "Automatic"
  Description = "Alfresco Content Manager"
}
New-Service @params

$params = @{
  Name = "alfresco-search"
  BinaryPathName = '"wsl -u alfresco -e /opt/alfresco/solr6/solr/bin/solr start"'
  DependsOn = "NetLogon"
  DisplayName = "Alfresco Search"
  StartupType = "Automatic"
  Description = "Alfresco Solr6"
}
New-Service @params

