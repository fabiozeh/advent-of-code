import sys
import re
import logging

# logging.basicConfig(level=logging.DEBUG)

seeds = []
maps = {}
section = ""
maps_regex = re.compile(r"([\w-]+) map:")
nums_regex = re.compile(r"^\d+")
with open(sys.argv[1]) as file:
    for line in file.readlines():
        m = maps_regex.search(line)
        if line.startswith("seeds:"):
            pt1_seeds = list(map(lambda x: int(x), line[7:].split(" ")))
            for i, s in enumerate(pt1_seeds):
                if (i % 2 == 1):
                    seeds.append({
                        "seed": pt1_seeds[i - 1],
                        "range": s,
                    })
        elif m:
            section = m.group(1)
        elif nums_regex.search(line):
            fields = line.split(" ")
            section_map = maps.get(section) or []
            maps[section] = section_map + [(int(fields[1]), int(fields[2]), int(fields[0]))]


for k in maps:
    m = maps[k]
    logging.debug(f"{k} has {len(m)} rules.")
    m.sort(reverse=True, key=lambda x: x[0])

    # plug holes! (include identity mappings in missing ranges)
    new_entries = []
    tracker = 0
    while (tracker < m[0][0] + m[0][1]):
        mapped = False
        prev_start = -1  # keep track of the lower end of previous block
        for block_start, block_len, block_dst in m:
            if block_start <= tracker:
                if tracker - block_start < block_len:
                    # already mapped
                    tracker = block_start + block_len
                else:
                    # we skipped a hole!
                    new_entries.append((tracker, prev_start - tracker, tracker))
                    tracker = prev_start
                mapped = True
                break  # check next interval
            prev_start = block_start
        if not mapped:
            # a hole in the bottom
            new_entries.append((tracker, prev_start - tracker, tracker))
            tracker = prev_start
    logging.debug(f"Mapping {len(new_entries)} holes in {k}:")
    for s, l, d in new_entries:
        logging.debug(f"  {s}/{l}:{d}")
    maps[k] = m + new_entries
    maps[k].sort(reverse=True, key=lambda x: x[0])


def mapthing(thing, idx, nxt_idx):
    thing = thing.copy()
    m = maps[idx + "-to-" + nxt_idx]
    for block_start, block_len, block_dst in m:
        if block_start <= thing[idx]:
            # either we're in the right block or the right block is not mapped
            if thing[idx] - block_start < block_len:  # we're in the right block
                if thing[idx] + thing["range"] > block_start + block_len:
                    logging.debug(f"A split {idx}: {thing[idx]}/{thing['range']}"
                                  f"in {block_start} to {block_start + block_len}...")
                    new_thing = thing.copy()
                    new_thing[idx] = block_start + block_len
                    new_thing["range"] = thing[idx] + thing["range"] - (block_start + block_len)
                    thing[nxt_idx] = block_dst + thing[idx] - block_start
                    thing["range"] = thing["range"] - new_thing["range"]
                    logging.debug(f"{thing[idx]}/{thing['range']}"
                                  f" + {new_thing[idx]}/{new_thing['range']}")
                    return [thing] + mapthing(new_thing, idx, nxt_idx)
                else:
                    thing[nxt_idx] = block_dst + thing[idx] - block_start
                    return [thing]
            else:
                #  The right block is not mapped
                if thing[idx] >= m[0][0] + m[0][1]:
                    logging.debug("Mapping above the limit. This is fine.")
                else:
                    logging.debug("The right block is a hole -- This is a problem.")
                logging.debug(f"{idx} to {nxt_idx}, {thing[idx]}/{thing['range']}"
                              f" @{block_start}/{block_len}")
                thing[nxt_idx] = thing[idx]
                return [thing]
    if thing[idx] < m[-1][0]:
        logging.debug("We left the loop and we're below all mappings. This is a problem.")
    else:
        logging.debug("We left the loop and we shouldn't have. This is a problem.")
    thing[nxt_idx] = thing[idx]
    return [thing]


def min_loc(seed_list):
    process = ["seed", "soil", "fertilizer", "water", "light",
               "temperature", "humidity", "location"]
    aux = seed_list
    for step, _ in enumerate(process[:-1]):
        aux = [e for k in map(
            lambda x: mapthing(x, process[step], process[step + 1]), aux) for e in k]

    dbgstr = ""
    for i in aux:
        for step in process[:-1]:
            dbgstr += f"{i[step]}   "
        dbgstr += f"{i[process[-1]]}\n"
    logging.debug(dbgstr)

    return min(list(map(lambda x: x["location"], aux)))


pt1_seeds = list(map(lambda x: {"seed": x, "range": 1}, pt1_seeds))
print(f"Part 1: The closest location is {min_loc(pt1_seeds)}")
dbgstr = "Seeds: \n"
for s in seeds:
    dbgstr += f"{s['seed']}/{s['range']}\n"
logging.debug(dbgstr)
print(f"Part 2: The closest location is {min_loc(seeds)}")

