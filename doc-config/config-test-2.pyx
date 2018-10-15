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
		# Examples
		ecf:
			"example/manage-mp3/manage-mp3.ecf"
		ecf:
			"library/Eco-DB.ecf"
			"library/vtd-xml.ecf"
		# Library Base
		ecf:
			cluster = data_structure
			"library/base/base.ecf"
		ecf:
			cluster = runtime
			"library/base/base.ecf"

		# Library (Text)
		ecf:
			"library/i18n.ecf"

