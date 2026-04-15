# Red Dragon Hub - GitHub Sync Script
# Adopted workflow from Kapustiak-maker's configuration

Write-Host "====================================" -ForegroundColor Magenta
Write-Host "   K. CHEAT REPO SYNC (V2)" -ForegroundColor White
Write-Host "====================================" -ForegroundColor Magenta

$repoUrl = "https://github.com/Kapustiak-maker/Roblox-Script-V2.git"

# Check if remote exists, update if it doesn't match
$remote = git remote get-url origin 2>$null
if ($null -eq $remote -or $remote -ne $repoUrl) {
    Write-Host "[!] Configuring remote origin to $repoUrl" -ForegroundColor Yellow
    git remote remove origin 2>$null
    git remote add origin $repoUrl
}

Write-Host "[>] Staging Changes (git add -A)..." -ForegroundColor Gray
git add -A

Write-Host "[>] Committing..." -ForegroundColor Gray
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "K. Cheat Update: $date"

Write-Host "[>] Force Pushing to GitHub (origin master:main)..." -ForegroundColor Gray
git push origin master:main --force

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n[+] SUCCESSFULLY SYNCED TO GITHUB!" -ForegroundColor Green
    Write-Host "[!] Your executor link:" -ForegroundColor Cyan
    Write-Host "loadstring(game:HttpGet('https://raw.githubusercontent.com/Kapustiak-maker/Roblox-Script-V2/main/main.lua'))()" -ForegroundColor White
} else {
    Write-Host "`n[-] FAILED TO SYNC. Check your GitHub permissions." -ForegroundColor Red
}

Write-Host "`nPress any key to exit..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
