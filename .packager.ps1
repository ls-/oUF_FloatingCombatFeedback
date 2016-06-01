Set-Location $PSScriptRoot

$curVersion = if ((Get-Content ".\oUF_FloatingCombatFeedback.toc" | Where { $_ -match "Version: ([0-9]+\.[0-9]+)" } ) -match "([0-9]+\.[0-9]+)") {$matches[1]}
$folderName = "oUF_FloatingCombatFeedback"
$zipName = $folderName + "-" + $curVersion + ".zip"

$includedFiles = @(
    ".\oUF_FloatingCombatFeedback.lua",
    ".\oUF_FloatingCombatFeedback.toc"
)

$filesToRemove = @(
    ".git",
)

Remove-Item * -Include @("*.zip", $folderName) -Recurse -Force

New-Item -Name $folderName -ItemType Directory | Out-Null
Copy-Item $includedFiles -Destination $folderName -Recurse
Remove-Item $folderName -Include $filesToRemove -Recurse -Force
Compress-Archive -Path $folderName -DestinationPath $zipName
Move-Item ".\oUF_FloatingCombatFeedback-*.zip" -Destination "..\" -Force

Remove-Item $folderName -Recurse -Force
