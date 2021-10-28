pyxis-doc:
	version = 1.0; encoding = "UTF-8"
	
# class EL_UNINSTALL_TEXTS

translations:
	item:
		id = "{uninstall-application}"
		translation:
			lang = de; check = false
			"Anwendung deinstallieren"
		translation:
			lang = en
			"Uninstall %S application"

	item:
		id = "{uninstall-x}"
		translation:
			lang = de; check = false
			"Deinstallieren %S"
		translation:
			lang = en
			"Uninstall %S"
	item:
		id = "{uninstalling}"
		translation:
			lang = de; check = true
			"Deinstalliere:"
		translation:
			lang = en
			"Uninstalling:"

	# CONTEXT EG.
	# Uninstall: "My application"
	item:
		id = "Uninstall"
		translation:
			lang = de; check = false
			"Deinstallieren"
		translation:
			lang = en
			"$id"

	item:
		id = "{uninstall-confirmation}"
		translation:
			lang = de; check = true
			"Wenn Sie sicher sind, drücken Sie 'j' und <Return>:"

		translation:
			lang = en
			"If you are sure press 'y' and <return>:"

	item:
		id = "{remove-all-data-prompt}"
		translation:
			lang = de; check = false
			"Lösche Daten und Konfigurationsdateien für alle %S Benutzer (j/n)"
		translation:
			lang = en
			"Delete data and configuration files for all %S users (y/n)"

	item:
		id = "{uninstall-warning}"
		translation:
			lang = de; check = true
			"DIESE AKTION WIRD PERMANENT ALLE IHRE DATEN LÖSCHEN."
		translation:
			lang = en
			"THIS ACTION WILL PERMANENTLY DELETE ALL YOUR DATA."

	# Uninstall script
	item:
		id = "Removing program files"
		translation:
			lang = de; check = false
			"Entfernen von Programmdateien"
		translation:
			lang = en
			"$id"

	item:
		id = "{app-removed-template}"
		translation:
			lang = de; check = false
			"""
				"%S" entfernt.
			"""
		translation:
			lang = en
			"""
				"%S" removed.
			"""




