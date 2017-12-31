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

$stringToSalt = "password"

#When you have to hash a NEW string
$Obj = New-Rfc2898StringHash -string $stringToSalt -iterations 60000
#When comparing a hash previously generated
$testone = New-Rfc2898StringHash -string $stringToSalt -iterations $obj.iterations -salt $obj.salt
#a new stored version of same original string
$obj2 = New-Rfc2898StringHash -string $stringToSalt -iterations 60000
#successfully matches new object
$testtwo = New-Rfc2898StringHash -string $stringToSalt -iterations $obj2.iterations -salt $obj2.salt
#however, original object and obj2 are different (due to the salt)
$obj
$testone
$obj2
$testtwo
Compare-Object $testone.hash $testtwo.hash


