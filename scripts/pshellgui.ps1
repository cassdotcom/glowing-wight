###########################################################
# .FILE		: LOADDIALOG.PS1
# .AUTHOR  	: A. Cassidy
# .DATE    	: 2015-05-21
# .EDIT    	: 
# .FILE_ID	: PSCBM004
# .COMMENT 	: CBM GUI Event handler
# .INPUT		: 
# .OUTPUT	:
#			  	
#           
# .VERSION : 0.1
###########################################################
###########################################################
# .CHANGELOG
# 
#
#
###########################################################
# .INSTRUCTIONS FOR USE
#
#
#
###########################################################
# .CONTENTS
# 
#
#
###########################################################


Process { 

	$dbase = "C:\Users\ac00418\Documents\CBM_repo\model_data\NetworkModels.mdb"
	$qry = "Select NAME from NetworkModels"
	
	start-sleep 3
	
	# Load aliases
	$alias_file = gc "C:\Users\ac00418\Documents\gui\sandbox\settings\set-cbm-alias.txt"
	
	foreach ( $al in $alias_file ) { set-alias ($al.split(","))[0] ($al.split(","))[1]}
	
	#Required to load the XAML form and create the PowerShell Variables
	.\loadDialog.ps1 -XamlPath 'MainForm.xaml'
	
	# Print title
	$timedate = Get-Date -UFormat "%A %e %B %Y, %R"
	$tx_dets.AppendText("WELCOME TO THE NETWORK PLANNING CBM CREATION TOOL")
	$tx_dets.AppendText("`r`n$($timedate)")

	#EVENT Handler
	$bt_CBM.add_Click({ $rOK = .\create-cbm\button-cbm.ps1 })
	$bt_VERIFY.add_Click({ $rOK = .\create-cbm\button-verify.ps1 $tx_dets })
	$bt_VIEW.add_Click({ $rOK = .\create-cbm\button-view.ps1 $tx_dets })
	$bt_EXIT.add_Click({ button_exit $tx_dets })

	#Launch the window
	$xamGUI.ShowDialog() | out-null
}



Begin {

function qry-database {

	Param (
		# Database name
		[Parameter(Position = 0, Mandatory = $true)]
		[System.String]
		$dbase,
		# Query to database
		[Parameter(Position = 1, Mandatory = $true)]
		[System.String]
		$qry
	)
		
	# this holds the results
	$dbase_return = @()

	# Generic variables
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
	while ( !$rs.EOF ) {
		$model_info = New-Object PSObject
		foreach ($field in $rs.Fields) {
			$model_info | Add-Member -MemberType NoteProperty -Name $($field.Name) -Value $field.Value
		}
		$rs.MoveNext()
		$dbase_return += $model_info
	}

	# Close the connection 
	$rs.Close()
	$conn.Close()
	
	return $dbase_return
}
	
	
	function button_exit {
	
		Param (
			[System.Windows.Controls.RichTextBox]
			$tx_dets
		)
		
		$box_check = New-Object System.Windows.Forms.Form
		$box_check.width = 500
		$box_check.height = 150
		$box_check.startposition = [System.Windows.Forms.FormStartPosition]::CenterScreen
		
		$box_label = New-Object System.Windows.Forms.Label
		$box_label.Left = 25
		$box_label.Top = 15
		$box_label.Text = "Exit CBM Tool?"
		
		$bt_no = New-Object System.Windows.Forms.Button
		$bt_no.Left = 30
		$bt_no.Top = 90
		$bt_no.Width = 100
		$bt_no.Text = "NO"
		
		$box_check.Controls.Add($box_label)
		$box_check.Controls.Add($bt_no)
		
		$box_check.ShowDialog()		
	}
	
}


End {

$tx_dets.AppendText("END")


}
