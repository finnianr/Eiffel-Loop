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

	sources:
		# Examples
		tree:
			name = "Submission for 99-bottles-of-beer.net"; dir = "example/99-bottles/source"
			ecf = "ninety-nine-bottles.ecf"
			description:
				"""
					Eiffel submission for [http://www.99-bottles-of-beer.net/ www.99-bottles-of-beer.net].
					
					This website contains sample programs for over 1500 languages and variations, all of 
					which print the lyrics of the song "99 Bottles of Beer".
				"""
		tree:
			name = "Eiffel EROS server with client example"
			ecf = "eros-server.ecf & test-clients.ecf"; dir = "example/net/EROS"
			description:
				"eros.emd"
		tree:
			name = "Eiffel to Java"; dir = "example/eiffel2java/source"; ecf = "eiffel2java.ecf"
			description:
				"""
					Demo for the Eiffel-Loop Java interface library. This library provides
					a useful layer of abstraction over the Eiffel Software JNI interface.
				"""
		tree:
			name = "Rhythmbox MP3 Collection Manager"; dir = "example/manage-mp3/source"; ecf = ""
			description:
				"manage-mp3.emd"
		tree:
			name = "Vision-2 Extensions Demo"; dir = "example/graphical/source"
			description:
				"""
					Test application for selected components from Eiffel-Loop extension libraries for Vision-2 and Docking.
				"""
		# Tools
		tree:
			name = "Eiffel Development Utility"; dir = "tool/eiffel/source"
			description:
				"eiffel.emd"
		tree:
			name = "Utilities Toolkit"; dir = "tool/toolkit/source"
			description:
				"toolkit.emd"
		# Test
		tree:
			name = "Development Testing"; dir = "test/source"
			description:
				"""
				"""


