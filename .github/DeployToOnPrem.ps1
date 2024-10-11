Param(
    [Parameter(HelpMessage = "Parameters", Mandatory = $true)]
    [hashtable] $parameters
)
$EnvironmentName = $parameters.EnvironmentName

$deployAppsPath = 'C:\Deploy\DeployOnPrem\CustomApps'

Write-Host "Deploying to $EnvironmentName"
$deployApps = $parameters.apps
Write-Host "Cleaning up deployment folder"
Remove-item -Path ($deployAppsPath + '\*.*') -Recurse -Force
Write-Host "Move to deployment folder: $deployApps"
Move-Item -Path $deployApps -destination $deployAppsPath
Write-Host "Expanding artifacts"
$deployArtifacts = Get-ChildItem -Path $deployAppsPath -Filter '*.zip'
foreach ($deployArtifact in $deployArtifacts)
{
    Expand-Archive -Literalpath $deployArtifact.FullName -destination $deployAppsPath -Force
}

# Import custom Deployment Tools

Write-Host "Install or update Apps"
# execute Install CmdLet