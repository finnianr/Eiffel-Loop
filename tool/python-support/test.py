import os

from eiffel_loop.eiffel import ise

print 'ise.platform', ise.platform

os.environ ['ISE_PLATFORM'] = 'win64'

ise.update ()

print 'ise.platform', ise.platform

