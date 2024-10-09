# Installation script for Windows dotfiles

# Constants
$BaseDestination = "$env:USERPROFILE"
$BaseOrigin = "$BaseDestination\.dotfiles\windows"
$WindowsTerminalBase = (Get-ChildItem -Path "$BaseDestination\AppData\Local\Packages\Microsoft.WindowsTerminal_*" | Select-Object -First 1).FullName

# List of files that need to be symlinked to another location rather than the local structure
# that is represented by the base origin and base destination file structure
$NoRelative = (
    [PSCustomObject]@{
        Origin      = "$BaseOrigin\.config\powershell\Microsoft.PowerShell_profile.ps1"
        Destination = "$BaseDestination\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    },
    [PSCustomObject]@{
        Origin      = "$BaseOrigin\terminal\settings.json"
        Destination = "$WindowsTerminalBase\LocalState\settings.json"
    }
)

# Function to map the base origin file structure to the base destination file structure
# ignoring the files that need to be symlinked to another location 
# returns a list of Origin and Destination for the symlinks
function Get-LinkList {
    param (
        [string]$Origin,
        [string]$Destination,
        [array]$NoRelative
    )

    try {
        $Files = Get-ChildItem -Path $Origin -Recurse -File
        $FileList = @()
        
        foreach ($File in $Files) {
            $RelativePath = $File.FullName.Substring($Origin.Length + 1)
            $DestinationPath = "$Destination\$RelativePath"

            if (-not ($NoRelative | Where-Object { $_.Origin -eq $File.FullName })) {
                $FileList += [PSCustomObject]@{
                    Origin      = $File.FullName
                    Destination = $DestinationPath
                }
            }
        }
        
        Write-Host "Found $($FileList.Count) dotfiles to be symlinked." -ForegroundColor Green

        return $FileList
    }
    catch {
        Write-Host "An error occurred while generating the link list: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Stack Trace: $($_.Exception.StackTrace)" -ForegroundColor Red
        return $null
    }
}

# Function to create a symlink and handle backups
function New-Symlink {
    param (
        [string]$Origin,
        [string]$Destination
    )

    if (Test-Path -Path $Destination) {
        $BackupPath = "$Destination.bak"
        $OldBackupPath = "$Destination.bak.old"
        
        if (Test-Path -Path $BackupPath) {
            if (Test-Path -Path $OldBackupPath) {
                Write-Host "Replacing existing backup: $OldBackupPath" -ForegroundColor Yellow
                Remove-Item -Path $OldBackupPath
            }
            Write-Host "Renaming $BackupPath to $OldBackupPath" -ForegroundColor Yellow
            Rename-Item -Path $BackupPath -NewName $OldBackupPath
        }

        # Check if the destination is a symbolic link
        $DestinationItem = Get-Item -Path $Destination
        if ($DestinationItem.LinkType -eq 'SymbolicLink') {
            $RealFilePath = (Get-Item -Path $DestinationItem.Target).FullName
            Write-Host "Backing up real file $RealFilePath to $BackupPath" -ForegroundColor Cyan
            Copy-Item -Path $RealFilePath -Destination $BackupPath
        }
        else {
            Write-Host "Backing up $Destination to $BackupPath" -ForegroundColor Cyan
            Move-Item -Path $Destination -Destination $BackupPath
        }
    }

    # Check if the symlink already exists and points to the same target
    if (Test-Path -Path $Destination -PathType Leaf) {
        $ExistingLink = Get-Item -Path $Destination

        if ($ExistingLink.LinkType -eq 'HardLink' -and (Get-Item -Path $ExistingLink.Target).FullName -eq (Get-Item -Path $Origin).FullName) {
            Write-Host "HardLink already exists with the same target. Removing it in favor of SymbolicLink" -ForegroundColor Yellow
            Remove-Item -Path $Destination
        }

        if ($ExistingLink.LinkType -eq 'SymbolicLink' -and (Get-Item -Path $ExistingLink.Target).FullName -eq (Get-Item -Path $Origin).FullName) {
            Write-Host "SymbolicLink already exists with the same target. Skipping creation." -ForegroundColor Yellow
            return
        }
    }

    Write-Host "Creating SymbolicLink from '$Origin' to '$Destination'" -ForegroundColor Cyan
    New-Item -ItemType SymbolicLink -Path $Destination -Value $Origin
}

try {
    $AllLinks = Get-LinkList -Origin $BaseOrigin -Destination $BaseDestination -NoRelative $NoRelative

    $FinalLinkList = $AllLinks + $NoRelative

    # Prompts the symlinking process
    foreach ($Link in $FinalLinkList) {
        New-Symlink -Origin $Link.Origin -Destination $Link.Destination
    }
    
    Write-Host "Successfully restored $($AllLinks.Count) dotfiles." -ForegroundColor Green
    Write-Host "Successfully restored $($NoRelative.Count) non-relative dotfiles." -ForegroundColor Green
}
catch {
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Stack Trace: $($_.Exception.StackTrace)" -ForegroundColor Red
}