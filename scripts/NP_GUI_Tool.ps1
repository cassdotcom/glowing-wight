###########################################################
# .FILE		: NP_GUI_TOOL.PS1
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

	#----------------------------------------------------------
	# SETTINGS FILE
	#----------------------------------------------------------
	$GUI_SETTINGS = "C:\Users\ac00418\Documents\gui\sandbox\settings\cbm_pshell_settings.csv"
	$GUI_LOG_FILE = "C:\Users\ac00418\Documents\gui\sandbox\logs\"

	
	
	
	#----------------------------------------------------------
	# Create a structure to contain settings
	#----------------------------------------------------------
	$BIG_DATA = New-Object PSObject 	
	# Call script to import settings
	$BIG_DATA = .\scripts\import-cbm-settings.ps1 $GUI_SETTINGS
	# Now add settings file to structure
	$BIG_DATA | Add-Member -MemberType NoteProperty -Name GUI_SETTINGS_PATH -Value $GUI_SETTINGS
	
	
	
	
	#----------------------------------------------------------
	# LOAD ALIAS
	#----------------------------------------------------------
	$function_library = gc $BIG_DATA.FUNCTION_LIBRARY
	foreach ( $function in $function_library ) { 
		set-alias ($function.split(","))[0] ($function.split(","))[1] 
	}
	
	
	#----------------------------------------------------------
	# Required to load the XAML form and create the PowerShell Variables
	#----------------------------------------------------------
	load_XAML -XamlPath $BIG_DATA.XAML_FILE
	
	
	
	
	#----------------------------------------------------------
	# Get log file
	#----------------------------------------------------------
	$PSHELL_LOG_FILE = get_log_file $BIG_DATA.CBM_LOG
	
	
	
	
	#----------------------------------------------------------
	# Name settings file:
	#----------------------------------------------------------
	$tx_SETTINGS.Text = $BIG_DATA.GUI_SETTINGS_PATH
		
	
	
	
	#----------------------------------------------------------
	# Print header
	#----------------------------------------------------------	
	$timedate = get_timestamp -readable
	#$tx_dets.AppendText("WELCOME TO THE NETWORK PLANNING CBM CREATION TOOL")
	
	write_to_log_and_line "$($timedate)" $PSHELL_LOG_FILE
	write_to_log_and_line "USER: $($BIG_DATA.CBMUSER)" $PSHELL_LOG_FILE



	
	#----------------------------------------------------------
	# EVENT Handler
	#----------------------------------------------------------	
	$verify_path = "C:\Users\ac00418\Documents\gui\sandbox\scripts\button-verify.ps1"
	$allArgs = "C:\Users\ac00418\Documents\gui\sandbox\scripts\button-verify.ps1", "$tx_dets"
	$bt_CBM.add_Click({ $rOK = button-cbm })
	$bt_VERIFY.add_Click({ Start-Process powershell.exe -argumentlist "-file C:\Users\ac00418\Documents\gui\sandbox\scripts\button-verify.ps1", "$tx_dets" -windowstyle hidden})
	$bt_VIEW.add_Click({ click_verify })
	$bt_EXIT.add_Click({ exit })
	
	$bt_FOLDER.add_Click({ display-settings-file $BIG_DATA.GUI_SETTINGS_PATH })

	#Launch the window
	$xamGUI.ShowDialog() | out-null

	
}



Begin {

	function click_verify {
		[System.windows.forms.richtextbox]::Show("`r`rCLICK VERIFY")
	}

	function do_dot_waiting {
	
		Param(
			[System.Int32]
			$n
		)
		
		for ( $i = 0; $i -lt $n; $i++ ) {
			$tx_dets.AppendText(" .")
			start-sleep 1
		}
		
		$tx_dets.AppendText(" DONE")
	}

	function backgroundrunner {
		
		Param(
			[System.Object]
			$GUI_SETTINGS
		)
		
		$msg = " "		
		$tx_dets.AppendText("`r$msg")
		
		$msg = "IMPORT MODEL LIST"		
		$tx_dets.AppendText("`r$msg")
		
		$fy1_models = import-csv $GUI_SETTINGS.MODEL_LIST
		$n_of_models = $fy1_models.length
		
		$n = 10
		
		for ( $i = 0; $i -lt $n; $i++ ) {
			$tx_dets.AppendText(" .")
			start-sleep 1
		}
		
		$tx_dets.AppendText(" DONE")
			
	}
	
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
