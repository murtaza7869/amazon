$url = "https://raw.githubusercontent.com/murtaza7869/amazon/refs/heads/main/nvda.ini"

# Temporary file to store the downloaded nvda.ini
$tempFile = "$env:TEMP\nvda.ini"

# Download nvda.ini
Write-Host "Downloading nvda.ini..."
Invoke-WebRequest -Uri $url -OutFile $tempFile

if (-Not (Test-Path $tempFile)) {
    Write-Host "Failed to download nvda.ini." -ForegroundColor Red
    exit 1
}

# Path to user profiles
$userProfiles = Get-ChildItem "C:\Users" | Where-Object { $_.PsIsContainer }

foreach ($profile in $userProfiles) {
    $appDataPath = "C:\Users\$($profile.Name)\AppData\Roaming\nvda"

    # Ensure the nvda folder exists
    if (-Not (Test-Path $appDataPath)) {
        Write-Host "Creating directory: $appDataPath"
        New-Item -ItemType Directory -Path $appDataPath -Force | Out-Null
    }

    # Copy the nvda.ini to the user profile's AppData\Roaming\nvda folder
    $destinationFile = "$appDataPath\nvda.ini"
    Write-Host "Copying nvda.ini to $destinationFile"
    Copy-Item -Path $tempFile -Destination $destinationFile -Force
}

# Cleanup temporary file
Remove-Item -Path $tempFile -Force

Write-Host "Operation completed successfully." -ForegroundColor Green
