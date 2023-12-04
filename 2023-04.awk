# Take a seat in the large pile of colorful cards. How many points are they worth in total?

# Process all of the original and copied scratchcards until no more scratchcards are won. Including the original set of scratchcards, how many total scratchcards do you end up with?

{
    sub(/^.*: /, "")  # remove card number
    delete winning
    for (i = 1; $i != "|"; i++) {
        winning[strtonum($i)] = strtonum($i)
    }

    cardval = 0
    for (i++; i <= NF; i++) {
        # printf("is " $i " a winning number?")
        if (strtonum($i) in winning) {
            # printf("  ..yes!")
            cardval++
        }
        # printf("\n")
    }
    points = (cardval > 0) ? points + 2 ^ (cardval - 1) : points
    
    copies[NR] = copies[NR] + 1
    total_scratchcards = total_scratchcards + copies[NR]
    # print (NR ": " copies[NR] " copies")
    for (i = 1; i <= cardval; i++) {
        copies[NR + i] = copies[NR + i] + copies[NR]
    }
}

END {
    print "The total number of points is " points
    print "The total number of scratchcards is " total_scratchcards
}
