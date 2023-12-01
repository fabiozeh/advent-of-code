# Consider your entire calibration document. What is the sum of all of the calibration values?

function parsedigit(m) {
    for (i = 2; i <= 10; i++) {
        if (i in m) {
            return i - 1
        }
    }
    return 0
}

{
    digit_regex = "(0|(1|one)|(2|two)|(3|three)|(4|four)|(5|five)|(6|six)|(7|seven)|(8|eight)|(9|nine))"
    match($0, digit_regex, f)
    match($0, ".*"digit_regex, s);
    lineval = parsedigit(f) parsedigit(s)
    sum = sum + lineval
    # print $0 " " lineval
} 

END { 
    print "sum is " sum
}
