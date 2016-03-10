# EiffelStudio project environment

from eiffel_loop.project import *

version = (1, 2, 6)

installation_sub_directory = 'Eiffel-Loop/manage-mp3'

tests = TESTS ('$EIFFEL_LOOP/projects.data')
tests.append (['-test_rhythmbox_read_write', '-logging'])

# 1.2.6
# Read exported playlists directory before publishing
# Save ignore attribute in exported playlist

# 1.2.5
# Fixed escaping of Unix paths in shell commands

# 1.2.4
# Fixed saving of DJ event lists with X before unplayed songs

# 1.2.3
# Detects Rhythmbox. Fixed volume sync deletions. Put tanda number in playlist song info.
# Changed Tanda naming to A. <GENRE> Tanda ****
