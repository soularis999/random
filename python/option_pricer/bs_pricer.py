from math import log, sqrt, pi, exp, pow
from collections import namedtuple
from scipy.stats import norm

DATA = namedtuple(
    "DATA", "underling strike adj_rate adj_div adj_rate_and_div adj_vol adj_time type_mult")


def _clean_and_adjust_data(type, underling, strike, vol, irate, div, time):
    adj_rate = irate / 100
    adj_div = div / 100
    adj_rate_and_div = adj_rate - adj_div
    adj_vol = vol / 100
    adj_time = time / 365
    mult = 1 if type == 'C' else -1

    return DATA(underling, strike, adj_rate, adj_div, adj_rate_and_div, adj_vol, adj_time, mult)


def _d1(underling, strike, vol, rate, time):
    v1 = log(underling/strike)
    v2 = (rate + (vol * vol) / 2.0) * time
    v3 = vol * sqrt(time)
    return (v1 + v2) / v3

def _d2(underling, strike, vol, rate, time):
    return _d1(underling, strike, vol, rate, time) - vol * sqrt(time)

def _price(data):
    d1 = _d1(data.underling, data.strike, data.adj_vol,
             data.adj_rate_and_div, data.adj_time)
    d2 = _d2(data.underling, data.strike, data.adj_vol,
             data.adj_rate_and_div, data.adj_time)

    nd1 = norm.cdf(data.type_mult * d1)
    nd2 = norm.cdf(data.type_mult * d2)

    adj_underl = data.type_mult * data.underling * nd1
    adj_strike = data.type_mult * data.strike * \
        exp(-data.adj_rate * data.adj_time) * nd2

    price = adj_underl - adj_strike
    delta = exp(data.adj_rate_and_div * data.adj_time) * data.type_mult * nd1
    rho = data.type_mult * data.strike * data.adj_time * \
        exp(-1 * data.adj_rate * data.adj_time) * nd2

    return (price, delta, rho)


def price(type, underling, strike, vol, irate, div, time):
    """
    @param type - C or P for call or put
    @param underling - underling
    @param strike - strike
    @param vol in percent - will be divided by 100
    @param irate interest rate in percent - will be divided by 100
    @param div dividends in percent - will be divided by 100
    @param time in days - will be divided by 365

    @return (data, value, delta, gamma, vega, theta, rho)
    """
    data = _clean_and_adjust_data(
        type, underling, strike, vol, irate, div, time)

    calc1 = _price(data)
    # with 0.01 price increase - approximation
    data2 = _clean_and_adjust_data(
        type, underling + 0.01, strike, vol, irate, div, time)
    calc2 = _price(data2)

    # approximate gamma as change of delta over change on 1 cent
    gamma = (calc2[1] - calc1[1]) / 0.01

    # vega is underling ^ 2 * sigma * t * gamma
    vega = data.underling * data.underling * data.adj_vol * data.adj_time * gamma

    # theta
    theta = -0.5 * data.underling * data.underling * data.adj_vol * data.adj_vol * gamma - \
        data.adj_rate * data.underling * calc1[1] + data.adj_div * calc1[0]

    return (data, calc1[0], calc1[1], gamma, vega, theta, calc1[2])


def put_call(type, price, underling, strike, irate, div, time):
    """
    # ------------------------------------------
    # Calculate call price, using put-call parity
    # ------------------------------------------
    #  type - tye of price 'P' or 'C' for put or call
    #  price - option price
    #  underling - current equity price
    #  strike - option strike price
    #  irate pct - interest rate in percent - will be adjusted by 100
    #  div - dividend in percent - will be adjusted by 100
    #  time - time in days - will be adjusted by 365
    """
    adj_rate = (irate - div) / 100
    adj_time = time / 365

    mult = 1 if type == 'C' else -1
    adj_strike = mult * strike * exp(-adj_rate * adj_time)
    adj_under = mult * underling
    return adj_strike + price - adj_under

def strike_from_delta(type, delta, underling, vol, irate, div, time):
    """
    # ------------------------------------------
    # Calculate strike given delta and other attributes
    # ------------------------------------------
    #  type - tye of price 'P' or 'C' for put or call
    #  price - option price
    #  underling - current equity price
    #  strike - option strike price
    #  vol - volatility
    #  irate pct - interest rate in percent - will be adjusted by 100
    #  div - dividend in percent - will be adjusted by 100
    #  time - time in days - will be adjusted by 365
    """
    data = _clean_and_adjust_data(type, underling, 0, vol, irate, div, time)
    delta = delta/100
    delta = delta if type is "C" else -1 * delta

    div = exp(data.adj_rate_and_div * data.adj_time) * data.type_mult
    adj_delta = delta / div
    d1 = norm.ppf(adj_delta) / data.type_mult

    v2 = (data.adj_rate_and_div + (data.adj_vol * data.adj_vol) / 2.0) * data.adj_time
    v3 = data.adj_vol * sqrt(data.adj_time)

    return underling / exp(d1 * v3 - v2)


if __name__ == "__main__":
    call_results = price('C', 50, 52.28, 10, 5, 0, 270)
    print("Call: data,%s,price,%s,delta,%s,gamma,%s,vega,%s,theta,%s,rho,%s" % call_results)
    put_results = price('P', 50, 51.87, 10, 5, 0, 270)
    print("Put: data,%s,price,%s,delta,%s,gamma,%s,vega,%s,theta,%s,rho,%s" % put_results)

    calc_put = put_call('C', call_results[1], 50, 50, 5, 0, 270)
    print("Put call parity: call price %s results in put %s" %
          (call_results[0], calc_put))

    calc_call = put_call('P', put_results[1], 50, 50, 5, 0, 270)
    print("Put call parity: put price %s results in put %s" %
          (put_results[0], calc_call))

    delta = 50
    strike = strike_from_delta('C', delta, 50, 10, 5, 0, 270)
    print("Call Strike from delta %s = %s" % (delta, strike))

    strike = strike_from_delta('P', delta, 50, 10, 5, 0, 270)
    print("Put Strike from delta %s = %s" % (delta, strike))
