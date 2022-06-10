extends Node

# Named "Count" in Autoload

var counters = {}
func count(key):
	if not counters.has(key):
		make(key)
	increment(key)
func make(keys):
	if keys is Array: make_counters(keys)
	else: make_counter(keys)
func make_counters(keys:Array):
	for key in keys:
		counters[key] = 0
func make_counter(key):
	counters[key] = 0
func increment(key, amount=1):
	counters[key] += int(amount)
func decrement(key, amount=1):
	counters[key] -= int(amount)
func peeks(keys:Array):
	for key in keys: peek(key)
func peek(key):
	print(key, ": ", counters[key])
func peek_all():
	for key in counters.keys():
		peek(key)
func pops(keys:Array):
	for key in keys: pop(key)
func pop(key):
	print(key, ": ", counters[key])
	counters[key] = 0
func pop_all():
	for key in counters.keys():
		pop(key)
