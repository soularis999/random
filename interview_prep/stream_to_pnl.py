###
# Given a stream of prices find out the max profit
# price 6 5 4 5 6 7 8 7 6
# pnl   0 0 0 1 2 3 4 4 4
###

prev = 0
def calc(arr):
	def calc_func(total, val):
		print val, " ", prev, " ", total

		global prev
		if 0 == prev:
			prev = val
			return 0

		if prev < val:
			total += val - prev

		prev = val
		return total

	return reduce(calc_func, arr, 0)

if __name__=='__main__':
	print calc([])
	print calc([6])
	print calc([6,5,4])
	print calc([6,5,4,5,6,7,8,7,6])
	print calc([6,5,4,5,6,7,8,7,6,7,8,9,10])