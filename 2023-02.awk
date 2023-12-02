# Determine which games would have been possible if the bag had been loaded with only 12 red cubes, 13 green cubes, and 14 blue cubes. What is the sum of the IDs of those games?
#

BEGIN {
    total["red"] = 12
    total["green"] = 13
    total["blue"] = 14
    FS = ": "
}

{
    delete gid_pts
    split($1, gid_pts, " ")
    gid = gid_pts[2]

    # print gid ":"
    delete games
    impossible = 0
    this_total["red"] = 0
    this_total["green"] = 0
    this_total["blue"] = 0
    num_games = split($2, games, "; ")
    for (i = 1; i <= num_games; i++) {
        delete balls
        gsub(",", "", games[i])
        num_balls = split(games[i], balls, " ")
        for (j = 1; j <= num_balls; j = j + 2) {
            if (strtonum(balls[j]) > total[balls[j + 1]]) {
                # print balls[j] " > " total[balls[j + 1]] " " balls[j+1]
                impossible = 1
            }
            if (strtonum(balls[j]) > this_total[balls[j + 1]]) {
                this_total[balls[j + 1]] = strtonum(balls[j])
            }
        }
    }
    possible_score = possible_score + (1 - impossible)*gid
    if (!impossible) {
        imp_gids = imp_gids " " gid
    }
    sum_power = sum_power + this_total["red"] * this_total["green"] * this_total["blue"]
}

END {
    print "Part 1: The sum of possible game IDs is " possible_score
    print "Part 2: The sum of the power of each game is " sum_power
    # print "Possible games: " imp_gids
}
    
