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
			"example/net/EROS/signal-math/signal-math.ecf"
			"example/net/EROS/server/signal-math-server.ecf"
			"example/99-bottles/ninety-nine-bottles.ecf"
			"example/eiffel2java/eiffel2java.ecf"
			"example/manage-mp3/manage-mp3.ecf"
			"example/graphical/graphical.ecf"

		# Library Audio
		ecf:
			"library/ID3-tags.ecf"
			"library/wav-audio.ecf"
			"library/wel-x-audio.ecf"
			"library/vision2-x-audio.ecf"
			"library/doc/laabhair.ecf"

		# Library Base
		ecf:
			"library/base/base.ecf#data_structure"
			"library/base/base.ecf#math"
			"library/base/base.ecf#persistency"
			"library/base/base.ecf#runtime"
			"library/base/base.ecf#utility"
		ecf:
			"library/base/base.ecf#text"
			alias-map:
				old_name = EL_ZSTRING; new_name = ZSTRING

		# Library Graphics
		ecf:
			"library/image-utils.ecf"
			"library/html-viewer.ecf"
			"library/vision2-x.ecf#container"
			"library/vision2-x.ecf#extensions"
			"library/vision2-x.ecf#pango_cairo"
			"library/vision2-x.ecf#widget"
			"library/wel-x.ecf"

		# Library (Language Interface)
		ecf:
			"library/C-language-interface.ecf"
			"library/eiffel2java.ecf"
			"library/eiffel2python.ecf"
			"library/doc/eiffel2matlab.ecf"
			"library/doc/eiffel2praat.ecf"

		# Library (Network)
		ecf:
			"library/eros.ecf"
			"library/network.ecf"
			"library/doc/flash-network.ecf"
			"library/amazon-instant-access.ecf"
			"library/ftp.ecf"
			"library/paypal.ecf"
			"library/http-client.ecf"
			"library/fast-cgi.ecf"

		# Library (Override)
		ecf:
			"library/override/ES-vision2.ecf#EL_override"
			"library/override/ES-eiffel2java.ecf#EL_override"

		# Library (Persistency)
		ecf:
			"library/Eco-DB.ecf"
			"library/search-engine.ecf"
			"library/wel-regedit-x.ecf"
			"library/xml-db.ecf"
			"library/xdoc-scanning.ecf"
			"library/vtd-xml.ecf"
			"library/markup-docs.ecf#open_office"

		# Library (Runtime)
		ecf:
			"library/app-manage.ecf"
			"library/thread.ecf"
			"library/logging.ecf"
			"library/os-command.ecf"

		# Library (Testing)
		ecf:
			"library/testing.ecf"

		# Library (Text)
		ecf:
			"library/i18n.ecf"
			"library/encryption.ecf"
			"library/public-key-encryption.ecf"
			"library/evolicity.ecf"
			"library/markup-docs.ecf#kindle_book"
			"library/markup-docs.ecf#thunderbird"
			"library/text-formats.ecf"
			"library/text-process.ecf#edit"
			"library/text-process.ecf#parse"
			"library/text-process.ecf#pattern_match"

		# Library (Utility)
		ecf:
			"library/app-license-keys.ecf"
			"library/compression.ecf"
			"library/currency.ecf"
			"library/win-installer.ecf"

		# Tools
		ecf:
			"tool/eiffel/eiffel.ecf#root"
			"tool/eiffel/eiffel.ecf#edit"
			"tool/eiffel/eiffel.ecf#analyse"
			"tool/toolkit/toolkit.ecf"

		# Test
		ecf:
			"test/test.ecf#benchmark"
			"test/test.ecf#root"
			"test/test.ecf#test_set"

	
