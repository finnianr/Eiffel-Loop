# EiffelStudio project environment

from eiffel_loop.project import *

version = (1, 1, 10)
# 1.1.2
# Fixed handling of verbatim strings so they do not confused with class features

installation_sub_directory = 'Eiffel-Loop/utils'

tests = TESTS ('$EIFFEL_LOOP/projects.data')
tests.append (['-test_editors', '-logging'])

# 1.1.10
# Fixed EIFFEL_CLASS_LIBRARY_MANIFEST_APP. Added indent handling routines to EL_STRING_GENERAL_CHAIN.

# 1.1.9
# Uses ZSTRING
# Codec generator modified for ZSTRING
# Missing BOM in Evolicity merge

# 1.1.8
# Changed output of pyxis compiler to use EL_UTF_8_TEXT_IO_MEDIUM

# 1.1.7
# Added Pyxis compiler

# 1.1.6
# Added optional folder inclusion lists to Thunderbird mail exports

# 1.1.4
# New command decrypt file with AES encryption

# 1.1.3
# Fixed THUNDERBIRD_MAIL_TO_HTML_BODY_CONVERTER.write_html to only update h2 files if body changes
