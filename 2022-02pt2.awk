# What would your total score be if everything goes exactly according to your strategy guide?

{
    gsub(/[AX]/, "1")
    gsub(/[BY]/, "2")
    gsub(/[CZ]/, "3")
    outcome = $2 - 2
    $2 = outcome + $1
    if ($2 > 3)
        $2 = 1
    if ($2 < 1)
        $2 = 3
    score = score + (outcome + 1)*3 + $2
    # print $0 ":" outcome "::" score 
}

END {
    print "The final score is " score
}
