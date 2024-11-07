pyxis-doc:
	version = 1.0; encoding = "ISO-8859-1"

# class TEST_PHRASES_TEXT
# Testing ISO-8859-1 encoding in EL_MERGED_PYXIS_LINE_LIST

translations:
	item:
		id = "Enter a passphrase"
		# first has no check
		translation:
			lang = de
			'Geben sie ein passphrase für "$NAME" tagebuch'
		translation:
			lang = en
			'Enter a passphrase for "$NAME" journal'

	item:
		id = "{delete_journal}"
		translation:
			lang = de; check = true
			'Löschen tagebuch: "%S"\nSind sie sicher?'
		translation:
			lang = en
			'Delete journal: "%S"\nAre you sure?'

	item:
		# Test key normalization with underscores
		id = "{for-n-years}"
		translation:
			lang = de; check = true
			singular:
				"für $QUANTITY Jahr"
			plural:
				"für $QUANTITY Jahre"
				
		translation:
			lang = en
			singular:
				"for $QUANTITY year"
			plural:
				"for $QUANTITY years"

	item:
		id = "{new_entry}"
		translation:
			lang = de; check = true
			"&Neuer eintrag\tCtrl-T"
		translation:
			lang = en
			"&New entry\tCtrl-T"
	
	# Test escaping single quote
	item:
		id = "{taoistiching}"
		translation:
			lang = de
			'Walther Sells Interpretation des "taoistischen I Ging"'
		translation:
			lang = en
			'Walther Sell\'s "The Taoist I Ching" Interpretation'

