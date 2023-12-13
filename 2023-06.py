# Determine the number of ways you could beat the record in each race. What do you get if you multiply these numbers together?

import sys
import math
import re


def wins(hold, time, distance):
    return (t - hold) * hold > distance


def ways_to_win(t, d):
    h_max = t / 2
    delta = abs(t ** 2 - 4 * d)
    h_exact = (t + math.sqrt(delta)) / 2
    interval = abs(h_max - h_exact)
    left_edge = int(round(h_max - interval))
    left_edge = left_edge if wins(left_edge, t, d) else left_edge + 1
    right_edge = int(round(h_max + interval))
    right_edge = right_edge if wins(right_edge, t, d) else right_edge - 1
    wtw = right_edge - left_edge + 1
    # print(f"For {t}ms, {d}mm, best is h={h_max}ms.")
    # print(f"Interval to win is [{h_max - interval}, {h_max + interval}] = {wtw} ways.")
    return wtw


with open(sys.argv[1]) as file:
    for line in file.readlines():
        if line.startswith("Time"):
            time = map(lambda x: int(x), re.split("\s+", line[5:].strip()))
            long_time = int(line[5:].replace(" ", ""))
        elif line.startswith("Distance"):
            distance = map(lambda x: int(x), re.split("\s+", line[9:].strip()))
            long_distance = int(line[9:].replace(" ", ""))


total_ways_to_win = 1
for t, d in zip(time, distance):
    total_ways_to_win *= ways_to_win(t, d)
print("Part 1: There are ", total_ways_to_win, "ways to win.")
print("Part 2: There are ", ways_to_win(long_time, long_distance), " ways to win the long race.")

