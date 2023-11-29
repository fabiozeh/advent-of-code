# Find the item type that appears in both compartments of each rucksack. What is the sum of the priorities of those item types?

BEGIN {
    FS = ""
    split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", types) 
    for (t in types) {
        priorities[types[t]] = t
    }
}

{
    compartment2 = substr($0, NF/2 + 1)
    for (i=1; i <= NF/2; i++) {
        if (index(compartment2, $i)) {
            # print $0 "::" $i
            sum_priorities = sum_priorities + priorities[$i]
            break
        }
    }
}

END {
    print "Sum of priorities: " sum_priorities
}
