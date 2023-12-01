# Consider your entire calibration document. What is the sum of all of the calibration values?

function parsedigit(str) {
    if (str == "one")
        return 1
    else if (str == "two")
        return 2
    else if (str == "three")
        return 3
    else if (str == "four")
        return 4
    else if (str == "five")
        return 5
    else if (str == "six")
        return 6
    else if (str == "seven")
        return 7
    else if (str == "eight")
        return 8
    else if (str == "nine")
        return 9
    else return strtonum(str)
}

{
    match($0, /[0-9]|one|two|three|four|five|six|seven|eight|nine/, f); 
    match($0, /.*([0-9]|one|two|three|four|five|six|seven|eight|nine)/, s);
    lineval = parsedigit(f[0]) parsedigit(s[1])
    sum = sum + lineval
    # print $0 " " lineval
} 

END { 
    print "sum is " sum
}
