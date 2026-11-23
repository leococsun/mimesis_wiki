Add-Type -AssemblyName System.Drawing

$width = 1600
$height = 1450
$bmp = New-Object System.Drawing.Bitmap $width, $height
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

# Background
$bgBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(10, 14, 23))
$g.FillRectangle($bgBrush, 0, 0, $width, $height)

# Draw subtle grid
$gridPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(22, 30, 46)), 1
for ($x = 0; $x -lt $width; $x += 40) {
    $g.DrawLine($gridPen, $x, 0, $x, $height)
}
for ($y = 0; $y -lt $height; $y += 40) {
    $g.DrawLine($gridPen, 0, $y, $width, $y)
}

# Fonts
$fontFamily = "Microsoft JhengHei"
$titleFont = [System.Drawing.Font]::new($fontFamily, [float]26, [System.Drawing.FontStyle]::Bold)
$subtitleFont = [System.Drawing.Font]::new("Consolas", [float]13, [System.Drawing.FontStyle]::Regular)
$stageHeaderFont = [System.Drawing.Font]::new($fontFamily, [float]16, [System.Drawing.FontStyle]::Bold)
$bodyBoldFont = [System.Drawing.Font]::new($fontFamily, [float]12, [System.Drawing.FontStyle]::Bold)
$bodyFont = [System.Drawing.Font]::new($fontFamily, [float]12, [System.Drawing.FontStyle]::Regular)
$codeFont = [System.Drawing.Font]::new("Consolas", [float]11, [System.Drawing.FontStyle]::Regular)

# Brushes
$whiteBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(248, 250, 252))
$grayBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(148, 163, 184))
$cyanBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(56, 189, 248))
$amberBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(251, 191, 36))
$greenBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(52, 211, 153))
$indigoBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(129, 140, 248))
$roseBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(251, 113, 133))

# Draw Top Header
$g.DrawString("《謎魅狩獵》Wiki 編輯與維護工作流程圖", $titleFont, $cyanBrush, 80, 45)
$g.DrawString("KARPATHY LLM WIKI // PERSISTENT COMPOUNDING KNOWLEDGE BASE PIPELINE", $subtitleFont, $grayBrush, 82, 92)

# Helper function to draw rounded rectangle
function Draw-Card {
    param(
        [int]$x, [int]$y, [int]$w, [int]$h,
        [System.Drawing.Color]$borderColor,
        [System.Drawing.Color]$bgColor,
        [string]$badgeText,
        [System.Drawing.Brush]$badgeBrush
    )
    $rect = New-Object System.Drawing.Rectangle $x, $y, $w, $h
    $cardBrush = New-Object System.Drawing.SolidBrush $bgColor
    $cardPen = New-Object System.Drawing.Pen $borderColor, 2
    
    # Simple rounded rect
    $radius = 12
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc($x, $y, $radius, $radius, 180, 90)
    $path.AddArc($x + $w - $radius, $y, $radius, $radius, 270, 90)
    $path.AddArc($x + $w - $radius, $y + $h - $radius, $radius, $radius, 0, 90)
    $path.AddArc($x, $y + $h - $radius, $radius, $radius, 90, 90)
    $path.CloseFigure()

    $g.FillPath($cardBrush, $path)
    $g.DrawPath($cardPen, $path)

    # Top indicator stripe
    $stripeBrush = New-Object System.Drawing.SolidBrush $borderColor
    $g.FillRectangle($stripeBrush, $x + 20, $y, $w - 40, 4)
    $stripeBrush.Dispose()

    # Draw Badge
    if ($badgeText) {
        $badgeBg = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(30, $borderColor.R, $borderColor.G, $borderColor.B))
        $badgePen = New-Object System.Drawing.Pen $borderColor, 1
        $g.FillRectangle($badgeBg, $x + $w - 180, $y + 14, 160, 26)
        $g.DrawRectangle($badgePen, $x + $w - 180, $y + 14, 160, 26)
        $sf = New-Object System.Drawing.StringFormat
        $sf.Alignment = [System.Drawing.StringAlignment]::Center
        $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
        $g.DrawString($badgeText, $codeFont, $badgeBrush, [System.Drawing.RectangleF]::new($x + $w - 180, $y + 14, 160, 26), $sf)
        $badgeBg.Dispose()
        $badgePen.Dispose()
        $sf.Dispose()
    }

    $cardBrush.Dispose()
    $cardPen.Dispose()
    $path.Dispose()
}

