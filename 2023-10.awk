# Find the single giant loop starting at S. How many steps along the loop does it take to get from the starting position to the point farthest from the starting position?

function find_farthest() {

}

BEGIN {
    FS = ""
}

{
    for (i = 1; i <= NF; i++) {
        map[NR][i] = $i
        if ($i == "S") {
            st_r = NR
            st_c = i
        }
    }
}

END {
    farthest = find_farthest()

    print "Part 1: It takes " farthest " steps to get to the farthest point."
}
