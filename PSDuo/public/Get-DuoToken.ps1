<#
.Synopsis
   Retrieve DUO Token
.DESCRIPTION
   Returns information on the specified token of the specified type (default = 'yk' (YubiKey)).
.EXAMPLE
    Get-DuoToken -serial 1234567
.INPUTS
   [string]serial
   [string]type
.OUTPUTS
   [PSCustomObject]DuoRequest
.NOTES
    DUO API 
        Method GET 
        Path /admin/v1/users
    PARAMETERS
        Parameter	Required?	Description
        username	Required	Specify a token serial to look up.
    RESPONSE CODES
        Response	Meaning
        200	        Success. Returns a list of tokens.
        400	        Invalid parameters.
.COMPONENT
   The component this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Get-DuoToken
{
    [CmdletBinding(
    )]
    param
    (
        [parameter(Mandatory = $true)]
        [string]$serial,
        [parameter(Mandatory = $false)]
        [String]$type = 'yk'
    )
    [string]$method = "GET"
    [string]$path = "/admin/v1/tokens"
    $APiParams = @{serial = $serial; type = $type}
    
    $DuoRequest = Convertto-DUORequest -DuoMethodPath $path -Method $method -ApiParams $ApiParams
    $Response = Invoke-RestMethod @DuoRequest
    If ($Response.stat -ne 'OK') {
        Write-Warning 'DUO REST Call Failed'
        Write-Warning "APiParams:"+($APiParams | Out-String)
        Write-Warning "Method:$method    Path:$path"
    }   
    
    $Response.response
}
