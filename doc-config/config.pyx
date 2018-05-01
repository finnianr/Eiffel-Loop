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
					Example program to demonstrate an
					[./example/net/eros-test-clients/source/sub-applications/fourier_math_test_client_app.html EROS client] calling an
					[./example/net/eros-server/source/sub-applications/fourier_math_server_app.html EROS server].
					EROS is an acronym for **E**iffel **R**emote **O**bject **S**erver. It uses an Eiffel orientated
					XML remote procedure call protocol.
				"""
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
		# Library Audio
		tree:
			name = "Audio Processing Classes"; dir = "library/multimedia/audio"
			description:
				"""
					Class for editing ID3 tags and processing WAV files.
				"""
		# Library Base
		tree:
			name = "Data Structures"; dir = "library/base/data_structure"
			description:
				"""
				"""
		tree:
			name = "Math Classes"; dir = "library/base/math"
			description:
				"""
				"""
		tree:
			name = "Persistency Classes"; dir = "library/base/persistency"
			description:
				"""
				"""
		tree:
			name = "Runtime Classes"; dir = "library/base/runtime"
			description:
				"""
				"""
		tree:
			name = "Text Processing Classes"; dir = "library/base/text"
			alias-map:
				old_name = EL_ZSTRING; new_name = ZSTRING
			description:
				"""
					Classes for parsing and processing textual data
				"""
		tree:
			name = "Miscellaneous Utility Classes"; dir = "library/base/utility"
			description:
				"""
				"""
		# Library Graphics
		tree:
			name = "Image Utilities"; dir = "library/graphic/image/utils"
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
		# Library (Language Interface)
		tree:
			name = "C/C++ and MS COM objects"; dir = "library/language_interface/C"
			ecf = "C-language-interface.ecf"
			description:
				"""
				"""
		tree:
			name = "Java"; dir = "library/language_interface/Java"; ecf = "eiffel2java.ecf"
			description:
				"Java.emd"
		tree:
			name = "Matlab"; dir = "library/language_interface/Matlab"
			description:
				"""
					**Status:** No longer maintained

					An Eiffel interface to [http://uk.mathworks.com/products/matlab/ Matlab], a popular math orientated scripting
					language. This interface was developed with Matlab Version 6.5, VC++ 8.0 Express Edition and
					Windows XP SP2 and successfully used in a number of linguistic research projects.
				"""
		tree:
			name = "Praat-script"; dir = "library/language_interface/Praat-script"
			description:
				"Praat-script.emd"
		tree:
			name = "Python"; dir = "library/language_interface/Python"
			description:
				"""
					Some extensions to Daniel Rodríguez's
					[https://github.com/finnianr/Eiffel-Loop/tree/master/contrib/Eiffel/PEPE PEPE library for Eiffel].
					This library allows you to call Python objects from Eiffel. Here is one example to query ID3 tags
					in an MP3 file: [$source EL_EYED3_TAG].
				"""

		# Library (Network)
		tree:
			name = "Basic Networking Classes"; dir = "library/network/base"
			ecf = "network.ecf"
			description:
				"""
					* Extensions for ISE network sockets.
					* Class to obtain the MAC address of network devices on both Windows and Linux.
					* Classes for managing HTTP cookies, query parameters, headers and status codes.
				"""
		tree:
			name = "Adobe Flash interface for Laabhair"; dir = "library/network/flash"
			description:
				"flash.emd"

		tree:
			name = "Amazon Instant Access API"; dir = "library/network/amazon"
			ecf = "amazon-instant-access.ecf"
			description:
				"""
					An Eiffel interface to the [https://s3-us-west-2.amazonaws.com/dtg-docs/index.html Amazon Instant Access API].
					This API enables third party vendors to fulfil orders for digital goods on the Amazon store.
					(WORK IN PROGRESS)
				"""
		tree:
			name = "Eiffel Remote Object Server (EROS)"; dir = "library/network/eros"
			ecf = "eros.ecf"
			description:
				"eros.emd"
		tree:
			name = "FTP Client Services"; dir = "library/network/protocol/ftp"
			ecf = "ftp.ecf"
			description:
				"""
					Classes for uploading files to a server and managing server directory structure.
				"""
		tree:
			name = "PayPal Payments Standard Button Manager API"; dir = "library/network/paypal"
			ecf = "paypal.ecf"
			description:
				"""
					An Eiffel interface to the
					[https://developer.paypal.com/docs/classic/button-manager/integration-guide/ PayPal Payments Standard Button Manager NVP HTTP API]. 
				"""

		tree:
			name = "HTTP Client Services"; dir = "library/network/protocol/http"
			ecf = "http-client.ecf"
			description:
				"""
					Classes for remotely interacting with a HTTP server. Supports the HTTP commands: POST, GET and HEAD.
				"""

		tree:
			name = "Fast CGI Servlets"; dir = "library/network/fast-cgi"
			ecf = "fast-cgi.ecf"
			description:
				"""
					An implementation of the [http://www.mit.edu/~yandros/doc/specs/fcgi-spec.html Fast-CGI protocol]
					for creating single and multi-threaded HTTP servlet services.
				"""

		# Library (Persistency)
		tree:
			name = "Eiffel CHAIN Orientated Binary Database"; dir = "library/persistency/database/chain-db"
			ecf = "chain-db.ecf"
			description:
				"chain-db.emd"
		tree:
			name = "Search Engine Classes"; dir = "library/persistency/search-engine"
			ecf = "search-engine.ecf"
			description:
				"""
					Classes for parsing search terms and searching a list conforming to `CHAIN [EL_WORD_SEARCHABLE]'.
					The search uses case-insensivitive word tokenization. Facility to create custom search times.
					Terms can be combined using basic boolean operators.
				"""
		tree:
			name = "Windows Registry Access"; dir = "library/persistency/win-registry"
			ecf = "wel-regedit-x.ecf"
			description:
				"win-registry.emd"
		tree:
			name = "Eiffel LIST-orientated XML Database"; dir = "library/persistency/database/xml-db"
			ecf = "xml-db.ecf"
			description:
				"""
					A simple XML database based on VTD-XML xpath and XML parsing library. Supports transactions and encryption.
					Any list conforming to `LIST [EL_STORABLE_XML_ELEMENT]' can be turned into a database.
					This library has now been superceded by `chain-db.ecf' which is more sophisticated and uses a binary format.
				"""
		tree:
			name = "Xpath orientated XML node scanners and Eiffel object builders"; dir = "library/persistency/xml/xdoc-scanning"
			ecf = "xdoc-scanning.ecf"
			description:
				"xdoc-scanning.emd"
		tree:
			name = "XML Document Scanning and Object Building (VTD-XML)"; dir = "library/persistency/xml/vtd-xml"
			ecf = "vtd-xml.ecf"
			description:
				"vtd-xml.emd"

		tree:
			name = "OpenOffice Spreadsheet"; dir = "library/persistency/xml/open-office-spreadsheet"
			ecf = "xml-conversion.ecf"
			description:
				"""
					Classes for parsing [http://www.datypic.com/sc/odf/e-office_spreadsheet.html OpenDocument Flat XML spreadsheets]
					using [http://vtd-xml.sourceforge.net/ VTD-XML].				
				"""

		# Library (Runtime)
		tree:
			name = "Multi-application Management"; dir = "library/runtime/app-manage"
			ecf = "app-manage.ecf"
			description:
				"app-manage.emd"
		tree:
			name = "Eiffel Thread Extensions"; dir = "library/runtime/concurrency"
			description:
				"""
					A collection of about 70 classes that extend the classic EiffelThread library.
				"""
		tree:
			name = "Multi-threaded Logging"; dir = "library/runtime/logging"
			ecf = "logging.ecf"
			description:
				"logging.emd"
		tree:
			name = "OS Command Wrapping"; dir = "library/runtime/process/commands"
			ecf = "os-command.ecf"
			description:
				"os-command.emd"

		# Library (Testing)
		tree:
			name = "Development Testing Classes"; dir = "library/testing"
			ecf = "testing.ecf"
			description:
				"""
					Classes for doing regression tests based on CRC checksum comparisons of logging output and output files.
				"""

		# Library (Text)
		tree:
			name = "AES Encryption Extensions"; dir = "library/text/encryption"; ecf = "encryption.ecf"
			description:
				"""
					Extensions to Colin LeMahieu's
					[https://github.com/EiffelSoftware/EiffelStudio/tree/master/Src/contrib/library/text/encryption/eel AES
					encryption library]. Includes a class for reading and writing encrypted files using
					[https://en.wikipedia.org/wiki/Advanced_Encryption_Standard AES]
					cipher [https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation block chains].
				"""
		tree:
			name = "RSA Public-key Encryption Extensions"; dir = "library/text/rsa-encryption"
			ecf = "public-key-encryption.ecf"
			description:
				"rsa.emd"
		tree:
			name = "Internationalization"; dir = "library/text/i18n"
			ecf = "i18n.ecf"
			description:
				"""
					An internationalization library with support for translations rendered in Pyxis format.
					There are a number of tools in `el_toolkit' to support the use of this library.
				"""
		tree:
			name = "Evolicity Text Substitution Engine"; dir = "library/text/template/evolicity"
			ecf = "evolicity.ecf"
			description:
				"evolicity.emd"

		# Library (Utility)
		tree:
			name = "Application License Management"; dir = "library/utility/app-license"
			ecf = "app-license-keys.ecf"
			description:
				"app-license.emd"
		tree:
			name = "ZLib Compression"; dir = "library/utility/compression"
			ecf = "compression.ecf"
			description:
				"""
					A Eiffel interface to the [https://www.zlib.net/ zlib C library].
					The main class is [$source EL_COMPRESSED_ARCHIVE_FILE] with a few helper classes.
				"""
		tree:
			name = "Currency Exchange"; dir = "library/utility/currency"
			ecf = "currency.ecf"
			description:
				"""
					Currency Exchange based on European Central bank Rates
				"""
		# Library (Override)
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

