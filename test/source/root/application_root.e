note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-14 9:41:47 GMT (Saturday   14th   September   2019)"
	revision: "22"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Constants

	Applications: TUPLE [
		-- For maintenance purposes only
		MEDIA_PLAYER_DUMMY_APP,

		BEX_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP,
		COMPRESSION_TEST_APP,

		EXPERIMENTS_APP,
		ENCRYPTION_TEST_APP,
		EVOLICITY_TEST_APP,

		DECLARATIVE_XPATH_PROCESSING_TEST_APP,

		RECURSIVE_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP,

		SVG_TO_PNG_CONVERSION_TEST_APP,

		OBJECT_BUILDER_TEST_APP,

		-- Manual tests
		AUTOTEST_DEVELOPMENT_APP,
		TEST_SIMPLE_CLIENT,
		TEST_SIMPLE_SERVER,
		TEST_VTD_XML_APP,
		TEST_WORK_DISTRIBUTER_APP,

		-- Benchmarks
		BENCHMARK_APP,
		ZSTRING_BENCHMARK_APP
	]
		once
			create Result
		end

	Compile_also: TUPLE [MY_WET_CLASS, MY_DRY_CLASS, EL_TEST_SET_BRIDGE, LIBGCC1]
		once
			create Result
		end

end
