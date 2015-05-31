

Param (
	[System.String]
	$GUI_SETTINGS # SETTINGS FILE
)

# Try to import settings from file
Try {
	
	$msg = "1. IMPORT SETTINGS FILE"
	$temp_file = get-content $GUI_SETTINGS
	
} Catch {
	
	$this_err = $_
	$error_name = "1. IMPORT SETTINGS FILE"
	$tx_dets.AppendText("`r1. IMPORT SETTINGS FILE -- ERROR")
	return $this_err, $error_name
}


Try {

	# Split the settings data into "NAME" and "VALUE"
	$TEMP_OBJECT = New-Object PSObject

	foreach ( $m in $temp_file ) {
		$TEMP_OBJECT | Add-Member -MemberType NoteProperty -Name $m.split(",")[0] -Value $m.split(",")[1]
}
	
	# Create user-specific values
	$TEMP_OBJECT | Add-Member -MemberType NoteProperty -Name USERPROFILE -Value $env:USERPROFILE
	$TEMP_OBJECT | Add-Member -MemberType NoteProperty -Name CBMUSER -Value $env:USERNAME
	
	# Send object back to run-space
	return $TEMP_OBJECT
	
} Catch {

	$this_err = $_
	$error_name = "2. SPLIT SETTINGS"
	$tx_dets.AppendText("`r2. SPLIT SETTINGS -- ERROR")
	return $this_err, $error_name
		
}

