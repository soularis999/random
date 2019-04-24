import matplotlib.pyplot as plt

from bs_pricer import price, strike_from_delta

# def graph_fly(type, price, underling, strike, irate, div, time):


def plot(xData, xLabel, data, mapper):
    """
    Given data resulted from bspricer and the mapper 
    that is taking individual value tuple and positio related to graphing performed
    plot the graph
    """

    # value
    yLabel = "Value"
    plt.plot(xData, list(map(lambda vals: mapper(vals, 1), data)))
    plt.title("%s vs %s" % (yLabel, xLabel))
    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.show()

    # delta
    yLabel = "Delta"
    plt.plot(xData, list(map(lambda vals: mapper(vals, 2), data)))
    plt.title("%s vs %s" % (yLabel, xLabel))
    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.show()

    # gamma
    yLabel = "Gamma"
    plt.plot(xData, list(map(lambda vals: mapper(vals, 3), data)))
    plt.title("%s vs %s" % (yLabel, xLabel))
    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.show()

    # vega
    yLabel = "Vega"
    plt.plot(xData, list(map(lambda vals: mapper(vals, 4), data)))
    plt.title("%s vs %s" % (yLabel, xLabel))
    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.show()

    # theta
    yLabel = "Theta"
    plt.plot(xData, list(map(lambda vals: mapper(vals, 5), data)))
    plt.title("%s vs %s" % (yLabel, xLabel))
    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.show()

    # rho
    yLabel = "Rho"
    plt.plot(xData, list(map(lambda vals: mapper(vals, 6), data)))
    plt.title("%s vs %s" % (yLabel, xLabel))
    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.show()


def graph_fly(underling, strikes, vol, irate, div, time):
    """
    Long butterfly spreads are entered when the investor thinks that the underlying stock
    will not rise or fall much by expiration. Using calls, the long butterfly can be constructed
    by buying one lower striking in-the-money call, writing two at-the-money calls and buying
    another higher striking out-of-the-money call. A resulting net debit is taken to enter the trade.
    """
    max = int(underling * 10 * (vol / 100))
    min = 1

    data = []
    underl_price = range(min, max)
    for sample in underl_price:
        # (data, value, delta, gamma, vega, theta, rho)
        itm_call = price("C", sample, strikes[0], vol, irate, div, time)
        atm_call = price("C", sample, strikes[1], vol, irate, div, time)
        otm_call = price("C", sample, strikes[2], vol, irate, div, time)
        data.append((itm_call, atm_call, otm_call))

    plot(underl_price, "Underlying price", data, lambda val,
         pos: val[0][pos] - 2 * val[1][pos] + val[2][pos])


def graph_straddle(underling, strikes, vol, irate, div, time):
    """
    Long butterfly spreads are entered when the investor thinks that the underlying stock
    will not rise or fall much by expiration. Using calls, the long butterfly can be constructed
    by buying one lower striking in-the-money call, writing two at-the-money calls and buying
    another higher striking out-of-the-money call. A resulting net debit is taken to enter the trade.
    """
    max = int(underling * 10 * (vol / 100))
    min = 1

    data = []
    xData = range(min, max)
    for sample in xData:
        # (data, value, delta, gamma, vega, theta, rho)
        call = price("C", sample, strikes[0], vol, irate, div, time)
        put = price("P", sample, strikes[1], vol, irate, div, time)
        data.append((call, put))

    plot(xData, "Underlying price", data,
         lambda val, pos: val[0][pos] + val[1][pos])

    # plot with respect to time
    max = time
    min = 1
    data = []
    xData = range(min, max)
    for sample in xData:
        # (data, value, delta, gamma, vega, theta, rho)
        call = price("C", underling, strikes[0], vol, irate, div, sample)
        put = price("P", underling, strikes[1], vol, irate, div, sample)
        data.append((call, put))

    plot(xData, "Time", data, lambda val, pos: val[0][pos] + val[1][pos])

    # plot with respect to vol
    max = int(vol * 10)  # 10 times increase of vol
    min = 1
    data = []
    xData = range(min, max)
    for sample in xData:
        # (data, value, delta, gamma, vega, theta, rho)
        call = price("C", underling, strikes[0], sample, irate, div, time)
        put = price("P", underling, strikes[1], sample, irate, div, time)
        data.append((call, put))

    plot(xData, "Vol", data, lambda val, pos: val[0][pos] + val[1][pos])

    # plot with respect to interest rate
    max = int(irate * 100)  # 10 times increase of vol
    min = 1
    data = []
    xData = range(min, max)
    for sample in xData:
        # (data, value, delta, gamma, vega, theta, rho)
        call = price("C", underling, strikes[0], vol, sample, div, time)
        put = price("P", underling, strikes[1], vol, sample, div, time)
        data.append((call, put))

    plot(xData, "Interest Rate", data, lambda val,
         pos: val[0][pos] + val[1][pos])


def graph_riskrev(underling, call_delta, put_delta, vol, irate, div, time):

    print(underling, call_delta, put_delta, vol, irate, div, time)
    # (data, value, delta, gamma, vega, theta, rho)
    call_strike = strike_from_delta("C", call_delta, underling, vol, irate, div, time)
    print("Delta call: for %s with underlying %s = %s" % (call_delta, underling, call_strike))
    put_strike = strike_from_delta("P", put_delta, underling, vol, irate, div, time)
    print("Delta put: for %s with underlying %s = %s" % (put_delta, underling, put_strike))


    # max = int(underling * 10 * (vol / 100))
    # min = 1

    # data = []
    # xData = range(min, max)
    # for sample in xData:
    #     call = price("C", sample, call_strike, vol, irate, div, time)
    #     put = price("P", sample, put_strike, vol, irate, div, time)
    #     data.append((call, put))
    
    # plot(xData, "Underlying Rate", data, lambda val,
    #      pos: -1 * val[0][pos] + val[1][pos])

    # plot with respect to interest rate
    # max = int(irate * 100)  # 10 times increase of vol
    # min = 1
    # data = []
    # xData = range(min, max)
    # for sample in xData:
    #     call = price("C", underling, call_strike, vol, sample, div, time)
    #     put = price("P", underling, put_strike, vol, sample, div, time)
    #     data.append((call, put))
    
    # plot(xData, "Interest Rate", data, lambda val,
    #      pos: -1 * val[0][pos] + val[1][pos])

    # plot with respect to vol
    # max = int(vol * 10)  # 10 times increase of vol
    # min = 1
    # data = []
    # xData = range(min, max)
    # for sample in xData:
    #     # (data, value, delta, gamma, vega, theta, rho)
    #     call = price("C", underling, call_strike, sample, irate, div, time)
    #     put = price("P", underling, put_strike, sample, irate, div, time)
    #     data.append((call, put))

    # plot(xData, "Vol", data, lambda val, pos: val[0][pos] + val[1][pos])

        # plot with respect to time
    max = time
    min = 1
    data = []
    xData = range(min, max)
    for sample in xData:
        # (data, value, delta, gamma, vega, theta, rho)
        call = price("C", underling, call_strike, vol, irate, div, sample)
        put = price("P", underling, put_strike, vol, irate, div, sample)
        data.append((call, put))

    plot(xData, "Time", data, lambda val, pos: val[0][pos] + val[1][pos])

if __name__ == "__main__":
    # graph_fly(100.0, [90.0, 100.0, 110.0], 30.0, 10.0, 0.0, 90)
    # graph_straddle(100.0, [100.0, 100.0], 30.0, 10.0, 0.0, 365)
    graph_riskrev(100.0, 25, 25, 30.0, 10.0, 0.0, 365)