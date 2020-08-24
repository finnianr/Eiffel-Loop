pyxis-doc:
	version = 1.0; encoding = "ISO-8859-1"

# Testing ISO-8859-1 encoding

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
		id = "Delete journal"
		translation:
			lang = de; check = true
			'Löschen tagebuch: "%S"\nSind sie sicher?'
		translation:
			lang = en
			'Delete journal: "%S"\nAre you sure?'

	item:
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
		id = "&New entry"
		translation:
			lang = de; check = true
			"&Neuer eintrag\tCtrl-T"
		translation:
			lang = en
			"&New entry\tCtrl-T"

