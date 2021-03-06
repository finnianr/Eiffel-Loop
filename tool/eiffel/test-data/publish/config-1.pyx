pyxis-doc:
	version = 1.0; encoding = "UTF-8"

# Configuration file for the Eiffel-View repository publisher

publish-repository:
	name = "Eiffel-Loop"; root-dir = "$EIFFEL_LOOP"; output-dir = "$EIFFEL_LOOP_DOC"
	web-address = "http://www.eiffel-loop.com"; github-url = "https://github.com/finnianr/eiffel-loop"
	ise-library = "https://www.eiffel.org/files/doc/static/18.01/libraries/%S/%S_chart.html"
	ise-contrib = "https://github.com/EiffelSoftware/EiffelStudio/blob/main/Src/contrib/"
	ftp-sync-path = "$EIFFEL_LOOP_DOC/ftp.sync"

	ftp-site:
		url = "ftp.eiffel-loop.com"; user-home = "/htdocs"

	templates:
		main = "main-template.html.evol"; eiffel-source = "eiffel-source-code.html.evol"
		site-map-content = "site-map-content.html.evol"; directory-content = "directory-tree-content.html.evol"
		favicon-markup = "favicon.markup"

	include-notes:
		note:
			"description"
			"descendants"
			"instructions"
			"notes"
			"tests"
			"warning"

	ecf-list:
		# Library Base
		ecf:
			"library/base/base.ecf#kernel"
			"library/base/base.ecf#math"
			"library/base/base.ecf#persistency"

		# Library (Persistence)
		ecf:
			"library/Eco-DB.ecf"
		# Library Text
		ecf:
			"library/public-key-encryption.ecf"

