
Process {


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
	# Get log file
	#----------------------------------------------------------
	$PSHELL_LOG_FILE = get_log_file $BIG_DATA.CBM_LOG

	
	#----------------------------------------------------------
	# Name settings file:
	#----------------------------------------------------------
	$tb_SETTINGS.AppendText("SETTINGS FILE: $($BIG_DATA.GUI_SETTINGS_PATH)")
	
	
	#----------------------------------------------------------
	# Print header
	#----------------------------------------------------------	
	$timedate = get_timestamp -readable
	#$tx_dets.AppendText("WELCOME TO THE NETWORK PLANNING CBM CREATION TOOL")
	
	write_to_log_and_line $timedate $PSHELL_LOG_FILE
	write_to_log_and_line "USER: $($BIG_DATA.CBMUSER)" $PSHELL_LOG_FILE


	# Show form
	$np_GUI.ShowDialog() | Out-Null


}


Begin {

	function bt_CBM_Clicked {

		
		$tb_MAIN.AppendText("`rLoading models")
		$model_data = .\scripts\bt_CBM-function.ps1
		$tb_MAIN.AppendText(" . . . . DONE")
		
	}
				
	function bt_VIEW_Clicked {

		$tb_MAIN.AppendText("`rview button clicked")
		#.\side-function.ps1
		
	}

	function bt_VERIFY_Clicked {

		$tb_MAIN.AppendText("`rverify button clicked")

	}

	function bt_EXIT_Clicked {

		

	}

	function make-button {
		
		Param ( 
			[System.String]
			$Name,
			[System.Int32]
			$Loc_Left,
			[System.Int32]
			$Loc_Top,
			[System.Int32]
			$Wide,
			[System.Int32]
			$Long,
			[System.Int32]
			$buttonText
		)
	}
		

	Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase,system.windows.forms
	Add-Type -AssemblyName System.Windows.Forms    
	Add-Type -AssemblyName System.Drawing

	# Build Form
	$np_GUI = New-Object System.Windows.Forms.Form
	$np_GUI.Text = "NETWORK PLANNING Model Tool"
	$np_GUI.Size = New-Object System.Drawing.Size(1050, 500)
	$Background_Image = [System.drawing.image]::FromFile("C:\Users\ac00418\Documents\gui\sandbox\sgn_brand_noname.png")
	$np_GUI.BackgroundImage = $Background_Image
	$np_GUI.BackgroundImageLayout = "Stretch"


	#----------------------------------------------------------
	# GUI: Buttons
	#----------------------------------------------------------
	# Add CBM Button
	$bt_CBM = New-Object System.Windows.Forms.Button
	$bt_CBM.Name = "bt_CBM"
	$bt_CBM.Location = New-Object System.Drawing.Size(11,73)
	$bt_CBM.Size = New-Object System.Drawing.Size(150,40)
	$bt_CBM.Text = "CBM"
	# Add to form
	$np_GUI.Controls.Add($bt_CBM)
	# Create event handler
	$bt_CBM.add_Click({  bt_CBM_Clicked })

	# Add view button
	$bt_VIEW = New-Object System.Windows.Forms.Button
	$bt_VIEW.Name = "bt_VIEW"
	$bt_VIEW.Location = New-Object System.Drawing.Size(11,131)
	$bt_VIEW.Size = New-Object System.Drawing.Size(150,40)
	$bt_VIEW.Text = "VIEW"
	# Add to form
	$np_GUI.Controls.Add($bt_VIEW)
	# Create event handler
	$bt_VIEW.add_Click({ bt_VIEW_Clicked })

	# Add verify button
	$bt_VERIFY = New-Object System.Windows.Forms.Button
	$bt_VERIFY.Name = "bt_VERIFY"
	$bt_VERIFY.Location = New-Object System.Drawing.Size(11,189)
	$bt_VERIFY.Size = New-Object System.Drawing.Size(150,40)
	$bt_VERIFY.Text = "VERIFY"
	# Add to form
	$np_GUI.Controls.Add($bt_VERIFY)
	# Create event handler
	$bt_VERIFY.add_Click({ bt_VERIFY_Clicked })

	# Add exit button
	$bt_EXIT = New-Object System.Windows.Forms.Button
	$bt_EXIT.Name = "bt_EXIT"
	$bt_EXIT.Location = New-Object System.Drawing.Size(11,333)
	$bt_EXIT.Size = New-Object System.Drawing.Size(150,40)
	$bt_EXIT.Text = "EXIT"
	$bt_EXIT.BackColor = "#FFDDAE4A"
	# Add to form
	$np_GUI.Controls.Add($bt_EXIT)
	# Create event handler
	$bt_EXIT.add_Click({ [environment]::exit(0) })



	#----------------------------------------------------------
	# GUI: Textbox
	#----------------------------------------------------------
	# Add Textbox
	$tb_MAIN = New-Object System.Windows.Forms.RichTextbox
	$tb_MAIN.Name = "tb_MAIN"
	$tb_MAIN.Location = New-Object System.Drawing.Size(170,73)
	$tb_MAIN.Size = New-Object System.Drawing.Size(800,300)
	# Add to form
	$np_GUI.Controls.Add($tb_MAIN)



	#----------------------------------------------------------
	# GUI: Label
	#----------------------------------------------------------
	$lb_SETTINGS = New-Object System.Windows.Forms.Label
	$lb_SETTINGS.Name = "label_SETTINGS"
	$lb_SETTINGS.Text = "Settings File: "
	$lb_SETTINGS.Location = New-Object System.Drawing.Size(202,387)
	# Add
	#$np_GUI.Controls.Add($lb_SETTINGS)

	$tb_SETTINGS = New-Object System.Windows.Forms.Textbox
	$tb_SETTINGS.Name = "tb_SETTINGS"
	$tb_SETTINGS.Location = New-Object System.Drawing.Size(170,387)
	$tb_SETTINGS.Size = New-Object System.Drawing.Size(760,30)
	#$tb_SETTINGS.Font = new Font(tb_SETTINGS.Font, tb_SETTINGS.FontSize, FontStyle.Bold);
	# Add
	$np_GUI.Controls.Add($tb_SETTINGS)

<# 	$bd_SETTINGS = New-Object System.Windows.Forms.Rectangle
	$bd_SETTINGS.Location = New-Object System.Drawing.Size(170,383)
	$bd_SETTINGS.Size = New-Object System.Drawing.Size(800,39)
	# Add
	$np_GUI.Controls.Add($bd_SETTINGS) #>

	$bt_SETTINGS = New-Object System.Windows.Forms.Button
	$bt_SETTINGS.Location = New-Object System.Drawing.Size(935,383)
	$bt_SETTINGS.Size = New-Object System.Drawing.Size(26,24)
	$Folder_Image = [System.drawing.image]::FromFile("C:\Users\ac00418\Documents\gui\sandbox\folder.png")
	$bt_SETTINGS.BackgroundImage = $Folder_Image
	$bt_SETTINGS.BackgroundImageLayout = "Center"
	# Add
	$np_GUI.Controls.Add($bt_SETTINGS)

}


End {

	exit

}
