#Required to load the XAML form and create the PowerShell Variables

function qry-database {

	Param(
		# Database name
		[Parameter(Position = 0, Mandatory = $true)]
		[System.String]
		$dbase,
		# Query to database
		[Parameter(Position = 1, Mandatory = $true)]
		[System.String]
		$qry)
		
	# this holds the results
	$dbase_return = @()
		
	#$dbase = "C:\Users\ac00418\Documents\CBM_repo\model_data\maintained_models.mdb"
	$OpenStatic = 3
	$LockOptimistic = 3
	
	# create connection to database
	$conn = New-Object -ComObject ADODB.Connection
	# create recordset to hold return values
	$rs = New-Object -ComObject ADODB.Recordset
	
	# open connection
	$conn.Open("Provider = Microsoft.Jet.OLEDB.4.0;Data Source=$dbase")
	
	# query
	$rs.Open($qry, $conn, $OpenStatic, $LockOptimistic)
	
	# read from recordset
	while (!$rs.EOF) {
		$model_info = New-Object PSObject
		foreach ($field in $rs.Fields) {
			$model_info | Add-Member -MemberType NoteProperty -Name $($field.Name) -Value $field.Value
		}
		$rs.MoveNext()
		$dbase_return += $model_info
	}
	
	$rs.Close()
	$conn.Close()
	
	return $dbase_return
}

#$dbase = "C:\Users\ac00418\Documents\CBM_repo\model_data\maintained_models.mdb"
$dbase = "C:\Users\ac00418\Documents\CBM_repo\model_data\NetworkModels.mdb"
#$qry = "SELECT * FROM Sgn_network_models_OLD WHERE Sgn_network_models_OLD.NAME = 'DUNDEE' "
$qry = "Select NAME from NetworkModels"
#$qry = "SELECT * FROM NetworkModels WHERE NetworkModels.NAME = 'DUNDEE' "

#.\loadDialog.ps1 -XamlPath 'CBMForm.xaml'
#.\loadDialog.ps1 -XamlPath 'titleForm.xaml'
.\loadDialog.ps1 -XamlPath 'MainForm.xaml'

#$ID = qry-database $dbase $qry
#write-host $ID 

#EVENT Handler
$bt_CBM.add_Click({ $logo_TITLE.Content = .\other_script\callTask.ps1 })
$bt_VERIFY.add_Click({ $logo_TITLE.Content = "OPTION 2" })
$bt_VIEW.add_Click({ $logo_TITLE.Content = "OPTION 3" })
#$bt_VIEW.add_Click({ $tx_dets.Text = "ID is $($ID.ID)"})


#Launch the window
$xamGUI.ShowDialog() | out-null
