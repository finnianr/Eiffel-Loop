pyxis-doc:
	version = 1.0; encoding = "ISO-8859-15"

manifest:
	notes:
		author = "Finnian Reilly"
		copyright = "Copyright (c) 2001-2017 Finnian Reilly"
		contact = "finnian at eiffel hyphen loop dot com"
		license = "MIT license (See: en.wikipedia.org/wiki/MIT_License)"

	# examples
	location:
		"example/concurrency/source"
		"example/graphical/source"
		"example/manage-mp3/source"
		"example/net/EROS/server/source"
		"example/net/EROS/signal-math/source"
	
	# separate GNU license with Gerrit Leder
	import:
		"example/protein-folding/source-manifest.pyx"

	# testing and benchmarks
	location:
		"benchmark/source"
		"test/eiffel2java/source"
		"test/source"
		"test/ID3-tags/source"

	# tools
	location:
		"tool/eiffel/source"
		"tool/toolkit/source"

	# libraries
	location:
		"library/base"
		"library/graphic"
		"library/language_interface"
		"library/multimedia"
		"library/network"
		"library/persistency"
		"library/runtime"
		"library/testing"
		"library/text"
		"library/utility"

