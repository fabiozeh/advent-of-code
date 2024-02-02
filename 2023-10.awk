# Find the single giant loop starting at S. How many steps along the loop does it take to get from the starting position to the point farthest from the starting position?

function track_pipe(r, c, direction) {
    if (direction == "north") {
        if (r == 1) return 0
        if (map[r - 1][c] == "7") return "west"
        if (map[r - 1][c] == "F") return "east"
        if (map[r - 1][c] == "|") return "north"
        if (map[r - 1][c] ~ "=.+") return "stop"
    }
    else if (direction == "south") {
        if (r == NR) return 0
        if (map[r + 1][c] == "|") return "south"
        if (map[r + 1][c] == "J") return "west"
        if (map[r + 1][c] == "L") return "east"
        if (map[r + 1][c] ~ "=.+") return "stop"
    }
    else if (direction == "east") {
        if (!(c + 1 in map[r])) return 0
        if (map[r][c + 1] == "-") return "east"
        if (map[r][c + 1] == "J") return "north"
        if (map[r][c + 1] == "7") return "south"
        if (map[r][c + 1] ~ "=.+") return "stop"
    }
    else {
        if (!(c - 1 in map[r])) return 0
        if (map[r][c - 1] == "-") return "west"
        if (map[r][c - 1] == "L") return "north"
        if (map[r][c - 1] == "F") return "south"
        if (map[r][c - 1] ~ "=.+") return "stop"
    }
    return 0  # different char = dead end
}

function find_farthest() {
    cur_farthest = 0
    map[st_r][st_c] = "=" cur_farthest++  # starting point
    end_a = (track_pipe(st_r, st_c, "north")) ? "north" : 0
    if (!end_a) { end_a = (track_pipe(st_r, st_c, "east")) ? "east" : 0 }
    end_a = (end_a) ? end_a : "south"
    end_b = (track_pipe(st_r, st_c, "west")) ? "west" : 0
    if (!end_b) { end_b = (track_pipe(st_r, st_c, "south")) ? "south" : 0 }
    end_b = (end_b) ? end_b : "east"
    a_r = st_r
    b_r = st_r
    a_c = st_c
    b_c = st_c
    while(end_a != "stop" && end_b != "stop") {
        nxt_a = track_pipe(a_r, a_c, end_a)
        a_r = a_r + (end_a == "south") - (end_a == "north")
        a_c = a_c + (end_a == "east") - (end_a == "west")
        map[a_r][a_c] = "=" cur_farthest
        nxt_b = track_pipe(b_r, b_c, end_b)
        b_r = b_r + (end_b == "south") - (end_b == "north") 
        b_c = b_c + (end_b == "east") - (end_b == "west")
        map[b_r][b_c] = "=" cur_farthest++
        end_a = nxt_a
        end_b = nxt_b
    }
    return --cur_farthest
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

#     for (i = 1; i <= NR; i++) {
#         for (j = 1; j <= NF; j++) {
#             if (map[i][j] ~ "=") printf("%s", substr(map[i][j], 2, 1)); else printf(" ")
#         }
#         printf("\n")
#     }

    print "Part 1: It takes " farthest " steps to get to the farthest point."
}
