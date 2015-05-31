


#----------------------------------------------------------
# .function_WRITE_TO_LOG_AND_LINE
#----------------------------------------------------------

	Param (
		[Parameter(Position=0, Mandatory=$true)]
		[System.String]
		$msg,
		[Parameter(Position=1, Mandatory=$true)]
		[System.String]
		$PSHELL_LOG_FILE,
		[Switch]
		$NoLog,
		[Switch]
		$NoConsole
	)
	
	Try {
	
		$date_and_time = get_timestamp -reporting
		$tx_dets.AppendText("`r$($msg)")
		"$($date_and_time):`t$($msg)" | Out-File -filepath $PSHELL_LOG_FILE -append
		
	} Catch {
		
		$this_err = $_
		$error_name = "CANNOT WRITE TO LOG"
		catch_error $this_err $error_name $PSHELL_LOG_FILE -NoLog
		
	}
