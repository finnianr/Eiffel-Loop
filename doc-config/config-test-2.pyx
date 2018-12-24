pyxis-doc:
	version = 1.0; encoding = "UTF-8"

# Configuration file for the Eiffel-View repository publisher

publish-repository:
	name = "Eiffel-Loop"; root-dir = "$EIFFEL_LOOP"; output-dir = "$EIFFEL_LOOP_DOC"
	web-address = "http://www.eiffel-loop.com"; github-url = "https://github.com/finnianr/eiffel-loop"

	ftp-site:
		url = "eiffel-loop.com"; user-home = "/public/www"; sync-path = "$EIFFEL_LOOP_DOC/ftp.sync"

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
			"warning"

	ecf-list:
		# Library Base
		ecf:
			"library/base/base.ecf#data_structure"
			"library/base/base.ecf#math"
			"library/base/base.ecf#persistency"

		# Library (Text)
		ecf:
			"library/i18n.ecf"

