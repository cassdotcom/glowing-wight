#----------------------------------------------------------
# .function_WRITE_TO_LOG
#----------------------------------------------------------

	Param (
		[Parameter(Position=0, Mandatory=$true)]
		[System.String]
		$msg,
		[Parameter(Position=1, Mandatory=$true)]
		[System.String]
		$PSHELL_LOG_FILE)
	
	Try {
	
		"$(get_timestamp):`t$($msg)" | Out-File -filepath $PSHELL_LOG_FILE -append
		
	} Catch {
		
		$this_err = $_
		$error_name = "CANNOT WRITE TO LOG"
		catch_error $this_err $error_name $PSHELL_LOG_FILE -NoLog
		
	}
