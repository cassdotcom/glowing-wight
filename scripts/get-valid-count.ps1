$all_model_paths = gc "S:\TEST AREA\ac00418\CBM\model_data\fy5_model_paths.txt"

$results = @()
$total_valid = 0
$total_invalid = 0

foreach ( $m in $all_model_paths ) {

    $model_path = New-Object PSObject
    $model_path | Add-Member -MemberType NoteProperty -Name PATH -Value $m

    if ( Test-Path $m ) {
        
        $exists = "YES"
        $total_valid++

    } else {

        $exists = "NO"
        $total_invalid++

    }

    $model_path | Add-Member -MemberType NoteProperty -Name VALID -Value $exists
    $results += $model_path

}

write-host "TOTAL VALID: $($total_valid)"
Write-Host "TOTL NOT VALID: $($total_invalid)"

return $results
