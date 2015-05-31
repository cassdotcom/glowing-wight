Param (
	[System.String]
	$GUI_SETTINGS_PATH # SETTINGS FILE
)

$xl = New-Object -comobject Excel.Application
$xl.visible = $true
$xl.DisplayAlerts = $False
$wb = $xl.Workbooks.open($GUI_SETTINGS_PATH)
