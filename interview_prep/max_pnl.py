def max_pnl(stream):
    """
    The script calculates the max profit if we can only buy or sell given a stream of prices if we can only buy or sell one time
    """
    small = None
    diff = None
    if not stream or len(stream) < 2:
        return None

    for item in stream:
        if small and (not diff or item - small > diff):
            diff = item - small

        if not small or item < small:
            small = item

    return diff


if __name__ == "__main__":
    assert not max_pnl([])
    assert not max_pnl([1])
    assert -1 == max_pnl([9, 8]), "%s != %s" % (-1, max_pnl([9, 8]))
    assert 0 == max_pnl([8, 8]), "%s != %s" % (-1, max_pnl([9, 8]))
    assert 1 == max_pnl([8, 9]), "%s != %s" % (-1, max_pnl([9, 8]))
    assert 2 == max_pnl([8, 9, 10, 9, 8]), "%s != %s" % (-1, max_pnl([9, 8]))
    assert 3 == max_pnl([8, 7, 6, 5, 8]), "%s != %s" % (-1, max_pnl([9, 8]))
    assert 5 == max_pnl([8, 7, 6, 5, 8, 9, 10, 9, 5, 1]), "%s != %s" % (-1, max_pnl([9, 8]))
