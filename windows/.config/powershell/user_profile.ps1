# Start Starship prompt
Invoke-Expression (&starship init powershell)

# Start Terminal Icons
Import-Module -Name Terminal-Icons

# Start Zoxide
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })

# Start PSReadLine
Import-Module PSReadLine

# Configure PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -BellStyle None

# Start PSFzf
Import-Module PSFzf

# Configure PSFzf
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Aliases
Set-Alias grep findstr