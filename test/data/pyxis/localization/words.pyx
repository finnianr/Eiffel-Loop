pyxis-doc:
	version = 1.0; encoding = "ISO-8859-15"

# Testing ISO-8859-15 encoding in EL_MERGED_PYXIS_LINE_LIST

translations:
	item:
		id = "{¤}"
		# first has no check
		translation:
			lang = de
			"Eurozeichen"
		translation:
			lang = en
			"Euro Currency Sign"

	item:
		id = "{¾½}"
		translation:
			lang = de; check = true
			"Latin-15 Zeichen"
		translation:
			lang = en
			"Latin-15 characters"

	item:
		id = "Nighttime"
		translation:
			lang = de; check = true
			"Nachts"

