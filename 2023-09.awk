# Analyze your OASIS report and extrapolate the next value for each history. What is the sum of these extrapolated values?

function extra_point(arr, len, which,   aux, i, recurse) {
    recurse = 0
    for (i = 2; i <= len; i++) {
        aux[i - 1] = arr[i] - arr[i - 1]
        recurse = recurse || aux[i - 1]
    }
    if (recurse) {
        if (which == "last")
            return arr[len] + extra_point(aux, len - 1, which)
        else return arr[1] - extra_point(aux, len - 1, which)
    }
    else return arr[len]
}

{
    for (i = 1; i <= NF; i++) {
        seq[i] = $i
    }
    total_pt1 = total_pt1 + extra_point(seq, NF, "last")
    total_pt2 = total_pt2 + extra_point(seq, NF, "first")
}

END {
    print "Part 1: The sum of points is " total_pt1 "."
    print "Part 2: The sum of points is " total_pt2 "."
}
