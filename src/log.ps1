function warn($msg) {
    Write-Host "Warning: $msg" -f darkyellow
}

function error($msg, [int] $exit_code = 1) {
    Write-Host "Error: $msg" -f darkred
    exit $exit_code
}