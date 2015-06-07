


Process {

	# Constants
	$MISSING_CBM_MODELS = "S:\TEST AREA\ac00418\CBM\model_data\missing-cbm.txt"
	$NETWORK_DB = "S:\TEST AREA\ac00418\CBM\model_data\NetworkModels.mdb"
	$QRYDB = "S:\TEST AREA\ac00418\CBM\rev_ii\query-database.ps1" 
	set-alias query-database $QRYDB

	# List of missing CBM
	$missing_cbm = gc $MISSING_CBM_MODELS
	# Get missing FY1s
	$query = "SELECT FY1_FOLDER, NETWORK FROM NetworkModels WHERE NetworkModels.FY1_VALID = 'NO' "
	$fy1_models = query-database $NETWORK_DB $query

	# Container for results
	$results = @()
	# Go through each not-valid FY1 model and attempt to find 
	foreach ( $m in $fy1_models ) {
		
		$qry_set = @()
		$fy1_folder = $m.FY1_FOLDER
		$network_name = $m.NETWORK
		
		$det = New-Object PSObject
		<# 	det.NETWORK
			det.FY1_PATH
			det.FY1_PATH_EXISTS
			det.FY1_FOLDER
			det.FY1_MODEL
			det.FY1_MODEL_NAME
			det.FY1_VALID
		#>
		$det | Add-Member -MemberType NoteProperty -Name NETWORK -Value $network_name
		
		# Test if FY1 folder exists
		if ( Test-Path $fy1_folder ) {
		
			$det | Add-Member -MemberType NoteProperty -Name FY1_PATH_EXISTS -Value "YES"
			$det | Add-Member -MemberType NoteProperty -Name FY1_FOLDER -Value $fy1_folder

			# Get all models in this folder. If there's only one, assign it.
			#  If there are > 1, find latest
			$pots = gci $fy1_folder -filter "*.mdb"
			
			if ( $pots.count -eq 0 ) { 
				
				#empty folder
				$det | Add-Member -MemberType NoteProperty -Name POTENTIALS -Value 0
				write-host "FY1 FOLDER IS EMPTY"
				explorer $fy1_folder
				continue
				
			}
			
			if ( $pots.Count -gt 1 ) {
			
				$det | Add-Member -MemberType NoteProperty -Name POTENTIALS -Value $pots.Count
			
				$latest = ($pots | Sort-Object LastWriteTime -descending)[0]
				write-host $latest
				write-host $latest.LastWriteTime
				$decision = Read-Host "Use latest model? (Y or N)"
				
				if ( $decision -match "Y" ) { 
					$FY1_PATH = $latest.fullname
				}
				else {
					$FY1_PATH = Get-FileName $fy1_folder "Pick a model"
				}
				
				$qry_set += "UPDATE NetworkModels SET FY1_PATH = '$($FY1_PATH)' WHERE NETWORK = '$($network_name)' "
				$FY1_MODEL_NAME = Split-Path $FY1_PATH -leaf
				
				$det | Add-Member -MemberType NoteProperty -Name FY1_PATH -Value $FY1_PATH
				
			} else {
			
				$det | Add-Member -MemberType NoteProperty -Name FY1_PATH -Value $pots.fullname
				$qry_set += "UPDATE NetworkModels SET FY1_PATH = '$($pots.fullname)' WHERE NETWORK = '$($network_name)' "
				$FY1_MODEL_NAME = Split-Path $pots.fullname -leaf
				
			}		  

			$qry_set += "UPDATE NetworkModels SET FY1_MODEL = '$($FY1_MODEL_NAME)' WHERE NETWORK = '$($network_name)' "		
			$qry_set += "UPDATE NetworkModels SET FY1_valid = 'YES' WHERE NETWORK = '$($network_name)' "	
				
		} else {
			
			$det | Add-Member -MemberType NoteProperty -Name FY1_PATH_EXISTS -Value "NO"
			
			Write-Host "NO FY1 Folder"
			
			$up_a_level = Split-Path $fy1_folder
			
			$FY1_PATH = Get-FileName $up_a_level "Pick a model"
			$qry_set += "UPDATE NetworkModels SET FY1_PATH = '$($FY1_PATH)' WHERE NETWORK = '$($network_name)' "
			$FY1_FOLDER = Split-Path $FY1_PATH
			$qry_set += "UPDATE NetworkModels SET FY1_FOLDER = '$($FY1_FOLDER)' WHERE NETWORK = '$($network_name)' "
			$det | Add-Member -MemberType NoteProperty -Name FY1_PATH -Value $FY1_PATH
			$FY1_MODEL_NAME = Split-Path $FY1_PATH -leaf
			$qry_set += "UPDATE NetworkModels SET FY1_MODEL = '$($FY1_MODEL_NAME)' WHERE NETWORK = '$($network_name)' "
			$qry_set += "UPDATE NetworkModels SET FY1_VALID = 'YES' WHERE NETWORK = '$($network_name)' "
			
		}

		write-host $FY1_MODEL -backgroundcolor "White" -foregroundcolor "red"
		write-host $FY1_MODEL_NAME -backgroundcolor "white" -foregroundcolor "red"
		foreach ($query in $qry_set) {
			write-host $query
			$null_return = query-database $NETWORK_DB $query
		}
		$results += $det

	}

}


Begin {

	function Get-FileName {
	
		Param(
			[Parameter(Position = 0, Mandatory = $true)]
			[System.String]
			$initialDirectory,
			[Parameter(Position = 1, Mandatory = $false)]
			[System.String]
			$title="Select File...."
		) 
		
		[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

		 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
		 $OpenFileDialog.initialDirectory = $initialDirectory
		 $OpenFileDialog.title = $title
		 $OpenFileDialog.filter = "Synergee Models (*.MDB)| *.MDB"
		 $OpenFileDialog.ShowDialog() | Out-Null
		 $OpenFileDialog.filename

	} #end function Get-FileName


}



End {

	return $results

}


