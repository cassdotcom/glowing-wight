# CBM VIEW

Param(
	[System.Windows.Controls.RichTextBox]
	$tx_dets
)

$tx_dets.text
start-sleep 1
$tx_dets.Appendtext("DONE")


<# Param (
	[System.Windows.Controls.RichTextBox]
	$tx_dets
)

#$rtb_ss = $tx_dets.Document.Contentstart
#$rtb_tt = $tx_dets.Document.Contentend
#$rtb_ss.text = " "
#$tx_dets.Appendtext($rtb_ss)
$tx_dets.Appendtext("`r`n`r`nIN VERIFY")
$tx_dets.ScrollToEnd()
#$tx_dets.Backcolor = "Blue"

$rOK = "FINE VERIFY"

return $rOK #>
