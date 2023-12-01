# After the rearrangement procedure completes, what crate ends up on top of each stack?

function move(amount, src, dest, model, crate) {
   if (model == "9000" && amount > 1) {
       for (i = 1; i <= amount; i++) move(1, src, dest, model, crate)
       return
   }
   box = substr(crate[src], 1, amount)
   crate[src] = substr(crate[src], 1 + amount)
   crate[dest] = box crate[dest]
}

/^[[:space:]]*\[/ {
    delete chars
    split($0, chars, "")
    i = 1
    for (c in chars) {
        if ((i + 2) % 4 == 0 && chars[c] ~ /[[:alpha:]]/) {
            ind = int((i + 2) / 4)
            crate[ind] = crate[ind] chars[c] 
        }
        i++
    }
}

/^[[:space:]]*[[:digit:]]/ {
    print "#### INITIAL CRATE STATES ####"
    for (i = 1; i <= 9; i++) {
        print crate[i]
        crate_pt2[i] = crate[i]
    }
}

/^move/ {
    move($2, $4, $6, "9000", crate)
    move($2, $4, $6, "9001", crate_pt2)
}

END {
    PROCINFO["sorted_in"] = "@ind_num_asc"
    output = ""
    output_pt2 = ""
    print "#### FINAL CRATE STATES ####"
    print "## PT1 ##"
    for (i in crate) {
        print crate[i]
        output = output substr(crate[i], 1, 1)
    }
    print "## PT2 ##"
    for (i in crate_pt2) {
        print crate_pt2[i]
        output_pt2 = output_pt2 substr(crate_pt2[i], 1, 1)
    }
    print "Top boxes (pt. 1): " output
    print "Top boxes (pt. 2): " output_pt2
}
