# Rebrand Script for Fokus Janten
Write-Host "Starting rebrand script"
# Backup articles.json
Copy-Item -Path "articles.json" -Destination "articles.json.bak.$(Get-Date -Format 'yyyyMMddHHmmss')" -Force

# Initialize counters
$mainPagesChanged = 0
$articlePagesChanged = 0
$cssChanged = 0
$packageChanged = 0
$docsChanged = 0

# Function to replace in file
function Replace-InFile {
    param (
        [string]$filePath,
        [string]$oldString,
        [string]$newString
    )
    $content = Get-Content $filePath -Raw -Encoding UTF8
    if ($content -match [regex]::Escape($oldString)) {
        $content = $content -replace [regex]::Escape($oldString), $newString
        Set-Content $filePath $content -Encoding UTF8
        return $true
    }
    return $false
}

# Get all relevant files
$files = Get-ChildItem -Recurse -Include *.html,*.css,*.json,*.md,*.toml

foreach ($file in $files) {
    $changed = $false

    # Branding changes
    $changed = Replace-InFile -filePath $file.FullName -oldString "Arah Berita" -newString "Fokus Janten" -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString "arahberita" -newString "fokusjanten" -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString "Arahberita" -newString "FokusJanten" -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString "arah berita" -newString "fokus janten" -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString "arahberita@gmail.com" -newString "fokusjanten@gmail.com" -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString "facebook.com/arahberita" -newString "facebook.com/fokusjanten" -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString "twitter.com/arahberita" -newString "twitter.com/fokusjanten" -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString "instagram.com/arahberita" -newString "instagram.com/fokusjanten" -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString "youtube.com/arahberita" -newString "youtube.com/fokusjanten" -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString "- Arah Berita" -newString "- Fokus Janten" -or $changed

    # Color changes in CSS
    if ($file.Extension -eq ".css") {
        $changed = Replace-InFile -filePath $file.FullName -oldString "--primary: #FFCC00" -newString "--primary: #0EA5E9" -or $changed
        $changed = Replace-InFile -filePath $file.FullName -oldString "--dark: #1E2024" -newString "--dark: #0F172A" -or $changed
        $changed = Replace-InFile -filePath $file.FullName -oldString "--secondary: #someoldcolor" -newString "--secondary: #22C55E" -or $changed  # Assuming old secondary, adjust if needed
        $changed = Replace-InFile -filePath $file.FullName -oldString "#FFCC00" -newString "#0EA5E9" -or $changed
        $changed = Replace-InFile -filePath $file.FullName -oldString "#1E2024" -newString "#0F172A" -or $changed
    }

    # Logo removal and text-based logo
    $changed = Replace-InFile -filePath $file.FullName -oldString 'img src="img/logo.png"' -newString '' -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString 'img src="../img/logo.png"' -newString '' -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString 'alt="Arah Berita"' -newString 'alt="Fokus Janten"' -or $changed
    # For navbar-brand, replace with text logo
    $changed = Replace-InFile -filePath $file.FullName -oldString '<a class="navbar-brand"><img src="img/logo.png" alt="Arah Berita"></a>' -newString '<a class="navbar-brand"><span style="font-weight: bold; color: #0EA5E9;">FOKUS</span><span style="color: #22C55E;"> JANTEN</span></a>' -or $changed

    # Encoding fixes
    $changed = Replace-InFile -filePath $file.FullName -oldString "”" -newString '"' -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString "“" -newString '"' -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString "’" -newString "'" -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString "‘" -newString "'" -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString "–" -newString "-" -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString "—" -newString "-" -or $changed
    $changed = Replace-InFile -filePath $file.FullName -oldString " " -newString " " -or $changed  # nbsp to space

    # Package metadata
    if ($file.Name -eq "package.json") {
        $changed = Replace-InFile -filePath $file.FullName -oldString '"name": "arahberita"' -newString '"name": "fokusjanten"' -or $changed
        $changed = Replace-InFile -filePath $file.FullName -oldString '"name": "arahberita-article-generator"' -newString '"name": "fokusjanten-article-generator"' -or $changed
    }

    # Count changes
    if ($changed) {
        if ($file.Directory.Name -eq "article") {
            $articlePagesChanged++
        } elseif ($file.Extension -eq ".html" -and $file.Directory.Name -ne "article") {
            $mainPagesChanged++
        } elseif ($file.Extension -eq ".css") {
            $cssChanged++
        } elseif ($file.Extension -eq ".json") {
            $packageChanged++
        } elseif ($file.Extension -in ".md", ".toml") {
            $docsChanged++
        }
    }
}

# Output results
Write-Host "Main pages changed: $mainPagesChanged"
Write-Host "Article pages changed: $articlePagesChanged"
Write-Host "CSS files changed: $cssChanged"
Write-Host "Package files changed: $packageChanged"
Write-Host "Docs changed: $docsChanged"
Write-Host "Rebrand Fokus Janten selesai ✅"