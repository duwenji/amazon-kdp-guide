# ============================================
# EPUB3 pageList 追加機能
# ============================================

function Get-PageLocationFromEpub {
    param([Parameter(Mandatory=$true)] [string]$EpubPath)
    
    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $tempDir | Out-Null
    
    try {
        $epubAsZip = $EpubPath -replace '\.epub$', '.zip'
        Copy-Item -Path $EpubPath -Destination $epubAsZip -Force | Out-Null
        Expand-Archive -Path $epubAsZip -DestinationPath $tempDir -Force | Out-Null
        
        # OEBPS/xhtml フォルダを探す
        $xhtmlPath = Join-Path (Join-Path $tempDir 'OEBPS') 'xhtml'
        if (-not (Test-Path $xhtmlPath)) {
            $xhtmlPath = Join-Path $tempDir 'OEBPS'
        }
        if (-not (Test-Path $xhtmlPath)) {
            $xhtmlPath = $tempDir
        }
        
        $xhtmlFiles = @(Get-ChildItem -Path $xhtmlPath -Filter '*.xhtml' -File -ErrorAction SilentlyContinue)
            Write-Host "  ℹ️  XHTMLファイル: $($xhtmlFiles.Count)個 in $xhtmlPath" -ForegroundColor Gray
        
        $pageLinks = @()
        $pageNum = 1
        
        $xhtmlFiles | Where-Object { $_.Name -notmatch 'nav|toc' } | Sort-Object Name | ForEach-Object {
            $content = Get-Content -Path $_.FullName -Raw -Encoding UTF8
            $matches = [regex]::Matches($content, 'id=[''"]([^''">]+)[''"]')
            
            $matches | ForEach-Object {
                $anchorId = $_.Groups[1].Value
                if (-not [string]::IsNullOrWhiteSpace($anchorId)) {
                    $pageLinks += @{
                        Href = "$($_.Name)#$anchorId"
                        Number = $pageNum
                    }
                    $pageNum++
                }
            }
        }
        
        Write-Host "  ℹ️  抽出ポイント: $($pageLinks.Count)個" -ForegroundColor Gray
        return $pageLinks
    } finally {
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path $epubAsZip) { Remove-Item -Path $epubAsZip -Force -ErrorAction SilentlyContinue }
    }
}

function Add-PageListToEpub {
    param([Parameter(Mandatory=$true)] [string]$EpubPath)
    
    Write-Host "📖 EPUB3 pageList を追加中..." -ForegroundColor Cyan
    
    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $tempDir | Out-Null
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    
    try {
        $epubAsZip = $EpubPath -replace '\.epub$', '.zip'
        Copy-Item -Path $EpubPath -Destination $epubAsZip -Force | Out-Null
        Expand-Archive -Path $epubAsZip -DestinationPath $tempDir -Force | Out-Null

        $navPath = Join-Path (Join-Path $tempDir 'OEBPS') 'xhtml'
        if (-not (Test-Path $navPath)) {
            $navPath = Join-Path $tempDir 'OEBPS'
        }
        if (-not (Test-Path $navPath)) {
            $navPath = $tempDir
        }
        
        $pageLinks = Get-PageLocationFromEpub -EpubPath $EpubPath
        if ($pageLinks.Count -eq 0) {
            Write-Host "⚠️  参照ポイント未検出" -ForegroundColor Yellow
            return
        }

        $navFile = Get-ChildItem -Path $navPath -Filter 'nav.xhtml' -ErrorAction SilentlyContinue | Select-Object -First 1

        if (-not $navFile) {
                Write-Host "⚠️  nav.xhtml未検出 in $navPath" -ForegroundColor Yellow
            return
        }

        $navContent = Get-Content -Path $navFile.FullName -Raw -Encoding UTF8
        if ($navContent -match 'page-list') {
            Write-Host "ℹ️  pageList既存" -ForegroundColor Green
            return
        }

        $pageListXml = "<nav epub:type=`"page-list`"><h2>ページリスト</h2><ol>`n"
        $pageLinks | ForEach-Object { $pageListXml += "        <li><a href=`"$($_.Href)`">$($_.Number)</a></li>`n" }
        $pageListXml += "    </ol></nav>"

        $updatedNav = $navContent -replace '(</body>)(?!.*</body>)', "$pageListXml`n`$1"
        [System.IO.File]::WriteAllText($navFile.FullName, $updatedNav, $Utf8NoBom)

        Remove-Item -Path $epubAsZip -Force -ErrorAction SilentlyContinue
        Compress-Archive -Path "$tempDir\*" -DestinationPath $epubAsZip -Force | Out-Null
        Remove-Item -Path $EpubPath -Force
        Rename-Item -Path $epubAsZip -NewName (Split-Path -Leaf $EpubPath) -Force -ErrorAction SilentlyContinue
        
        Write-Host "✅ pageList追加: $($pageLinks.Count)ポイント" -ForegroundColor Green
    } catch {
        Write-Host "❌ pageListエラー: $_" -ForegroundColor Red
    } finally {
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path $epubAsZip) { Remove-Item -Path $epubAsZip -Force -ErrorAction SilentlyContinue }
    }
}
