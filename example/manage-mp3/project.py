# EiffelStudio project environment

from eiffel_loop.project import *

major_version = 1

minor_version = 1

installation_sub_directory = 'Eiffel-Loop/manage-mp3'

tests = TESTS ('$EIFFEL_LOOP/projects.data')
tests.append (['-test_rhythmbox_read_write', '-logging'])
