#----------------------------------------------------------
# .function_GET-TIMESTAMP
#----------------------------------------------------------

Param(
	[Switch]
	$extension,
	[Switch]
	$reporting,
	[Switch]
	$readable
)

if ( $extension ) {
	
	$timestamp = Get-Date -UFormat "%d%b_%H-%M-%S"
	
} 

if ( $reporting ) {
	
	$timestamp = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
	
}

if ( $readable ) {

	$timestamp = Get-Date -UFormat "%A %e %B %Y, %R"
	
}
	
return $timestamp
	
