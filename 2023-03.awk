# What is the sum of all of the part numbers in the engine schematic?
# What is the sum of all of the gear ratios in your engine schematic?

function overlap (num_start, num_len, symbol_ind) {
    return num_start - 1 <= symbol_ind && num_start + num_len >= symbol_ind
}

function sum_engine_parts (line_nums, line_sym, sym_row) {
    delete used
    sum = 0
    for (i in line_nums) {
        for (j in line_sym) {
            if (overlap(strtonum(i), length(line_nums[i]), strtonum(j))) {
                # print "+ " line_sym[j] line_nums[i]
                sum = sum + strtonum(line_nums[i])
                if (line_sym[j] == "*") {
                    if ((sym_row, j) in gear_ratio) {
                        gear_ratio[sym_row, j] = gear_ratio[sym_row, j] * strtonum(line_nums[i])
                        gear_parts[sym_row, j] = gear_parts[sym_row, j] + 1
                    }
                    else {
                        gear_ratio[sym_row, j] = strtonum(line_nums[i])
                        gear_parts[sym_row, j] = 1
                    }
                }
                used[i] = i
                break
            }
        }
    }
    for (i in used) delete line_nums[i]
    return sum
}

function findall(str, regex, records, icon) {
    offset = 0 
    buf = str
    while (match(buf, regex)) {
        offset = offset + RSTART
        # printf(icon "%d  ", offset)
        records[offset] = substr(buf, RSTART, RLENGTH)
        buf = substr(buf, RSTART + RLENGTH)
        offset = offset + RLENGTH - 1
    }
    # printf("\n")
}

{
    delete prev_line_symbols
    for (s in line_symbols) {
        prev_line_symbols[s] = line_symbols[s]
    }
    delete line_symbols
    findall($0, "[^[:digit:]\\.]", line_symbols, "#")
}

{
    # overlaps with line below
    total_sum = total_sum + sum_engine_parts(line_numbers, line_symbols, NR)

    delete line_numbers
    findall($0, "[[:digit:]]+", line_numbers, "$")

    #overlaps with line above
    total_sum = total_sum + sum_engine_parts(line_numbers, prev_line_symbols, NR - 1)
    #overlaps with current line
    total_sum = total_sum + sum_engine_parts(line_numbers, line_symbols, NR)
}

END {
    for (combined in gear_parts) {
        split(combined, idx, SUBSEP)
        if (gear_parts[idx[1], idx[2]] == 2) {
            sum_ratios = sum_ratios + gear_ratio[idx[1], idx[2]]
        }
    }

    print "Part 1: The sum of engine parts is " total_sum
    print "Part 2: The sum of gear ratios is " sum_ratios
}
