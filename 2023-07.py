# Find the rank of every hand in your set. What are the total winnings?

import sys


def worth(a, joker=False):
    a_cards = {}
    pts = 0
    figs = {
        'A': 12,
        'K': 11,
        'Q': 10,
        'J': 0 if joker else 9,
        'T': 9 if joker else 8
    }
    card_offset_value = -1 if joker else -2
    for i, c in enumerate(list(a)):
        if c in figs.keys():
            pts += figs[c] * 13 ** (4 - i)
        else:
            pts += (int(c) + card_offset_value) * 13 ** (4 - i)

        if c in a_cards:
            a_cards[c] += 1
        else:
            a_cards[c] = 1
    joker_amount = 0
    if joker and 'J' in a_cards:
        joker_amount = a_cards.pop('J')
    hand_type = sorted(a_cards.values(), reverse=True) + [0, 0]
    pts += (hand_type[0] + joker_amount) * 13 ** 6 + hand_type[1] * 13 ** 5
    return pts


hands = []
with open(sys.argv[1]) as file:
    for line in file.readlines():
        fields = line.split(" ")
        hands.append((fields[0], int(fields[1])))

winnings = 0
for i, (hand, bid) in enumerate(sorted(hands, key=lambda x: worth(x[0]))):
    # print("hand:", hand, "rank:", i + 1, "bid:", bid, "hand's worth:", worth(hand))
    winnings += (i + 1) * bid

print("Part 1: The winnings total ", winnings)

winnings = 0
for i, (hand, bid) in enumerate(sorted(hands, key=lambda x: worth(x[0], True))):
    # print("hand:", hand, "rank:", i + 1, "bid:", bid, "hand's worth:", worth(hand, True))
    winnings += (i + 1) * bid
print("Part 2: The winnings total ", winnings)
