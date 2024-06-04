pyxis-doc:
	version = 1.0; encoding = "UTF-8"

# Configuration file for the Eiffel-View repository publisher

publish-repository:
	test_mode = true; name = "Eiffel-Loop"; root_dir = "workarea"; output_dir = "workarea/doc"
	web_address = "http://www.eiffel-loop.com"; github_url = "https://github.com/finnianr/eiffel-loop/tree/master"
	invalid_names_output_path = "invalid-name-references.e"

	ise_library = "https://www.eiffel.org/files/doc/static/18.01/libraries/%S/%S_chart.html"
	ise_contrib = "https://github.com/EiffelSoftware/EiffelStudio/blob/main/Src/contrib/"

	ftp-site:
		url = "ftp.fasthosts.co.uk"; user_home = "/htdocs"

	templates:
		main = "main-template.html.evol"; eiffel_source = "eiffel-source-code.html.evol"
		site_map_content = "site-map-content.html.evol"; directory_content = "directory-tree-content.html.evol"
		favicon_markup = "favicon.markup"

	include-notes:
		note:
			"description"
			"descendants"
			"instructions"
			"notes"
			"tests"
			"warning"

	ecf-list:
		# Example
		ecf:
			"example/Eco-DB/database.ecf"

		# Library Base
		ecf:
			"library/base/base.ecf#kernel"
			"library/base/base.ecf#initialization"
			"library/base/base.ecf#math"
			"library/base/base.ecf#persistency"

		# Library (Persistence)
		ecf:
			"library/Eco-DB.ecf"
		# Library Text
		ecf:
			"library/public-key-encryption.ecf"

