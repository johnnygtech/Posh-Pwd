function New-Rfc2898StringHash
{
    param(
        [parameter()][string]$string,
        [parameter()][int]$iterations = 60000,
        [parameter()][string]$salt
    );

    function New-GuidBasedSalt
    {
        param(
            [parameter()][int]$iterations = 2
        );
        1..$iterations | %{
            $returnvalue += $($([guid]::newguid()).guid -replace "-","")
        }
        return $returnvalue
    }

    $result =@{"iterations"=$iterations;}
    $hashFunc = New-object System.Security.Cryptography.Rfc2898DeriveBytes($string,64)
    if(!$salt){$salt = New-GuidBasedSalt -iterations 1}
    $result.add("salt",$salt)
    $hashFunc.IterationCount = $iterations
    $hashFunc.salt = [convert]::FromBase64String($salt)
    $result.add("hash",[convert]::Tobase64string($hashFunc.GetBytes(20)))
    return $result
}
