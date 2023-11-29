# What would your total score be if everything goes exactly according to your strategy guide?

{
    gsub(/[AX]/, "1")
    gsub(/[BY]/, "2")
    gsub(/[CZ]/, "3")
    outcome = $2 - $1
    if (outcome == 0)
        score = score + 3
    else if (outcome == 1 || outcome == -2)
        score = score + 6
    score = score + $2
    # print $0 ":" outcome "::" score 
}

END {
    print "The final score is " score
}
