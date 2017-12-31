. ./functions.ps1

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