# Function to draw downward arrow
function Draw-Arrow {
    param([int]$x, [int]$startY, [int]$endY, [System.Drawing.Color]$color, [string]$label)
    $pen = New-Object System.Drawing.Pen $color, 3
    $pen.CustomEndCap = New-Object System.Drawing.Drawing2D.AdjustableArrowCap 6, 6
    $g.DrawLine($pen, $x, $startY, $x, $endY)
    
    if ($label) {
        $lblBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(10, 14, 23))
        $lblTextBrush = New-Object System.Drawing.SolidBrush $color
        $lblWidth = 180
        $lblHeight = 22
        $g.FillRectangle($lblBrush, $x - 90, ($startY + $endY)/2 - 11, $lblWidth, $lblHeight)
        $borderPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(40, $color.R, $color.G, $color.B)), 1
        $g.DrawRectangle($borderPen, $x - 90, ($startY + $endY)/2 - 11, $lblWidth, $lblHeight)
        $sf = New-Object System.Drawing.StringFormat
        $sf.Alignment = [System.Drawing.StringAlignment]::Center
        $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
        $g.DrawString($label, $codeFont, $lblTextBrush, [System.Drawing.RectangleF]::new($x - 90, ($startY + $endY)/2 - 11, $lblWidth, $lblHeight), $sf)
        $lblBrush.Dispose()
        $lblTextBrush.Dispose()
        $borderPen.Dispose()
        $sf.Dispose()
    }
    $pen.Dispose()
}

# CARD 1: 階段一 原始資料層
$c1Y = 140
$c1H = 150
Draw-Card 80 $c1Y 1440 $c1H ([System.Drawing.Color]::FromArgb(56, 189, 248)) ([System.Drawing.Color]::FromArgb(17, 24, 39)) "RAW SOURCES LAYER" $cyanBrush
$g.DrawString("【階段一】原始資料輸入 (Raw Intake)", $stageHeaderFont, $cyanBrush, 110, $c1Y + 20)
$g.DrawString("• 角色分工：玩家決策提供（Human Curates）", $bodyBoldFont, $whiteBrush, 110, $c1Y + 58)
$g.DrawString("• 輸入途徑：玩家將實測筆記、改版手冊 (0.3.0) 放入 raw/ 目錄（或對話直接貼上）。", $bodyFont, $grayBrush, 110, $c1Y + 84)
$g.DrawString("• 核心原則：此層為不可變唯讀真理來源（Immutable Ground Truth），AI 僅能讀取、絕不修改。", $bodyFont, $grayBrush, 110, $c1Y + 108)

# Arrow 1 -> 2
Draw-Arrow 800 ($c1Y + $c1H) ($c1Y + $c1H + 50) ([System.Drawing.Color]::FromArgb(56, 189, 248)) "原始文字讀入"

# CARD 2: 階段二 AI 提煉與對齊
$c2Y = $c1Y + $c1H + 50
$c2H = 210
Draw-Card 80 $c2Y 1440 $c2H ([System.Drawing.Color]::FromArgb(251, 191, 36)) ([System.Drawing.Color]::FromArgb(28, 25, 23)) "HUMAN-IN-THE-LOOP" $amberBrush
$g.DrawString("【階段二】AI 提煉與人機對齊 (Extraction & Alignment)", $stageHeaderFont, $amberBrush, 110, $c2Y + 20)
$g.DrawString("• 角色分工：LLM 提煉剖析 + 玩家把關核准", $bodyBoldFont, $whiteBrush, 110, $c2Y + 58)
$g.DrawString("• 三大戰術維度解構：", $bodyFont, $whiteBrush, 110, $c2Y + 84)
$g.DrawString("   [1] 攻擊方式 (前搖預兆、判定範圍、致命招式)    [2] 避戰方式 (感官機制、安撫手段、脫離 SOP)    [3] 反擊方式 (弱點硬直、推薦裝備、團隊擊殺)", $bodyFont, $grayBrush, 130, $c2Y + 110)
$g.DrawString("• 關鍵人機迴路 (Verification Loop)：", $bodyBoldFont, $amberBrush, 110, $c2Y + 140)
$g.DrawString("   LLM 整理提煉重點向玩家請示確認。若發現機制矛盾或玩家修正（如：鏡像複製武器 vs 搶奪手中武器），即刻回滾校正！", $bodyFont, $grayBrush, 130, $c2Y + 166)

# Arrow 2 -> 3
Draw-Arrow 800 ($c2Y + $c2H) ($c2Y + $c2H + 50) ([System.Drawing.Color]::FromArgb(251, 191, 36)) "確認無誤 / 正式寫入"

