def random_gen(seed, length):
    """
    Given the seed and the length of the number the method needs to simulate how it can create the uniformly distributed
    number given the randomly generated numbers from 0 through seed.
    :param seed: Number in range of 2 <= seed <= length - seed cannot be larger than the number that is needs to produce
    Number has to be mod 2
    :param length: length in bytes of new number
    :return: number of length
    """
    if seed < 2 or length < seed:
        raise TypeError("Error with seed %s and length %s" % (seed, length))

    
