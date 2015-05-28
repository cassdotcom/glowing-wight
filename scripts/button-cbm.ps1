# CBM BUTTON

$tx_dets.Appendtext("`r`nCBM: ")




.\create-cbm\create-cbm-TEMP.ps1 $true $true


<# # COPY ALL CBM FILES OVER TO USER DIRECTORY
$rundir = (Get-Item -Path ".\" -Verbose).FullName
Import-Alias -Path "settings\cbm-aliases.csv" #>
<# 

# GET-TIMESTAMP
$timestamp = .\create-cbm\Get-TimeStamp.ps1

# 


$tx_dets.Appendtext($timestamp) #>

$tx_dets.ScrollToEnd()

<# Param (
	[System.Windows.Controls.RichTextBox]
	$tx_dets
)


$tx_dets.Appendtext("`r`n`r`nIN CBM")
$tx_dets.ScrollToEnd()
$tx_dets.Background = "Blue"
$tx_dets.Foreground = "White" #>

$rOK = "FINE CBM"

return $rOK
