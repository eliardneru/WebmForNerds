$file_location = read-host "enter file location "
cd $file_location
#$file_name = read-host "enter file name: "
$desired_size = read-host "enter desired file size "
$size_format = "M"
$file_list = @(Get-ChildItem -Path "$($file_location)\*.mp4")
$file_count = $file_list.Count

foreach($current_item in $file_list){
    Write-Host $current_item
    $video_length = ffprobe.exe -i $current_item -show_entries format=duration -v quiet -of csv="p=0"
    $bitrate = ($desired_size/$video_length)*8
    #$bitrate = [math]::Round($bitrate,1)
    $bitrate_m = "$($bitrate)$($size_format)"
    $random_name = Get-Random -Maximum 99999999 -Minimum 0
    '{0:d8}' -f $random_name
    ffmpeg.exe -i $current_item -c:v libvpx-vp9 -b:v $bitrate_m -c:a libopus output.webm
    rename-item -path "output.webm" -NewName "$($random_name).webm"   
}
