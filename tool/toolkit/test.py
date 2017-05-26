import os
from eiffel_loop.os import path

var_eiffel = 'EIFFEL'
if var_eiffel in os.environ:
	eiffel_basename = path.basename (os.environ [var_eiffel])

print eiffel_basename
