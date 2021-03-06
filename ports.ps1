param([System.String]$port="")

#Port Investigation v0.1
#Instructions: run like a normal PowerShell script or cmdlet. You can pass a Port parameter (String) with a comma separated list of ports to investigate.
#
#Before running make sure you are
function getAddress([System.String]$data=""){
    $aarr = @("","")
    if([String]::IsNullOrEmpty($data) ){ return $aarr }
    $addressArr = ($data).Split(":")
    $localPort = $addressArr[-1]
    $localIP = $addressArr[0..(($addressArr.Length)-2)] -Join ":"
    $aarr = ($localIP, $localPort)
    return $aarr
}

$arr = @()
$ntarr = @()
$path = ".\"
$commonPorts = "135,80,443,8080,8443,8009,7001,7002,8001,5556"
if([String]::IsNullOrEmpty($port)){ $port = $commonPorts }

Write-Host -ForegroundColor Green "** PORT INVESTIGATION will provide information about common ports being used by Web applications **"
Write-Host -ForegroundColor Green "** Provide a comma separated list of ports, i.e. -Port '80,443' or leave empty to scan common Web ports **" 
Write-Host -ForegroundColor Green "Scanning the following local ports: "$port

$plist = $port.split(",")
$nt = netstat -ano
$nt = $nt[4..($nt.Length)]

foreach($item in $nt){
    $row = $item.Split(" ",[System.StringSplitOptions]::RemoveEmptyEntries)
    $localAddress = getAddress($row[1])
    $remoteAddress = getAddress($row[2])
    $ntarr+= New-Object psobject @{ 'Protocol' = $row[0]; 'LocalIP' = $localAddress[0]; 'LocalPort' = $localAddress[1]; 'RemoteIP' = $remoteAddress[0]; 'RemotePort' = $remoteAddress[1]; 'Status' = $row[3]; 'ProcessId' = $row[4]; 'ProcessInstallationPath' = ""; 'ProcessName' = ''; 'ProcessDescription' = ''}
}

$filtered = $ntarr | Where-Object {$_.LocalPort -in ($plist)}

foreach($item in $filtered){
        Write-Host  $item.Protocol "," $item.localIP "," $item.localPort "," $item.status "," $item.processId
        $process = Get-Process | Where {$_.Id -eq $item.processId} | Select-Object -Property Id,ProcessName,MachineName,Description,Path
        if($process.Id -eq "4"){
            $process.ProcessName = "IIS"
            $process.Description = "IIS"
            $process.Path = "C:\Windows\System32\inetsrv\w3wp.exe"
        }
        $item.ProcessInstallationPath = $process.Path
        $item.ProcessName = $process.ProcessName
        $item.ProcessDescription = $process.Description
} #end foreach

$outputFile = $path + "\" + (Get-Date -Format "yyyy-MM-dd__HH-mm") + ".txt"

$(foreach ($ht in $filtered) {new-object PSObject -Property $ht}) | Sort-Object -Property LocalPort | Format-Table LocalPort,LocalIp,RemotePort,RemoteIp,Status,Protocol,ProcessId,ProcessName,ProcessDescription,ProcessInstallationPath -AutoSize | Out-File $outputFile
notepad.exe $outputFile

