# In how many assignment pairs do the ranges overlap?

BEGIN {
    FS = ","
}

{
    split($1, A, "-")
    split($2, B, "-")
    if (A[2] >= B[1] && A[2] <= B[2]) {
        # print $0
        contains = contains + 1
    }
    else if (B[2] >= A[1] && B[2] <= A[2]) {
        # print $0
        contains = contains + 1
    }
}

END {
    print "Pairs with overlap: " contains
}
