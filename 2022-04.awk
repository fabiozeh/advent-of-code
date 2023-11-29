# In how many assignment pairs does one range fully contain the other?

BEGIN {
    FS = ","
}

{
    split($1, A, "-")
    split($2, B, "-")
    if (A[1] <= B[1] && A[2] >= B[2]) {
        # print $0
        contains = contains + 1
    }
    else if (A[1] >= B[1] && A[2] <= B[2]) {
        # print $0
        contains = contains + 1
    }
}

END {
    print "Pairs with full containment: " contains
}
