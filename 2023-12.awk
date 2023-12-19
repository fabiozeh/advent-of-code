function ideal_line(def_arr,   n, i, str) {
    str = ""
    for (n in def_arr) {
        for (i=1; i<=def_arr[n]; i++)
            str = str "#"
        str = str "."
    }
    return substr(str, 1, length(str) - 1)
}

function next_idx(state_char, sol_cur_idx, ideal_arr,   sol_cur_char, sol_next_char) {
    sol_cur_char = (sol_cur_idx) ? ideal_arr[sol_cur_idx] : "."
    sol_next_char = (sol_cur_idx < length(ideal_arr)) ? ideal_arr[sol_cur_idx + 1] : ""
    if (state_char == sol_next_char) return sol_cur_idx + 1
    else if (sol_cur_char == "." && state_char == ".") return sol_cur_idx
    else if (sol_next_char == "" && state_char == ".") return sol_cur_idx
    else return -1
}

function update_solutions(sol_arr, sol_arr_new, state_ind, state_str, ideal_arr,        state_char, to_end, s, s_arr, n, new_sol_str) {
   delete sol_arr_new
   to_end = length(state_str) - state_ind
   for (s in sol_arr) {
       state_char = substr(state_str, state_ind, 1)
       if (state_char == "?") {
           n = next_idx(".", strtonum(s), ideal_arr)
           if (n != -1 && to_end + n >= length(ideal_arr)) {
               sol_arr_new[n] = sol_arr_new[n] + sol_arr[s]
           }
           state_char = "#"
       }
       n = next_idx(state_char, strtonum(s), ideal_arr)
       if (n != -1 && to_end + n >= length(ideal_arr)) {
           sol_arr_new[n] = sol_arr_new[n] + sol_arr[s]
       }
   }
}

function count_solutions(state_str, def_str,    s, sol, sol_aux, i, ideal_arr, total) {
    sol[0] = 1
    split(def_str, ideal_arr, "")
    # print "----"
    # print state_str " " def_str
    for (i=1; i<=length(state_str); i++) {
        if (i % 2) {
            update_solutions(sol, sol_aux, i, state_str, ideal_arr)
            sol_str = ""
            # for (s in sol_aux) {
            #     sol_str = sol_str "/" s
            # }
            # print sol_str
        }
        else {
            update_solutions(sol_aux, sol, i, state_str, ideal_arr)
            sol_str = ""
            # for (s in sol) {
            #     sol_str = sol_str "/" s
            # }
            # print sol_str
        }
    }
    total = 0
    if (i % 2) {
        for (s in sol) {
            total = total + sol[s]
        }
    }
    else {
        for (s in sol_aux) {
            total = total + sol_aux[s]
        }
    }
    return total
}

BEGIN {
    FS = " "
}

{
    delete da
    split($2, da, ",")
    total_solutions = total_solutions + count_solutions($1, ideal_line(da))

    unfolded_springs = $1
    unfolded_check = $2
    for (i=1; i <= 4; i++) {
        unfolded_springs = unfolded_springs "?" $1
        unfolded_check = unfolded_check "," $2
    }
    delete da
    split(unfolded_check, da, ",")
    total_pt2 = total_pt2 + count_solutions(unfolded_springs, ideal_line(da))
}

END {
    print "Part 1: The sum of all solutions is " total_solutions "."
    print "Part 2: The sum of all solutions is " total_pt2 "."
}

