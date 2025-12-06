<#
.SYNOPSIS
ディレクトリを監視し、WAVファイルを指定のでディレクトリに移動する

.DESCRIPTION
ディレクトリを監視し、WAVファイルを指定のでディレクトリに移動する

.EXAMPLE
PngWatcher.ps1 -dstDir "C:\Voice\WAV"

.PARAMETER dstDir
移動先ディレクトリ

#>
param(
    [string]
    $dstDir=""
)
Write-Host $dstDir
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = "W:\" # 監視するディレクトリを指定
$watcher.Filter = "*.wav"  # 監視対象のファイル名フィルタ
$watcher.IncludeSubdirectories = $false  # サブフォルダも監視しない
$watcher.EnableRaisingEvents = $true  # 監視を有効にする

# イベント時の処理
$action = {
    $path = $Event.SourceEventArgs.FullPath
    $change = $Event.SourceEventArgs.ChangeType
    $dst = $Event.MessageData
    Write-Host "$(Get-Date) – $change – $path -> $dst"
    # ファイルの移動
    Move-Item -LiteralPath $path -Destination $dst
}


Register-ObjectEvent $watcher Created -Action $action -MessageData $dstDir # ファイルの作成を監視する場合
# Register-ObjectEvent $watcher Changed -Action $action # ファイルの変更も監視する場合
# Register-ObjectEvent $watcher Deleted -Action $action # ファイルの削除も監視する場合
# Register-ObjectEvent $watcher Renamed -Action $action # 名前の変更も監視する場合

# スクリプトを終了させないようループ
while ($true) { Start-Sleep -Seconds 10 }