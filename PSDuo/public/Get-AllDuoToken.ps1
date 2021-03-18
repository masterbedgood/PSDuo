<#
.Synopsis
   Retrieve all DUO tokens
.DESCRIPTION
   Returns a list of all DUO tokens - automatically pages through results.
.EXAMPLE
    Get-AllDuoToken
.OUTPUTS
   [PSCustomObject]DuoRequest
.NOTES
    DUO API 
        Method GET 
        Path /admin/v1/tokens
    RESPONSE CODES
        Response	Meaning
        200	        Success. Returns a list of tokens.
        400	        Invalid parameters.
.COMPONENT
   The component this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Get-AllDuoToken
{
    $duoRequestHash = @{
        DuoMethodPath = '/admin/v1/tokens'
        Method = 'GET'
        ApiParams = @{novalue = 'provided'}
    }

    $returnObject = @()

    do{
        if($nextOffset){$duoRequestHash.apiParams = @{offset = $nextOffset}}
        $duoRequest = $null

        $duoRequest = Convertto-DUORequest @duoRequestHash
        $duoResponse = Invoke-RestMethod @duoRequest
        
        if($duoResponse.stat -ne 'OK')
        {
            Write-Warning 'DUO REST Call Failed'
            Write-Warning "APiParams:"+($APiParams | Out-String)
            Write-Warning "Method:$method    Path:$path"
        }
        
        $nextOffset = $duoResponse.metadata.'next_offset'
        
        $returnObject += $duoResponse.response
    }while($nextOffset)

    $returnObject
}
