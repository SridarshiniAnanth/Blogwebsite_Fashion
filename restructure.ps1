$rootDir = "c:\Users\SRIDARSHINI A\Desktop\fashion blog\root"
$htmlFiles = Get-ChildItem -Path $rootDir -Filter "*.html"

$pattern = '(?i)(?:src|href)="([^"]+)"'
$allPaths = @()

foreach ($html in $htmlFiles) {
    $content = Get-Content -Path $html.FullName -Raw
    $matches = [regex]::Matches($content, $pattern)
    foreach ($m in $matches) {
        $allPaths += $m.Groups[1].Value
    }
}

$allPaths = $allPaths | Select-Object -Unique
$movedCount = 0

foreach ($path in $allPaths) {
    if ($path -match "^http" -or $path -match "^mailto:" -or [string]::IsNullOrWhiteSpace($path)) {
        continue
    }
    
    $normalizedPath = $path.Replace('/', '\')
    $targetFile = Join-Path -Path $rootDir -ChildPath $normalizedPath
    $targetDir = [System.IO.Path]::GetDirectoryName($targetFile)
    $basename = [System.IO.Path]::GetFileName($path)
    
    if ($path -match "/") {
        $sourceFile = Join-Path -Path $rootDir -ChildPath $basename
        if (Test-Path $sourceFile -PathType Leaf) {
            if (-not (Test-Path $targetFile)) {
                if (-not (Test-Path $targetDir)) {
                    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
                }
                Write-Host "Moving $basename -> $path"
                Move-Item -Path $sourceFile -Destination $targetFile
                $movedCount++
            }
        }
    }
}
Write-Host "Moved files: $movedCount"
