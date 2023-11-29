# Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?

BEGIN {
    elf_idx = 1
}

/^[0-9]+/ {
    elf[elf_idx] = elf[elf_idx] + $0
}

/^[[:space:]]*$/ {
    elf_idx++
}

END {
    top3_idx = 1
    PROCINFO["sorted_in"] = "@val_num_desc"
    for (idx in elf) {
        if (top3_idx == 1) {
            max_cal = elf[idx]
            max_idx = idx
        }
        if (top3_idx > 3)
            break
        top3 = top3 + elf[idx]
        top3_idx++
    }
    print "The elf carrying the most Calories is Elf #" max_idx ", with " max_cal " calories"
    print "The summed calories from the top 3 elves is " top3
}

