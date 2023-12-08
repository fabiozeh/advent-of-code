# Determine the number of ways you could beat the record in each race. What do you get if you multiply these numbers together?

# (time - hold) * hold = dist
# h for max-dist --> d(-h^2 + th)/dh = 0
# -2h + t = 0
# h_max = t/2

# -h^2 + th - dist = 0
# h for exact distance = h_exact = (t + sqrt(t^2 - 4dist))/2

# All int in [h_max - abs(h_exact - h_max), h_max + abs(h_exact - h_max)] is a win.

function wins(hold, t, d) {
    return (t - hold) * hold > d
}

function ways_to_win(t, d,        h_max, delta, h_exact, interval, has_int_right_edge, has_int_left_edge, wtw) {
        h_max = t / 2
        delta = t^2 - 4 * d
        delta = (delta > 0) ? delta : -delta
        h_exact = (t + sqrt(delta)) / 2
        interval = h_max - h_exact
        interval = (interval > 0) ? interval : -interval
        left_edge = strtonum(sprintf("%.0f", h_max - interval))
        left_edge = (wins(left_edge, t, d)) ? left_edge : left_edge + 1
        right_edge = strtonum(sprintf("%.0f", h_max + interval))
        right_edge = (wins(right_edge, t, d)) ? right_edge : right_edge - 1
        wtw = right_edge - left_edge + 1
        # print "For " t "ms, " d "mm, best is h=" h_max "ms."
        # printf("Interval to win is [%.10f, %.10f] = %d ways.\n", h_max - interval, h_max + interval, wtw)
        return wtw
}

/^Time/ {
    sub(/^Time:\s+/, "")
    for (i = 1; i <= NF; i++) {
        time[i] = strtonum($i)
        long_time = long_time $i
    }
}

/^Distance/ {
    sub(/^Distance:\s+/, "")
    for (i = 1; i <= NF; i++) {
        distance[i] = strtonum($i)
        long_distance = long_distance $i
    }
}

END {
    total_ways_to_win = 1
    for (i in time) {
        total_ways_to_win = total_ways_to_win * ways_to_win(time[i], distance[i])
    }
    print "Part 1: There are " total_ways_to_win " ways to win."
    print "Part 2: There are " ways_to_win(strtonum(long_time), strtonum(long_distance)) " ways to win the long race."
}
