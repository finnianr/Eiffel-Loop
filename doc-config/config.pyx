pyxis-doc:
	version = 1.0; encoding = "UTF-8"

# Configuration file for the Eiffel-View repository publisher

# Ignore cluster names 'test_common' and 'other'
#		ecf:
#			ignore = "test_common;other"

publish-repository:
	test_mode = false
	name = "Eiffel-Loop"; root_dir = "$EIFFEL/library/Eiffel-Loop"; output_dir = "eiffel-loop.com"
	web_address = "http://www.eiffel-loop.com"; github_url = "https://github.com/finnianr/Eiffel-Loop"
	invalid_names_output_path = "$HOME/Desktop/Eiffel/invalid-name-references.e"
	ise_library = "https://www.eiffel.org/files/doc/static/trunk/libraries/%S/%S_chart.html"
	ise_contrib = "https://github.com/EiffelSoftware/EiffelStudio/blob/main/Src/contrib/"
	max_useage_examples_count = 20
	
	ftp-site:
		passive_mode = true; prosite_ftp = true
		# ftp://user:password@host/<home_dir>
		encrypted_url:
			"HVQPk8fnB04fXvnHdSsvfGjfu0FMt2N1QWbjiSDK+a4/QKChD83g0pTLyeWwCkikSjCvccSQdKUi+bQ+jAp4MA=="
		credential:
			salt:
				"h1fV/qnFCjsJ9Z61mrWiib4scKqAzNd9"
			digest:
				"s2MpJZUCdsnU6N3zetItZw7+ixfbPRJ8t98O2yWitPs="

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
		# Examples
		ecf:
			"example/99-bottles/ninety-nine-bottles.ecf"
			"example/concurrency/concurrency-demo.ecf"
			"example/graphical/graphical.ecf"
			"example/manage-mp3/manage-mp3.ecf"
			"example/net/EROS/signal-math/signal-math.ecf#project"
			"example/net/EROS/server/signal-math-server.ecf#project"
			"example/protein-folding/protein-folding.ecf"
			"example/Eco-DB/database.ecf"

		# Library Multimedia
		ecf:
			"library/multi-media.ecf#audio"
			"library/multi-media.ecf#video"
			"library/ID3-tags.ecf"
			"library/TagLib.ecf"
			"library/wel-x-audio.ecf"
			"library/vision2-x-audio.ecf"
			"library/laabhair.ecf"

		# Library Base
		ecf:
			"library/base/base.ecf#data_structure"
			"library/base/base.ecf#date_time"
			"library/base/base.ecf#initialization"
			"library/base/base.ecf#io"
			"library/base/base.ecf#kernel"
			"library/base/base.ecf#math"
			"library/base/base.ecf#persistency"
			"library/base/base.ecf#reflection"
			"library/base/base.ecf#runtime"
			"library/base/base.ecf#text"
			"library/base/base.ecf#string"
			"library/base/base.ecf#string_8"
			"library/base/base.ecf#string_32"
			"library/base/base.ecf#string_structures"
			"library/base/base.ecf#utility"
		ecf:
			"library/base/base.ecf#file"
			alias-map:
				old_name = EL_DIR_PATH; new_name = DIR_PATH
			alias-map:
				old_name = EL_FILE_PATH; new_name = FILE_PATH
		ecf:
			"library/base/base.ecf#zstring"
			alias-map:
				old_name = EL_ZSTRING; new_name = ZSTRING

		# Library Graphics
		ecf:
			"library/image-utils.ecf"
			"library/installer-UI.ecf"
			"library/html-viewer.ecf"
			"library/vision2-x.ecf#container"
			"library/vision2-x.ecf#extensions"
			"library/vision2-x.ecf#graphics"
			"library/vision2-x.ecf#pango_cairo"
			"library/vision2-x.ecf#pixmap"	
			"library/vision2-x.ecf#widget"
			"library/wel-x.ecf"

		# Library (Language Interface)
		ecf:
			"library/C-language-interface.ecf#C_API"
			"library/C-language-interface.ecf#MS_COM"
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
			"library/paypal-SBM.ecf"
			"library/http-client.ecf"
			"library/fast-cgi.ecf#protocol"
			"library/fast-cgi.ecf#service"

		# Library (Override)
		ecf:
			"library/override/ES-vision2.ecf#EL_override"
			"library/override/ES-eiffel2java.ecf#EL_override"

		# Library (Persistency)
		ecf:
			"library/document-scan.ecf"
			"library/Eco-DB.ecf"
			"library/file-processing.ecf"
			"library/markup-docs.ecf#kindle_book"
			"library/markup-docs.ecf#thunderbird"
			"library/markup-docs.ecf#open_office"
			"library/pyxis-scan.ecf"
			"library/xml-db.ecf"
			"library/xml-scan.ecf"
			"library/vtd-xml.ecf"
			"library/wel-regedit-x.ecf"

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
			"library/search-engine.ecf"
			"library/text-formats.ecf"
			"library/text-process.ecf#parse"
			"library/text-process.ecf#pattern"

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
			"tool/eiffel/eiffel.ecf#test"
		ecf:
			ignore = test_common
			"tool/toolkit/toolkit.ecf"

		# Benchmark
		ecf:
			ignore = test_common
			"benchmark/benchmark.ecf"

		# Test obsolete ID3 tag libraries
		ecf:
			"test/ID3-tags/id3-test.ecf"

		# Test
		ecf:
			"test/test.ecf#amazon_ia"
			"test/test.ecf#app_manage"
			"test/test.ecf#base"
			"test/test.ecf#c_language_interface"
			"test/test.ecf#common"
			"test/test.ecf#compression"
			"test/test.ecf#currency"
			"test/test.ecf#eco_db"
			"test/test.ecf#eiffel"
			"test/test.ecf#encryption"
			"test/test.ecf#eros"
			"test/test.ecf#evolicity"
			"test/test.ecf#fast_cgi"
			"test/test.ecf#file_processing"
			"test/test.ecf#http_client"
			"test/test.ecf#i18n"
			"test/test.ecf#image_utils"
			"test/test.ecf#markup_docs"
			"test/test.ecf#multimedia"
			"test/test.ecf#network"
			"test/test.ecf#os_command"
			"test/test.ecf#paypal_sbm"
			"test/test.ecf#public_key_encryption"
			"test/test.ecf#pyxis_scan"
			"test/test.ecf#root"
			"test/test.ecf#search_engine"
			"test/test.ecf#taglib"
			"test/test.ecf#text_formats"
			"test/test.ecf#text_process"
			"test/test.ecf#vtd_xml"
			"test/test.ecf#wel_x_audio"
			"test/test.ecf#xml_scan"
		ecf:
			ignore = test_common
			"test/eiffel2java/eiffel2java.ecf"



	
