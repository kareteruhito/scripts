<#
.SYNOPSIS
Pixabayを画像検索

.DESCRIPTION
PixabayのAPIを使ってキーワードによる画像検索を行いURIの一覧を取得する。

.EXAMPLE
PixabaySearch.ps1 -Query "キーワード" -PerPage 50 -ImageType "photo"

#>
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Query,

    [int]$PerPage = 50,

    [string]$ImageType = "photo"   # photo / illustration / vector など
)

# API キー取得
$apiKey = $env:PIXABAY_KEY
if (-not $apiKey) {
    Write-Error "環境変数 PIXABAY_KEY が設定されていません。`n`$env:PIXABAY_KEY に API キーを設定してください。"
    exit 1
}

# クエリを URL エンコード
$encodedQuery = [System.Uri]::EscapeDataString($Query)

# API URL 作成
$url = "https://pixabay.com/api/?key=$apiKey&q=$encodedQuery&image_type=$ImageType&per_page=$PerPage"

try {
    # API 呼び出し
    $res = Invoke-RestMethod -Uri $url -Method Get
}
catch {
    Write-Error "Pixabay API の呼び出しに失敗しました: $_"
    exit 1
}

if (-not $res.hits -or $res.hits.Count -eq 0) {
    Write-Warning "ヒットがありませんでした。"
    exit 0
}

# largeImageURL を 1行ずつ出力（パイプライン前提）
foreach ($hit in $res.hits) {
    $hit.largeImageURL
}
