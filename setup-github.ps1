# ============================================================
# ペタペタペンギン団BOT - GitHub セットアップスクリプト
# 実行方法: PowerShellで このファイルがあるフォルダを開いて
#   .\setup-github.ps1
# ============================================================

# ---- 設定 ----
$REPO_NAME   = "petapeta-bot"
$REPO_DESC   = "ペタペタペンギン団 自動周回BOT"
$REPO_PRIVATE = $true   # $false にすると Public

# GitHub Personal Access Token を入力
$TOKEN = Read-Host "GitHub Personal Access Token を入力してください (repo権限が必要)"
$USERNAME = Read-Host "GitHubユーザー名を入力してください"

$headers = @{
    "Authorization" = "token $TOKEN"
    "Accept"        = "application/vnd.github.v3+json"
}

# ---- 1. リポジトリ作成 ----
Write-Host "`n[1/3] GitHubリポジトリを作成中..." -ForegroundColor Cyan
$repoBody = @{
    name        = $REPO_NAME
    description = $REPO_DESC
    private     = $REPO_PRIVATE
    auto_init   = $false
} | ConvertTo-Json

$repoResult = Invoke-RestMethod -Uri "https://api.github.com/user/repos" `
    -Method POST -Headers $headers -Body $repoBody -ContentType "application/json"

$REPO_URL = $repoResult.clone_url
Write-Host "  作成完了: $REPO_URL" -ForegroundColor Green

# ---- 2. リモート登録 & Push ----
Write-Host "`n[2/3] ローカルリポジトリをpush中..." -ForegroundColor Cyan

# トークン付きURLでpush（認証のため）
$PUSH_URL = "https://${TOKEN}@github.com/${USERNAME}/${REPO_NAME}.git"
git remote add origin $PUSH_URL 2>$null
if ($LASTEXITCODE -ne 0) {
    git remote set-url origin $PUSH_URL
}
git push -u origin main
Write-Host "  Push完了" -ForegroundColor Green

# ---- 3. Issue作成 ----
Write-Host "`n[3/3] Issueを作成中..." -ForegroundColor Cyan

$issuesDir = "$PSScriptRoot\docs\issues"
$issues = @(
    @{
        file   = "issue-1-env-setup.md"
        title  = "[Issue #1] 開発環境 & ADB基盤構築"
        labels = @("setup")
    },
    @{
        file   = "issue-2-adb-utils.md"
        title  = "[Issue #2] スクリーン取得 & 入力ユーティリティ (DeviceController)"
        labels = @("core")
    },
    @{
        file   = "issue-3-screen-detector.md"
        title  = "[Issue #3] ゲーム画面状態検出 (ScreenAnalyzer)"
        labels = @("core")
    },
    @{
        file   = "issue-4-field-placement.md"
        title  = "[Issue #4] フィールド配置ロジック (FieldPlacer)"
        labels = @("feature")
    },
    @{
        file   = "issue-5-dungeon-placement.md"
        title  = "[Issue #5] ダンジョン配置ロジック (DungeonPlacer)"
        labels = @("feature")
    },
    @{
        file   = "issue-6-summon-logic.md"
        title  = "[Issue #6] 召喚ロジック (SummonAction)"
        labels = @("feature")
    },
    @{
        file   = "issue-7-enhance-logic.md"
        title  = "[Issue #7] 強化ロジック (EnhanceAction)"
        labels = @("feature")
    },
    @{
        file   = "issue-8-main-loop.md"
        title  = "[Issue #8] メインループ & 周回カウンター (AutoRunner)"
        labels = @("feature")
    }
)

$API_URL = "https://api.github.com/repos/${USERNAME}/${REPO_NAME}/issues"

foreach ($issue in $issues) {
    $bodyText = Get-Content "$issuesDir\$($issue.file)" -Raw -Encoding UTF8
    $issueBody = @{
        title  = $issue.title
        body   = $bodyText
        labels = $issue.labels
    } | ConvertTo-Json -Depth 3

    $result = Invoke-RestMethod -Uri $API_URL `
        -Method POST -Headers $headers -Body $issueBody -ContentType "application/json; charset=utf-8"

    Write-Host "  Issue作成: #$($result.number) $($result.title)" -ForegroundColor Green
    Start-Sleep -Milliseconds 500  # API制限対策
}

# ---- 完了 ----
Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host "セットアップ完了！" -ForegroundColor Yellow
Write-Host "リポジトリ: https://github.com/${USERNAME}/${REPO_NAME}" -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Yellow
