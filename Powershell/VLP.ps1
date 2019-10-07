# Get multi-monitor info from external program.
# | Out-Null is required to wait for the program to exit before continuing.
.\MultiMonitorTool.exe /scomma monitor_report.csv | Out-Null

$monitors = Import-Csv .\monitor_report.csv
$prim_monitor = ($monitors | Where-Object {$_.Primary -eq "Yes"})[0] # We can assume a single primary monitor exists.
$sec_monitors = ($monitors | Where-Object {$_.Primary -eq "No"})

if (!$sec_monitors) {
    [System.Windows.MessageBox]::Show('No secondary monitor detected!','Error','Ok','Error') | Out-Null
    return
}
if ($sec_monitors.Count -gt 1) {
    $sec_mon_index = -1
    Write-Host 'More than one secondary monitor detected: please choose one.'
    while ($sec_mon_index -lt 0 -or $sec_mon_index -ge $sec_monitors.Count) {
        Write-Host 'PRIMARY:'
        Write-Host "$($prim_monitor.Adapter) ($($prim_monitor.Resolution))"
        Write-Host 'SECONDARY:'
        Write-Host (($sec_monitors | % {$i = 0}{[string]$i + ") " + $_.Adapter + " (" + $_.Resolution + ")"; $i++}) | Out-String)
        $sec_mon_index = [int](Read-Host -Prompt 'Choose a secondary monitor')
    }
} else {
    $sec_mon_index = 0
}
$sec_mon_topleft_coord = $sec_monitors[$sec_mon_index].'Left-Top'.Split(',')

# The video will be positioned in the secondary monitor.
$video_x = ([int] $sec_mon_topleft_coord[0]) + 1
$video_y = ([int] $sec_mon_topleft_coord[1]) + 1

# Choose the VLC path from  a list of available paths.
$vlc_64 = 'C:\Program Files\VideoLAN\VLC\vlc.exe'
$vlc_32 = 'C:\Program Files (x86)\VideoLAN\VLC\vlc.exe'
$vlc_custom = 'C:\CUSTOM\PATH'
foreach ($path in @($vlc_64, $vlc_32, $vlc_custom)) {
    if (Test-Path $path) {
        $vlc_path = $path
        break
    }
}
Write-Host $vlc_path

# Launch VLC with the right parameters.
& $vlc_path --quiet --disable-screensaver --no-random --no-loop --no-repeat --no-playlist-autostart --play-and-stop --no-video-title-show --no-embedded-video --fullscreen --no-qt-fs-controller --video-x=$video_x --video-y=$video_y