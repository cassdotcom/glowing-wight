#----------------------------------------------------------
# .function_CATCH_ERROR
#----------------------------------------------------------

    Param(
        [Parameter(Position=0,Mandatory=$true)]
        $err,
        [Parameter(Position=1,Mandatory=$true)]
        $error_name,
		[Parameter(Position=2,Mandatory=$true)]
		$PSHELL_LOG_FILE,
		[Switch]
		$NoLog
	)

	if ( $NoLog ) {
	
		Write-Host @"
		
		 $('-' * 50)
		 -- SCRIPT PROCESSING CANCELLED
		 $('-' * 50)
		
		 Error in $($error_name)
		
		 $('-' * 50)
		 -- Error information
		 $('-' * 50)
		
		 Line Number: $($err.InvocationInfo.ScriptLineNumber)
		 Offset: $($err.InvocationInfo.OffsetInLine)
		 Command: $($err.InvocationInfo.MyCommand)
		 Line: $($err.InvocationInfo.Line.Trim())
		 Error Details: $($err)
"@ -ForegroundColor Red -BackgroundColor White
	
	} else {
	
		write_to_log "$('-' * 50)" $PSHELL_LOG_FILE
		write_to_log " -- SCRIPT PROCESSING CANCELLED" $PSHELL_LOG_FILE
		write_to_log " $('-' * 50)" $PSHELL_LOG_FILE
		write_to_log " " $PSHELL_LOG_FILE
		write_to_log " Error in $($error_name)" $PSHELL_LOG_FILE
		write_to_log " " $PSHELL_LOG_FILE
		write_to_log "$('-' * 50)" $PSHELL_LOG_FILE
		write_to_log " -- Error information" $PSHELL_LOG_FILE
		write_to_log " $('-' * 50)" $PSHELL_LOG_FILE
		write_to_log " " $PSHELL_LOG_FILE
		write_to_log " Line Number: $($err.InvocationInfo.ScriptLineNumber)" $PSHELL_LOG_FILE
		write_to_log " Offset: $($err.InvocationInfo.OffsetInLine)" $PSHELL_LOG_FILE
		write_to_log " Command: $($err.InvocationInfo.MyCommand)" $PSHELL_LOG_FILE
		write_to_log " Line: $($err.InvocationInfo.Line.Trim())" $PSHELL_LOG_FILE
		write_to_log " Error Details: $($err)" $PSHELL_LOG_FILE
	
	}
