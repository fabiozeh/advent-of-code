# Consider your entire calibration document. What is the sum of all of the calibration values?

{
    match($0, /[0-9]/, f); 
    match($0, /.*([0-9])/, s); 
    sum = sum + strtonum(f[0] s[1]); 
    # print $0 " " f[0]s[1]
} 

END { 
    print "sum is " sum
}
