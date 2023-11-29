# What SNAFU number do you supply to Bob's console?

function dec2snafu(num) {
    snafu = ""
    carry = 0
    while (num != 0) {
        digit = num % 5 + carry
        if (digit < 3) {
            snafu = digit snafu 
            carry = 0
        }
        else if (digit == 3) {
            snafu = "=" snafu 
            carry = 1
        }
        else if (digit == 4) {
            snafu = "-" snafu 
            carry = 1
        }
        else {
            snafu = "0" snafu 
            carry = 1
        }
        num = int(num / 5)
    }
    if (carry)
        snafu = "1" snafu
    return snafu
}

BEGIN {
    FS = ""
}

{
    factor = 1
    line_total = 0
    for (i=NF; i >= 1; i--) {
        if ($i == "=") {
            line_total = line_total - 2*factor
            total = total - 2*factor
        }
        else if ($i == "-") {
            line_total = line_total - factor
            total = total - factor
        }
        else {
            digit = strtonum($i)
            line_total = line_total + digit*factor
            total = total + digit*factor
        }
        factor = 5*factor
    }
    # print line_total
}

END {
    # print "Total: " total
    print "Fuel required: " dec2snafu(total)
}
