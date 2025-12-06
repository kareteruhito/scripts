PixabaySearch.ps1 cat `
  | Get-Random `
  | ForEach-Object {
      # タイムスタンプ生成（例: 20251203-203455）
      $timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")

      # ファイル名を設定
      $name = "$timestamp.jpg"

      Invoke-WebRequest -Uri $_ -OutFile $name
      Write-Host "Downloaded: $name"
    }