# CARD 3: 階段三 知識庫沉澱
$c3Y = $c2Y + $c2H + 50
$c3H = 220
Draw-Card 80 $c3Y 1440 $c3H ([System.Drawing.Color]::FromArgb(52, 211, 153)) ([System.Drawing.Color]::FromArgb(16, 36, 30)) "WIKI COMPOUNDING" $greenBrush
$g.DrawString("【階段三】持久化知識庫結構化沉澱 (Wiki Compounding)", $stageHeaderFont, $greenBrush, 110, $c3Y + 20)
$g.DrawString("• 角色分工：LLM 全自動維護（LLM Maintains）", $bodyBoldFont, $whiteBrush, 110, $c3Y + 58)
$g.DrawString("• 三大知識分流結構（相互保持 [[WikiLink]] 雙向引用）：", $bodyFont, $whiteBrush, 110, $c3Y + 84)
$g.DrawString("   • 實體怪物檔案 (wiki/entities/)  : 10 隻 Mimesis 怪物完整戰術剖析 (Mimesis, Bombesis, Sentryper...)", $bodyFont, $grayBrush, 130, $c3Y + 110)
$g.DrawString("   • 通用核心機制 (wiki/mechanics/) : 聲學感官雙極、視線凝視制約 (泣天使)、社交欺詐與怪物惡意連鎖", $bodyFont, $grayBrush, 130, $c3Y + 134)
$g.DrawString("   • 戰術裝備手冊 (wiki/tactics/)   : 全怪物避戰逃脫優先級、散彈槍與球棒彈藥經濟評析", $bodyFont, $grayBrush, 130, $c3Y + 158)
$g.DrawString("• 核心價值：知識編譯一次後永久累積沉澱，越用越豐富，無須每一次提問重新檢索。", $bodyFont, $greenBrush, 110, $c3Y + 184)

# Arrow 3 -> 4
Draw-Arrow 800 ($c3Y + $c3H) ($c3Y + $c3H + 50) ([System.Drawing.Color]::FromArgb(52, 211, 153)) "雙向連結與記錄"

# CARD 4: 階段四 簿記維護
$c4Y = $c3Y + $c3H + 50
$c4H = 150
Draw-Card 80 $c4Y 1440 $c4H ([System.Drawing.Color]::FromArgb(129, 140, 248)) ([System.Drawing.Color]::FromArgb(25, 26, 48)) "CATALOG & AUDIT" $indigoBrush
$g.DrawString("【階段四】目錄索引與時序日誌維護 (Bookkeeping & Logging)", $stageHeaderFont, $indigoBrush, 110, $c4Y + 20)
$g.DrawString("• 角色分工：LLM 簿記與一致性維護", $bodyBoldFont, $whiteBrush, 110, $c4Y + 58)
$g.DrawString("• 總目錄更新 (wiki/index.md) : 即時同步全實體威脅矩陣、危險等級評估與雙向頁面跳轉導航。", $bodyFont, $grayBrush, 110, $c4Y + 84)
$g.DrawString("• 時序日誌 (wiki/log.md)     : 每次 Ingest、修正與編譯追加標準記錄 (格式：## [YYYY-MM-DD] Action | Description)。", $bodyFont, $grayBrush, 110, $c4Y + 108)

# Arrow 4 -> 5
Draw-Arrow 800 ($c4Y + $c4H) ($c4Y + $c4H + 50) ([System.Drawing.Color]::FromArgb(129, 140, 248)) "編譯與衍生產出"

# CARD 5: 階段五 衍生產品交付
$c5Y = $c4Y + $c4H + 50
$c5H = 160
Draw-Card 80 $c5Y 1440 $c5H ([System.Drawing.Color]::FromArgb(251, 113, 133)) ([System.Drawing.Color]::FromArgb(38, 19, 29)) "PRESENTATION & LINT" $roseBrush
$g.DrawString("【階段五】產品編譯與交付 (Product Compilation & Quality Control)", $stageHeaderFont, $roseBrush, 110, $c5Y + 20)
$g.DrawString("• 互動教學簡報 (presentations/index.html) : 單一獨立 HTML (Single-file)，免安裝環境，雙擊瀏覽器直接離線播放。", $bodyBoldFont, $whiteBrush, 110, $c5Y + 58)
$g.DrawString("   - 內建 15 頁戰術 HUD 終端風格、鍵盤方向鍵切頁、全螢幕簡報 (F) 與即時速查索引抽屜。", $bodyFont, $grayBrush, 130, $c5Y + 84)
$g.DrawString("• 知識庫健康檢查 (Lint Workflow)         : 自動檢測斷鏈孤島、情報矛盾與戰術空白，保證知識庫長久健康。", $bodyFont, $grayBrush, 110, $c5Y + 112)

# Save to PNG
$outputPath = "D:\test\wiki_workflow.png"
$bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
Copy-Item $outputPath "D:\test\workflow.png" -Force

# Cleanup
$g.Dispose()
$bmp.Dispose()
$bgBrush.Dispose()
$gridPen.Dispose()
$titleFont.Dispose()
$subtitleFont.Dispose()
$stageHeaderFont.Dispose()
$bodyBoldFont.Dispose()
$bodyFont.Dispose()
$codeFont.Dispose()
$whiteBrush.Dispose()
$grayBrush.Dispose()
$cyanBrush.Dispose()
$amberBrush.Dispose()
$greenBrush.Dispose()
$indigoBrush.Dispose()
$roseBrush.Dispose()

Write-Host "SUCCESS: Generated flowchart PNG at $outputPath"
