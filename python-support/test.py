for i in range(32):
	print ((1<<i)*0x04D7651F >> 27 & 0x1F),

print

d = {(1<<i)*0x04D7651F >> 27 & 0x1F: i for i in range(32)}

print d

for key, value in d.iteritems ():
	print value,



