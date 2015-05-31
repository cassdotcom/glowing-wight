function bt_CBM_Clicked {

	$tb_MAIN.AppendText("in cbm button")
	
	$job = { 
<# 		param(
			[System.String]
			$sjobstr
		) #>
		
		for ( $i = 0; $i -lt 10; $i++ ) { $tb_Main.AppendText(" ."); start-sleep -milliseconds 100 }
		
	}	
		
		#Get-Process | Select displayname | Out-String
		#$tb_MAIN.AppendText("1 2 3")		
	
	$newRunspace = [runspacefactory]::CreateRunspace()
	$newRunspace.ApartmentState = "STA"
	$newRunspace.ThreadOptions = "ReuseThread"
	$newRunspace.Open()
	$script:newpowershell = [powershell]::Create().addscript($job)
	$newpowershell.runspace = $newRunspace
	$script:sjob = $newpowershell.begininvoke()
	
	$timerCheckJob.Tag = $sjob
	$timerCheckJob.Start()
	
	$tb_MAIN.AppendText("`rLoading models")
	$model_data = .\side-function.ps1
	$tb_MAIN.AppendText(" . . . . DONE")
	
}


$Global:timerCheckJob.Add_Tick({

	$tb_MAIN.AppendText("`radd-tick")

	# check if process stopped
	if ( $timerCheckJob.Tag -ne $null ) {
		
		if ( $timerCheckJob.Tag.IsCompleted -eq 'True' ) {
		
			$tb_MAIN.AppendText("is completed")
		
			$script:processes = @()
			
			$processes += $newpowershell.endinvoke($sjob)
			$newpowershell.dispose()
			
			foreach ( $process in $processes ) {
				
				$tb_MAIN.AppendText($process)
			
			}
			
			# Stop the timer
			$timerCheckJob.Tag = $null
			$timerCheckJob.Stop()
			
		}
		
	}
	
})

function bt_VIEW_Clicked {

	$tb_MAIN.AppendText("view button clicked`r")
	#.\side-function.ps1
	
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



# Add CBM Button
$bt_CBM = New-Object System.Windows.Forms.Button
$bt_CBM.Name = "bt_CBM"
$bt_CBM.Location = New-Object System.Drawing.Size(11,73)
$bt_CBM.Size = New-Object System.Drawing.Size(150,40)
$bt_CBM.Text = "CBM"

# Add view button
$bt_VIEW = New-Object System.Windows.Forms.Button
$bt_VIEW.Name = "bt_VIEW"
$bt_VIEW.Location = New-Object System.Drawing.Size(11,131)
$bt_VIEW.Size = New-Object System.Drawing.Size(150,40)
$bt_VIEW.Text = "VIEW"

# Add verify button
$bt_VERIFY = New-Object System.Windows.Forms.Button
$bt_VERIFY.Name = "bt_VERIFY"
$bt_VERIFY.Location = New-Object System.Drawing.Size(11,189)
$bt_VERIFY.Size = New-Object System.Drawing.Size(150,40)
$bt_VERIFY.Text = "VERIFY"

# Add Textbox
$tb_MAIN = New-Object System.Windows.Forms.RichTextbox
$tb_MAIN.Name = "tb_MAIN"
$tb_MAIN.Location = New-Object System.Drawing.Size(170,73)
$tb_MAIN.Size = New-Object System.Drawing.Size(800,300)


# Add to form
$np_GUI.Controls.Add($bt_CBM)
$np_GUI.Controls.Add($bt_VIEW)
$np_GUI.Controls.Add($bt_VERIFY)
$np_GUI.Controls.Add($tb_MAIN)
	

$Global:timerCheckJob = New-Object System.Windows.Threading.DispatcherTimer


$bt_CBM.add_Click({  bt_CBM_Clicked })
$bt_VIEW.add_Click({ bt_VIEW_Clicked })


# Show form
$np_GUI.ShowDialog() | Out-Null


	
	
