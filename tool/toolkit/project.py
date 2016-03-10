# EiffelStudio project environment

from eiffel_loop.project import *

version = (1, 1, 7)
# 1.1.2
# Fixed handling of verbatim strings so they do not confused with class features

installation_sub_directory = 'Eiffel-Loop/utils'

tests = TESTS ('$EIFFEL_LOOP/projects.data')
tests.append (['-test_editors', '-logging'])

# 1.1.7
# Added Pyxis compiler

# 1.1.6
# Added optional folder inclusion lists to Thunderbird mail exports

# 1.1.4
# New command decrypt file with AES encryption

# 1.1.3
# Fixed THUNDERBIRD_MAIL_TO_HTML_BODY_CONVERTER.write_html to only update h2 files if body changes
