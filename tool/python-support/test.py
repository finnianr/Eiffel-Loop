import os


class EIFFEL_CONFIG_FILE (object):

# Initialization
	def __init__ (self):
		self.keep_assertions = False

config = EIFFEL_CONFIG_FILE ()

config.keep_assertions = True

print "config.keep_assertions", config.keep_assertions
