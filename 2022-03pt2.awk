# Find the item type that corresponds to the badges of each three-Elf group. What is the sum of the priorities of those item types?

BEGIN {
    FS = ""
    split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", types) 
    for (t in types) {
        priorities[types[t]] = t
    }
    elf_no = 1
}

{
    new = 1
}

elf_no == 3 && new {
    new = 0
    for (i=1; i <= NF; i++) {
        if (index(rucksack[1], $i) && index(rucksack[2], $i)) {
            # print rucksack[1] ":" rucksack[2] ":" $0 "::" $i
            sum_priorities = sum_priorities + priorities[$i]
            break
        }
    }
    elf_no = 1
}

elf_no == 2 && new {
    new = 0
    rucksack[2] = $0
    elf_no++
}

elf_no == 1 && new {
    new = 0
    rucksack[1] = $0
    elf_no++
}

END {
    print "Sum of priorities: " sum_priorities
}
