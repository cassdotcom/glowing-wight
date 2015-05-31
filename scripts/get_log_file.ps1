#----------------------------------------------------------
# .function_GET_LOG_FILE
#----------------------------------------------------------
	Param(
		[Parameter(Position=0, Mandatory=$true)]
		[System.string]
		$log_dir
	)
	
	# Find what is in this directory	
	$log_files = gci $log_dir
	
	# Move everything into 'old' directory so our log is the only file available here
	foreach ( $log in $log_files ) {
		if ( -Not $log.PSIsContainer ) {
			$dest = $log_dir + "\old\" + $log.name
			Move-Item -Path $log.FullName -Destination $dest
		}
	}
	$log_ext = get_timestamp -extension
	$PSHELL_LOG_FILE = $log_dir + "cbm-create-log." + $log_ext
		
	return $PSHELL_LOG_FILE
