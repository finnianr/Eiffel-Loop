pyxis-doc:
	version = 1.0; encoding = "UTF-8"

# Testing UTF-8 encoding
translations:
	item:
		id = "{credits}"
		# first has no check
		translation:
			lang = de
			"""
				Yijing Tagebuch-Software für Linux, OSX und Windows.

				Entworfen und entwickelt durch Finnian Reilly.

				Copyright © 2010-2016 Finnian Reilly
			"""
		translation:
			lang = en
			"""
				Yijing Journal Software for Linux, OSX and Windows.

				Designed and developed by Finnian Reilly.

				Copyright © 2010-2016 Finnian Reilly
			"""
	item:
		id = "{title}"
		translation:
			lang = de; check = true
			"My Ching Version %S"
		translation:
			lang = en
			"My Ching Version %S"

	item:
		id = "{Apple}"
		translation:
			lang = de; check = true
			"Apple™"
		translation:
			lang = en
			"Apple™"

