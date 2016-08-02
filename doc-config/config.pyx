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
			name = "Eiffel remote object test server (EROS)"; dir = "example/net/eros-server/source"
			ecf = "eros-server.ecf"
			description:
				"""
					Example program demonstrating the use of the EROS library. EROS is an acronym for
					**E**iffel **R**emote **O**bject **S**erver. It uses an XML remote procedure call protocol.
				"""
		tree:
			name = "EROS test clients"; dir = "example/net/eros-test-clients/source"
			description:
				"""
					Example program demonstrating how a client can call a server created with the EROS library.
					EROS is an acronym for **E**iffel **R**emote **O**bject **S**erver. It uses an XML remote 
					procedure call protocol.
				"""
		tree:
			name = "Eiffel to Java"; dir = "example/eiffel2java/source"; ecf = "eiffel2java.ecf"
			description:
				"""
					Demonstration program for the Eiffel-Loop Java interface library. This library provides
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
				"""
		# Tool
		tree:
			name = "Development Toolkit Program"; dir = "tool/toolkit/source"
			description:
				"toolkit.emd"
		# Test
		tree:
			name = "Development Testing"; dir = "test/source"
			description:
				"""
				"""
		# Library Audio
		tree:
			name = "Audio Processing Classes"; dir = "library/multimedia/audio"
			description:
				"""
				"""
		# Library base
		tree:
			name = "Base Data Structures"; dir = "library/base/data_structure"
			description:
				"""
				"""
		tree:
			name = "Base Math Classes"; dir = "library/base/math"
			description:
				"""
				"""
		tree:
			name = "Base Persistency Classes"; dir = "library/base/persistency"
			description:
				"""
				"""
		tree:
			name = "Base Runtime Classes"; dir = "library/base/runtime"
			description:
				"""
				"""
		tree:
			name = "Base Text Processing Classes"; dir = "library/base/text"
			alias-map:
				old_name = EL_ZSTRING; new_name = ZSTRING
			description:
				"""
				"""
		tree:
			name = "Base Miscellaneous Utility Classes"; dir = "library/base/utility"
			description:
				"""
				"""
		# Library Graphics
		tree:
			name = "Graphical Image Utilities"; dir = "library/graphic/image/utils"
			description:
				"""
				"""
		tree:
			name = "HTML Viewer (based on Vision-2)"; dir = "library/graphic/toolkit/html-viewer"
			description:
				"""
				"""
		tree:
			name = "Vision-2 GUI Extensions"; dir = "library/graphic/toolkit/vision2-x"
			ecf = "vision2-x.ecf"
			description:
				"vision2-x.emd"
		tree:
			name = "Windows Eiffel Library Extensions"; dir = "library/graphic/toolkit/wel-x"
			description:
				"""
				"""
		# Library language_interface
		tree:
			name = "Interface to C/C++ and MS COM objects"; dir = "library/language_interface/C"
			description:
				"""
				"""
		tree:
			name = "Interface to Java"; dir = "library/language_interface/Java"; ecf = "eiffel2java.ecf"
			description:
				"Java.emd"
		tree:
			name = "Interface to Matlab"; dir = "library/language_interface/Matlab"
			description:
				"""
					**Status:** No longer maintained

					[http://uk.mathworks.com/products/matlab/ Matlab] is a popular math orientated scripting
					language. This interface was developed with Matlab Version 6.5, VC++ 8.0 Express Edition and
					Windows XP SP2.
				"""
		tree:
			name = "Interface to Praat-script"; dir = "library/language_interface/Praat-script"
			description:
				"Praat-script.emd"
		tree:
			name = "Interface to Python"; dir = "library/language_interface/Python"
			description:
				"""
				"""

		# Library Network
		tree:
			name = "Basic Networking Classes"; dir = "library/network/base"
			description:
				"""
				"""
		tree:
			name = "Adobe Flash interface for Laabhair"; dir = "library/network/flash"
			description:
				"flash.emd"
		tree:
			name = "Eiffel Remote Object Server (EROS)"; dir = "library/network/eros"
			description:
				"""
				"""
		tree:
			name = "Transfer Protocols"; dir = "library/network/protocol"
			description:
				"""
				"""
		tree:
			name = "Interface to Paypal API (HTTP NVP)"; dir = "library/network/paypal"
			description:
				"""
				"""
		tree:
			name = "Goanna Servlet Extensions"; dir = "library/network/servlet"
			description:
				"""
				"""
		# Library Database
		tree:
			name = "Eiffel CHAIN Orientated Binary Database"; dir = "library/persistency/database/binary-db"
			ecf = "database.ecf"
			description:
				"binary-db.emd"
		tree:
			name = "Search Engine Classes"; dir = "library/persistency/database/search-engine"
			ecf = "database.ecf"
			description:
				"""
				"""
		tree:
			name = "Windows Registry Access"; dir = "library/persistency/database/win-registry"
			ecf = "wel-regedit-x.ecf"
			description:
				"win-registry.emd"
		tree:
			name = "Eiffel CHAIN-based XML Database"; dir = "library/persistency/database/xml-db"
			ecf = "database.ecf"
			description:
				"""
				"""
		# Library XML
		tree:
			name = "XML and Pyxis Document Scanning and Object Building (eXpat)"; dir = "library/persistency/xml/xdoc-scanning"
			ecf = "xdoc-scanning.ecf"
			description:
				"xdoc-scanning.emd"
		tree:
			name = "XML Document Scanning and Object Building (VTD-XML)"; dir = "library/persistency/xml/vtd-xml"
			ecf = "vtd-xml.ecf"
			description:
				"vtd-xml.emd"

		# Library spreadsheet
		tree:
			name = "OpenOffice Spreadsheet"; dir = "library/persistency/xml/open-office-spreadsheet"
			ecf = "xml-conversion.ecf"
			description:
				"""
					Classes for parsing [http://www.datypic.com/sc/odf/e-office_spreadsheet.html OpenDocument Flat XML spreadsheets]
					using [http://vtd-xml.sourceforge.net/ VTD-XML].				
				"""

		# Library Runtime
		tree:
			name = "Multi-application Management"; dir = "library/runtime/app-manage"
			ecf = "app-manage.ecf"
			description:
				"app-manage.emd"
		tree:
			name = "Eiffel Thread Extensions"; dir = "library/runtime/concurrency"
			description:
				"""
				"""
		tree:
			name = "Multi-threaded Logging"; dir = "library/runtime/logging"
			description:
				"""
				"""
		tree:
			name = "OS Command Wrapping"; dir = "library/runtime/process/commands"
			description:
				"""
				"""
		# Library Testing
		tree:
			name = "Development Testing Classes"; dir = "library/testing"
			description:
				"""
				"""

		# Library Testing
		tree:
			name = "AES Encryption Extensions"; dir = "library/text/encryption/aes"; ecf = "encryption.ecf"
			description:
				"""
					Extensions to Colin LeMahieu's
					[https://github.com/EiffelSoftware/EiffelStudio/tree/master/Src/contrib/library/text/encryption/eel AES
					encryption library]. Includes a class for reading and writing encrypted files using
					[https://en.wikipedia.org/wiki/Advanced_Encryption_Standard AES]
					cipher [https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation block chains].
				"""
		tree:
			name = "RSA Public-key Encryption Extensions"; dir = "library/text/encryption/rsa"
			ecf = "public-key-encryption.ecf"
			description:
				"rsa.emd"
		tree:
			name = "Internationalization"; dir = "library/text/i18n"
			description:
				"""
				"""
		tree:
			name = "Evolicity Text Substitution Engine"; dir = "library/text/template/evolicity"
			ecf = "evolicity.ecf"
			description:
				"evolicity.emd"

		# Library Utility
		tree:
			name = "Application License Management"; dir = "library/utility/app-license"; ecf = "app-license-keys.ecf"
			description:
				"app-license.emd"
		tree:
			name = "Performance Benchmarking and Command Shell"; dir = "library/utility/various"
			description:
				"""
				"""
		tree:
			name = "ZLib Compression"; dir = "library/utility/compression"
			description:
				"""
				"""
		# Library Overrides
		tree:
			name = "Override of ES GUI Toolkits"; dir = "library/override/graphic/toolkit"
			description:
				"""
				"""
		tree:
			name = "Override of ES Eiffel to Java Interface"; dir = "library/override/language_interface/Java"
			description:
				"""
				"""

