# Consider your entire calibration document. What is the sum of all of the calibration values?

import re
import sys

with open(sys.argv[1]) as file:
    sum = 0
    digit_regex = re.compile('\d')
    for line in file:
        m = digit_regex.findall(line)
        # print (line + "  " + m[0] + m[-1])
        sum += int(m[0] + m[-1])
print(f"Part 1: The sum is {sum}")

def matched_digit(m):
    return [str(i+1) for i, t in enumerate(m[1:]) if t is not None][0]

with open(sys.argv[1]) as file:
    sum = 0
    digit_regex_str = "(0|(1|one)|(2|two)|(3|three)|(4|four)|(5|five)|(6|six)|(7|seven)|(8|eight)|(9|nine))"
    first_re = re.compile(digit_regex_str)
    last_re = re.compile(".*" + digit_regex_str)
    for line in file:
        fst = first_re.search(line)
        lst = last_re.search(line)
        # print (line.strip(), f"{matched_digit(fst.groups())}{matched_digit(lst.groups())}", sep='  ')
        sum += int(matched_digit(fst.groups()) + matched_digit(lst.groups()))
print(f"Part 2: The sum is {sum}")
