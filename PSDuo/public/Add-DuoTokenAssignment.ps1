function Add-DuoTokenAssignment
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true)]
        [String]$username,
        [parameter(Mandatory = $false,
        ValueFromPipelineByPropertyName = $true)]
        [String]$user_id = (Get-DuoUser -username $username).user_id,
        [parameter(Mandatory = $false,
        ValueFromPipelineByPropertyName = $true)]
        [string]$serial,
        [parameter(Mandatory = $false,
        ValueFromPipelineByPropertyName = $true)]
        [string]$tokenID = (Get-DUOToken -serial $serial).token_id
        
    )
    [string]$method = "POST"
    [string]$path = "/admin/v1/users/$user_id/tokens"
    $MyInvocation.BoundParameters.Remove('user_id')
    $ApiParams = @{token_id = $tokenID}

    $DuoRequest = Convertto-DUORequest -DuoMethodPath $path -Method $method -ApiParams $ApiParams
    $Response = Invoke-RestMethod @DuoRequest
    If($Response.stat -ne 'OK'){
       Write-Warning 'DUO REST Call Failed'
       Write-Warning ($APiParams | Out-String)
       Write-Warning "Method:$method    Path:$path"
    }   
    $Response.response
}
