#Clear-host
cd $PSScriptRoot

Add-type -AssemblyName System.Windows.Forms

$FormObject = [System.Windows.Forms.form]
$labelobject = [System.Windows.Forms.label]

$main=New-Object $FormObject
$main.ClientSize='600,400'
$main.Text='WebmForNerds'
$main.Backcolor="#ffffff"
$main.StartPosition = 'CenterScreen'
$loc = Get-Location
$MainIcon = New-Object System.Drawing.Icon ("$($loc)\Images\you.ico")
$main.Icon = $MainIcon
$fileloc = New-object System.Windows.Forms.Textbox
$fileloc.Location = New-Object System.Drawing.Point(20,50)
$fileloc.size = New-Object System.Drawing.Size(250,20)
$main.Controls.Add($fileloc)
$fileloclb = New-Object System.Windows.Forms.Label
$fileloclb.Location = New-Object System.Drawing.Point(20,30)
$fileloclb.Size = New-Object System.Drawing.Size(200,20)
$fileloclb.Text = 'Folder location'
$StatusButton = New-Object System.Windows.Forms.Label
$StatusButton.Location = New-Object System.Drawing.Point(20,320)
$StatusButton.Size = New-Object system.drawing.size(150,15)
$StatusButton.Text = 'Stautus: idle'
$main.controls.Add($StatusButton)
$main.Controls.Add($fileloclb)
$ConvertButton = New-Object System.Windows.Forms.Button
$ConvertButton.Location = New-Object System.Drawing.Point(20,285)
$ConvertButton.Size = New-Object System.Drawing.Size(80,30)
$ConvertButton.Text = 'Convert'
$ProgressBar = New-Object System.Windows.Forms.ProgressBar
$ProgressBar.Location = New-Object System.Drawing.point(20,340)
$ProgressBar.Size = New-Object System.Drawing.size(560,40)
$main.controls.Add($ProgressBar)
$OpenInButton = New-Object System.Windows.Forms.Button
$OpenInButton.Location = New-Object System.Drawing.Point(280,48)
$OpenInButton.Size = New-Object System.Drawing.Size(25,24)
$ObImage = [System.Drawing.Image]::FromFile("$($PSScriptRoot)\Images\Folder.ico")
$OpenInButton.Image = $ObImage
$main.Controls.Add($OpenInButton)

Function Open-Folder($initialDirectory="")

{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}



#$ConvertButton.DialogResult = [System.Windows.Forms.DialogResult]::None
#$main.AcceptButton = $ConvertButton
$main.Controls.Add($ConvertButton)
$OpenInButton.Add_click({
    $FolderLocation = Open-Folder
    $fileLoc.text = "$FolderLocation"
   })
$ConvertButton.Add_Click({
    $Folder_location = $fileloc.Text
$ffmpeg = "$($PSScriptRoot)\ffmpeg.exe"
$ffprobe = "$($PSScriptRoot)\ffprobe.exe"
cd $folder_location
#$file_name = read-host "enter file name: "
$desired_size = '3.8'
#$desired_size = read-host "enter desired file size "
$size_format = "M"
$file_list = @(Get-ChildItem -Path $Folder_location -filter *.mp4)
$file_count = $file_list.Count
$ProgressBar.Maximum = $file_count
$ProgressBar.step = 1;
$ProgressBar.Value = 1;
    $ConvertButton.Enabled = $false
    $StatusButton.Text = 'Stautus: Calculating...'
    New-Item -path $Folder_location -Name Output -ItemType "directory"
    foreach($current_item in $file_list){
        $video_length = & "$ffprobe" -i $current_item -show_entries format=duration -v quiet -of csv="p=0"
        $frame_count = & "$ffprobe" v error -select_streams v:0 -count_frames -show_entries stream=nb_read_frames -print_format csv $current_item

        $bitrate = ($desired_size/$video_length)*8
        $bitrate = [math]::Round($bitrate,1)
        $bitrate_m = "$($bitrate)$($size_format)"

        $random_name = Get-Random -Maximum 999999999 -Minimum 111111111
        ([string]$random_name).PadLeft(12,'0')
        end $false
        $StatusButton.text = 'Status: working...'
        & "$ffmpeg" -i $current_item -c:v libvpx-vp9 -b:v $bitrate_m -c:a libopus output.webm
  
        rename-item -path output.webm -NewName "$($random_name).webm"
        $ProgressBar.Value++ 
        }
          $statusbutton.text = 'Status: done'
          $ConvertButton.Enabled = $true
})


$result = $main.ShowDialog()



