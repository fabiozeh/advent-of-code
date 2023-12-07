# What is the lowest location number that corresponds to any of the initial seed numbers?

function put_handling_collision(idx, val, arr) {
    if (idx in arr) {
        # print "collision on " idx
        if (arr[idx] < val) {
            arr[idx] = val
            return val
        }
        else return arr[idx]
    }
    else {
        arr[idx] = val
    }
    return val
}


function mapthings_vec(source, dest, map, lenmap,          extra_src, extra_src_start, extra_src_len, src, src_str, dst, range, range_str) {
    PROCINFO["sorted_in"] = "@ind_num_desc"
    for (src_str in source) { # for each <start of range> of thing...
        src = strtonum(src_str)
        dst = -1
        # printf("    %d/%d",src, source[src])
        for (range_str in map) {
            range = strtonum(range_str)
            if (range <= src) {
                if (src - range < (lenmap[range])) {  # this mapping range fits
                    dst = src - range + map[range]
                    if (src + source[src] > range + lenmap[range]) {  # but not for the whole range of <thing>
                        # include another range for next pass
                        extra_src_start = range + lenmap[range]
                        extra_src_len = put_handling_collision(extra_src_start, src + source[src] - (range + lenmap[range]), extra_src)
                        put_handling_collision(dst, source[src] - extra_src_len, dest)
                    }
                    else put_handling_collision(dst, source[src], dest)
                    break
                }
                else break  # no other range will fit
            }
        }
        if (dst == -1) put_handling_collision(src, source[src], dest)
    }
    if (length(extra_src) > 0) {
        # print "..."
        mapthings_vec(extra_src, dest, map, lenmap)
    }
}

function findloc_vec(seed, location,          soil, fertilizer, water, light, temperature, humidity) {
    mapthings_vec(seed, soil, map["seed-to-soil"], maplen["seed-to-soil"])
    mapthings_vec(soil, fertilizer, map["soil-to-fertilizer"], maplen["soil-to-fertilizer"])
    mapthings_vec(fertilizer, water, map["fertilizer-to-water"], maplen["fertilizer-to-water"])
    mapthings_vec(water, light, map["water-to-light"], maplen["water-to-light"])
    mapthings_vec(light, temperature, map["light-to-temperature"], maplen["light-to-temperature"])
    mapthings_vec(temperature, humidity, map["temperature-to-humidity"], maplen["temperature-to-humidity"])
    mapthings_vec(humidity, location, map["humidity-to-location"], maplen["humidity-to-location"])
    # print length(seed) " " length(soil) " " length(fertilizer) " " length(water) " " length(light) " " length(temperature) " " length(humidity) " " length(location)
}

/^seeds:/ {
    sub(/^seeds: /, "")
    for (i = 1; i <= NF; i++) {
        seeds[$i] = 1
        if (i % 2 == 0) {
            seed_range[$(i-1)] = $i
        }
    }
}

/^[[:alpha:]-]+ map/ {
    section = $1
}

/^[[:digit:]]/ {
    map[section][$2] = strtonum($1)
    maplen[section][$2] = strtonum($3)
}

END {

    # pluck the holes in the maps!
    PROCINFO["sorted_in"] = "@ind_num_desc"
    delete new_entries
    for (section in map) {
        if (length(section) < 2)
            continue
        for (start in map[section]) {
            max_block_start = strtonum(start)
            break
        }
        tracker = 0
        while (tracker < (max_block_start + maplen[section][max_block_start])) {
            mapped = 0
            prev_start = -1
            for (bl_start_str in map[section]) {
                bl_start = strtonum(bl_start_str)
                bl_len = strtonum(maplen[section][bl_start])
                if (bl_start <= tracker) {
                    if (tracker - bl_start < bl_len) {
                        tracker = bl_start + bl_len
                    }
                    else {
                        new_entries[section][tracker] = prev_start - tracker
                        tracker = prev_start
                    }
                    mapped = 1
                    break
                }
                prev_start = bl_start
            }
            if (! mapped) {
                new_entries[section][tracker] = prev_start - tracker
                tracker = prev_start
            }
        }
    }
    for (section in new_entries) {
        # print length(new_entries[section]) " new entries in " section
        for (entry in new_entries[section]) {
            map[section][entry] = strtonum(entry)
            maplen[section][entry] = new_entries[entry]
        }
        # print "section " section " has " length(map[section]) " rules."
    }

    # for (s in seed_range) {
    #     print "seed: " s "/" seed_range[s]
    # }

    findloc_vec(seeds, final_loc)

    PROCINFO["sorted_in"] = "@ind_num_asc"
    for (l in final_loc) { min_location = l; break }
    print "Part 1: The closest location is " min_location

    delete final_loc
    findloc_vec(seed_range, final_loc)

    PROCINFO["sorted_in"] = "@ind_num_asc"
    for (l in final_loc) { min_location = l; break }
    print "Part 2: The closest location is " min_location
}
