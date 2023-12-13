# Starting at AAA, follow the left/right instructions. How many steps are required to reach ZZZ?
#
# Simultaneously start on every node that ends with A. How many steps does it take before you're only on nodes that end with Z?

function navigate(direction_str, coordinate, target, mode, steps_found, memoize, acc,       direction_map, i, mem_idx) {
    for (i = 1; i <= split(direction_str, direction_map, ""); i++) {
        mem_idx = coordinate substr(direction_str, i)
        if (mem_idx in memoize) {
            if (mode == "loop")
                return memoize[mem_idx] " " i + acc - memoize[mem_idx]  # loop start and loop length
            print "We've reached a loop between steps " i " and " memoize[mem_idx] "."
            exit 1
        }
        memoize[mem_idx] = i + acc
        if (direction_map[i] == "L")
            coordinate = left[coordinate]
        else
            coordinate = right[coordinate]
        if (coordinate ~ target) {
            if (mode == "loop")
                steps_found[i + acc] = i + acc
            else
                return i + acc
        }
    }
    if (mode) return navigate(direction_str, coordinate, target, mode, steps_found, memoize, acc + length(direction_str))
    else return coordinate
}

function gcd(a, b) {
    # the famous Euclid algorithm
    if (b > a) return gcd(b, a)
    if (b == 0) return a
    return gcd(b, a % b)
}

function lcm(a, b) {
    return a * b / gcd(a, b)
}

function navigate_ghost(direction_str, coordinate,      sf, j, s, retval, st_len, min_steps) {
    delete sf
    for (j in coordinate) {
        retval[j] = navigate(direction_str, coordinate[j], "Z$", "loop", sf[j])
        split(retval[j], st_len[j], " ")
        printf(coordinate[j] " > loop start index:" st_len[j][1] " loop length:" st_len[j][2] " hits:")
        for (s in sf[j]) {
            printf(s " ")
        }
        printf("\n")
    }

    # From the above it turns out that each path only hits once per loop in the same number of steps as the first time.
    # We only need to find the least common multiple.
    min_steps = strtonum(st_len[1][2])
    for (j = 2; j <= length(coordinate); j++) {
        min_steps = lcm(min_steps, strtonum(st_len[j][2]))
    }
    return min_steps
}


NR == 1 {
    instructions = $0
}

/[A-Z]+ =/ {
    if ($1 in left || $1 in right) {
        print "Ambiguity in input."
        exit 1
    }
    left[$1] = substr($3, 2, 3)
    right[$1] = substr($4, 1, 3)
}

END {
    # testing...
    # print instructions
    # print navigate("LLRR", "QSF", "ZZZ") # QPC
    # print navigate("RRR", "MSD", "ZZZ", "find")  # should arrive in 1 step

    print "Part 1: Arrived in " navigate(instructions, "AAA", "ZZZ", "find") " steps."

    go_idx = 1
    for (c in left) {
        if (c ~ /A$/) {
            # print c
            ghost_origin[go_idx++] = c
        }
    }
    steps = navigate_ghost(instructions, ghost_origin)
    print "Part 2: Arrived in " steps " steps."
}

