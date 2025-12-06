Add-Type -Path "C:\Program Files\AI\AIVoice\AIVoiceEditor\AI.Talk.Editor.Api.dll"

#  powershell.exe -File AITalk.ps1 "読み上げ文字" .\output.wav

$ttsControl = [AI.Talk.Editor.Api.TtsControl]::new()
$hostName = $ttsControl.GetAvailableHostNames()

if ($hostName.Length -eq 0)
{
    Exit 1
}

$ttsControl.Initialize($hostName[0])

if ($ttsControl.Status -eq [AI.Talk.Editor.Api.HostStatus]::NotRunning)
{
    $ttsControl.StartHost()
}

function Speak($msg, $outputFile)
{

try {

    if ($ttsControl.Status -eq [AI.Talk.Editor.Api.HostStatus]::NotConnected)
    {
        Write-Host "Connecting to host..."
        $ttsControl.Connect()
    }
    Write-Host $ttsControl.Status
    $ttsControl.Text = $msg
    #$ttsControl.Play()
    Write-Host $msg
    Write-Host $outputFile
    $ttsControl.SaveAudioToFile($outputFile)

} catch {
    Write-Host $_.Exception.Message
    Exit 1
}

$ttsControl.Disconnect()

}
Write-Host $args.Count
Speak $args[0] $args[1]