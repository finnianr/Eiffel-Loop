pyxis-doc:
	version = 1.0; encoding = "UTF-8"

# Configuration file for the Eiffel-View repository publisher

publish-repository:
	name = "Eiffel-Loop"; root_dir = "workarea"; output_dir = "workarea/doc"
	web_address = "http://www.eiffel-loop.com"; github_url = "https://github.com/finnianr/eiffel-loop"
	invalid_names_output_path = "invalid-name-references.e"
	ise_library = "https://www.eiffel.org/files/doc/static/18.01/libraries/%S/%S_chart.html"
	ise_contrib = "https://github.com/EiffelSoftware/EiffelStudio/blob/main/Src/contrib/"
	ftp_sync_path = "workarea/doc/ftp.sync"

	ftp-site:
		url = "ftp.eiffel-loop.com"; user_home = "/htdocs"

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
		# Library Base
		ecf:
			"library/base/base.ecf#kernel"

