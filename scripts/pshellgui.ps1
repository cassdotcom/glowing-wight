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

	# THE S:\ DRIVE WILL HAVE A REPOSITORY FOR THESE SETTINGS!!!!!!!!
	$BIG_DATA = New-Object PSObject 
	$BIG_DATA | Add-Member -MemberType NoteProperty -Name GUI_SETTINGS_PATH -Value "C:\Users\ac00418\Documents\gui\sandbox\settings"
	$BIG_DATA | Add-Member -MemberType NoteProperty -Name CBM_SETTINGS_PATH -Value "C:\Users\ac00418\Documents\CBM_repo\settings"
	$BIG_DATA | Add-Member -MemberType NoteProperty -Name XAML_PATH -Value "C:\Users\ac00418\Documents\gui\sandbox"
	
	# Load aliases
	$alias_file = gc "$($BIG_DATA.GUI_SETTINGS_PATH)\set-cbm-alias.txt"
	start-sleep 5 
	foreach ( $al in $alias_file ) { set-alias ($al.split(","))[0] ($al.split(","))[1] }
	
	#Required to load the XAML form and create the PowerShell Variables
	load_XAML -XamlPath "$($BIG_DATA.XAML_PATH)\MainForm.xaml"
	
	# Print title
	$timedate = Get-Date -UFormat "%A %e %B %Y, %R"
	$tx_dets.AppendText("WELCOME TO THE NETWORK PLANNING CBM CREATION TOOL")
	$tx_dets.AppendText("`r`n$($timedate)")

	#EVENT Handler
	$bt_CBM.add_Click({ $rOK = button-cbm })
	$bt_VERIFY.add_Click({ $rOK = button-verify })
	$bt_VIEW.add_Click({ $rOK = button-view })
	$bt_EXIT.add_Click({ exit })

	#Launch the window
	$xamGUI.ShowDialog() | out-null
}



Begin {
	
	function button-exit {
	
		$box_check = New-Object System.Windows.Forms.Form
		$box_check.width = 300
		$box_check.height = 150
		$box_check.startposition = [System.Windows.Forms.FormStartPosition]::CenterScreen
		
		$box_label = New-Object System.Windows.Forms.Label
		$box_label.Left = 25
		$box_label.Top = 15
		$box_label.Text = "Exit CBM Tool?"
		
		$bt_no = New-Object System.Windows.Forms.Button
		$bt_no.Left = 30
		$bt_no.Top = 50
		$bt_no.Width = 100
		$bt_no.Text = "NO"
		
		$bt_yes = New-Object System.Windows.Forms.Button
		$bt_yes.Left = 160
		$bt_yes.Top = 50
		$bt_yes.Width = 100
		$bt_yes.Text = "YES"
		
		$box_check.Controls.Add($box_label)
		$box_check.Controls.Add($bt_no)
		$box_check.Controls.Add($bt_yes)
		
		$bt_no.Add_Click({ break })
		$bt_yes.Add_Click({  })
		
		$box_check.ShowDialog()		
	}
	
}


End {

$tx_dets.AppendText("END")


}
