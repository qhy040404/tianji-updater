$url = "YOUR-TIANJI-SERVER-URL"
$workspace = "YOUR-WORKSPACE-ID"
$name = "YOUR-MACHINE-NAME"

$latest = Invoke-WebRequest -Uri "https://api.github.com/repos/msgbyte/tianji/releases/latest"
$latest = $latest.Content | ConvertFrom-Json

if (Test-Path "latest") {
    $local = Get-Content -Path "latest"
    if ($local -eq $latest.tag_name) {
        Write-Host "No new version available"
        taskkill /im tianji-reporter-windows-amd64*
        Start-Process -FilePath "tianji-reporter-windows-amd64.exe" -ArgumentList "--url $url --workspace $workspace --name $name" -NoNewWindow
        exit 0
    }
}

taskkill /im tianji-reporter-windows-amd64*
Write-Host "New version available: $($latest.tag_name)"
Write-Host "Downloading new version"
Invoke-WebRequest -Uri "https://github.com/msgbyte/tianji/releases/download/$($latest.tag_name)/tianji-reporter-windows-amd64.exe" -OutFile "tianji-reporter-windows-amd64.exe"

$latest.tag_name | Out-File -FilePath "latest"
Start-Process -FilePath "tianji-reporter-windows-amd64.exe" -ArgumentList "--url $url --workspace $workspace --name $name" -NoNewWindow
exit 0
