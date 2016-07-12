pyxis-doc:
	version = 1.0; encoding = "UTF-8"

# Configuration file for the Eiffel-View repository publisher

publish-repository:
	name = "Eiffel-Loop"

	templates:
		main:
			"template.html.evol"
		eiffel-source:
			"source-code.html.evol"

	root-dir:
		"$EIFFEL_LOOP"
	output-dir:
		"$EIFFEL_LOOP/doc"
	github-url:
		"https://github.com/finnianr/eiffel-loop"

	ftp-site:
		url:
			"eiffel-loop.com"
		user-home:
			"/public/www"
		sync-path:
			"$EIFFEL_LOOP/doc/ftp.sync"

	sources:
		# Examples
		tree:
			name = "Submission for 99-bottles-of-beer.net"
			"$EIFFEL_LOOP/example/99-bottles/source"
		tree:
			name = "Eiffel Remote Object test server (EROS)"
			"$EIFFEL_LOOP/example/net/eros-server/source"
		tree:
			name = "EROS test clients"
			"$EIFFEL_LOOP/example/net/eros-test-clients/source"
		tree:
			name = "Eiffel to Java"
			"$EIFFEL_LOOP/example/eiffel2java/source"
		tree:
			name = "Rhythmbox MP3 Collection Manager"
			"$EIFFEL_LOOP/example/manage-mp3/source"
		tree:
			name = "Vision-2 Extensions Demo"
			"$EIFFEL_LOOP/example/graphical/source"
		# Tool
		tree:
			name = "Development Toolkit Program"
			"$EIFFEL_LOOP/tool/toolkit/source"
		# Test
		tree:
			name = "Development Testing"
			"$EIFFEL_LOOP/test/source"
		# Library Audio
		tree:
			name = "Audio Processing Classes"
			"$EIFFEL_LOOP/library/multimedia/audio"
		# Library base
		tree:
			name = "Base Data Structures"
			"$EIFFEL_LOOP/library/base/data_structure"
		tree:
			name = "Base Math Classes"
			"$EIFFEL_LOOP/library/base/math"
		tree:
			name = "Base Persistency Classes"
			"$EIFFEL_LOOP/library/base/persistency"
		tree:
			name = "Base Runtime Classes"
			"$EIFFEL_LOOP/library/base/runtime"
		tree:
			name = "Base Text Processing Classes"
			"$EIFFEL_LOOP/library/base/text"
			alias-map:
				old_name = EL_ZSTRING; new_name = ZSTRING
		tree:
			name = "Base Miscellaneous Utility Classes"
			"$EIFFEL_LOOP/library/base/utility"

		# Library Graphics
		tree:
			name = "Graphical Image Utilities"
			"$EIFFEL_LOOP/library/graphic/image/utils"
		tree:
			name = "HTML Viewer (based on Vision-2)"
			"$EIFFEL_LOOP/library/graphic/toolkit/html-viewer"
		tree:
			name = "Vision-2 GUI Extensions"
			"$EIFFEL_LOOP/library/graphic/toolkit/vision2-x"
		tree:
			name = "Windows Eiffel Library Extensions"
			"$EIFFEL_LOOP/library/graphic/toolkit/wel-x"
		# Library language_interface
		tree:
			name = "Interface to C/C++ and MS COM objects"
			"$EIFFEL_LOOP/library/language_interface/C"
		tree:
			name = "Interface to Java"
			"$EIFFEL_LOOP/library/language_interface/Java"
		tree:
			name = "Interface to Matlab"
			"$EIFFEL_LOOP/library/language_interface/Matlab"
		tree:
			name = "Interface to Praat-script"
			"$EIFFEL_LOOP/library/language_interface/Praat-script"
		tree:
			name = "Interface to Python"
			"$EIFFEL_LOOP/library/language_interface/Python"

		# Library Network
		tree:
			name = "Basic Networking Classes"
			"$EIFFEL_LOOP/library/network/base"
		tree:
			name = "Adobe Flash interface"
			"$EIFFEL_LOOP/library/network/flash"
		tree:
			name = "Eiffel Remote Object Server (EROS)"
			"$EIFFEL_LOOP/library/network/eros"
		tree:
			name = "Transfer Protocols"
			"$EIFFEL_LOOP/library/network/protocol"
		tree:
			name = "Interface to Paypal API (HTTP NVP)"
			"$EIFFEL_LOOP/library/network/paypal"
		tree:
			name = "Goanna Servlet Extensions"
			"$EIFFEL_LOOP/library/network/servlet"
		# Library Database
		tree:
			name = "Eiffel LIST-based Binary Database"
			"$EIFFEL_LOOP/library/persistency/database/binary-db"
		tree:
			name = "Search Engine Classes"
			"$EIFFEL_LOOP/library/persistency/database/search-engine"
		tree:
			name = "Windows Registry Access"
			"$EIFFEL_LOOP/library/persistency/database/win-registry"
		tree:
			name = "Eiffel LIST-based XML Database"
			"$EIFFEL_LOOP/library/persistency/database/xml-db"
		# Library XML
		tree:
			name = "XML Processing"
			"$EIFFEL_LOOP/library/persistency/xml"
		# Library Runtime
		tree:
			name = "Multi-application Management"
			"$EIFFEL_LOOP/library/runtime/app-manage"
		tree:
			name = "Eiffel Thread Extensions"
			"$EIFFEL_LOOP/library/runtime/concurrency"
		tree:
			name = "Multi-threaded Logging"
			"$EIFFEL_LOOP/library/runtime/logging"
		tree:
			name = "OS Command Wrapping"
			"$EIFFEL_LOOP/library/runtime/process/commands"
		# Library Testing
		tree:
			name = "Development Testing Classes"
			"$EIFFEL_LOOP/library/testing"

		# Library Testing
		tree:
			name = "Encryption Extensions"
			"$EIFFEL_LOOP/library/text/encryption"
		tree:
			name = "Internationalization"
			"$EIFFEL_LOOP/library/text/i18n"
		tree:
			name = "Evolicity Text Substitution Engine"
			"$EIFFEL_LOOP/library/text/template/evolicity"
		# Library Utility
		tree:
			name = "Application License Management"
			"$EIFFEL_LOOP/library/utility/app-license"
		tree:
			name = "Performance Benchmarking and Command Shell"
			"$EIFFEL_LOOP/library/utility/various"
		tree:
			name = "ZLib Compression"
			"$EIFFEL_LOOP/library/utility/compression"
		# Library Overrides
		tree:
			name = "Override of ES GUI Toolkits"
			"$EIFFEL_LOOP/library/override/graphic/toolkit"
		tree:
			name = "Override of ES Eiffel to Java Interface"
			"$EIFFEL_LOOP/library/override/language_interface/Java"

