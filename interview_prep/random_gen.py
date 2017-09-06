import random


def random_gen(seed, num):
    """
    The function generates the the random number using combination of smaller random numbers - has to be uniformly
    distributed
    :param seed: number of bytes the seed should be. has to be 1<= seed <= max
    :param max: how many bytes the new number has to be - should be mod 2
    :return: new number
    """

    if 0 > seed or num < seed:
        raise TypeError("Seed and number are not in range 1 <= seed <= num: seed %s, num %s" % (seed, num))

    result = 0
    while num != 0:
        upper = 2 ** seed - 1
        result = (result << seed) + random.randint(0, upper)
        num = num / seed
    return result


if __name__ == "__main__":
    seed = 2
    max = 8  # 2^8 = 256
    f = file("random_gen.csv", "w")
    with f:
        f.write("index, number(%s for 2^%s = %s)\n" % (seed, max, 2 ** max))
        for i in range(1, 50000):
            a = random_gen(seed, max)
            f.write("%s,%s,\n" % (i, a))
