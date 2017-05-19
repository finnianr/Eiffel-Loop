note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-18 9:45:04 GMT (Thursday 18th May 2017)"
	revision: "3"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Implementation

	Application_types: ARRAY [TYPE [EL_SUB_APPLICATION]]
			--
		once
			Result := <<
				-- For maintenance purposes only
				{MEDIA_PLAYER_DUMMY_APP},

				{BEX_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP},
				{CHARACTER_STATE_MACHINE_TEST_APP},
				{COMPRESSION_TEST_APP},

				{EXPERIMENTS_APP},
				{ENCRYPTION_TEST_APP},
				{EVOLICITY_TEST_APP},

				{DECLARATIVE_XPATH_PROCESSING_TEST_APP},

				{RECURSIVE_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP},

				{STRING_EDITION_HISTORY_TEST_APP},
				{SVG_TO_PNG_CONVERSION_TEST_APP},

				{OBJECT_BUILDER_TEST_APP},

				-- Manual tests
				{CLASS_TEST_APP},

				{EYED3_TAG_TEST_APP},

				{AUTOTEST_DEVELOPMENT_APP},
				{TEST_SIMPLE_CLIENT},
				{TEST_SIMPLE_SERVER},
				{TEST_VTD_XML_APP},
				{TEST_WORK_DISTRIBUTER_APP},

				-- Benchmarks
				{BENCHMARK_APP},
				{ZSTRING_BENCHMARK_APP}

			>>
		end

	notes: TUPLE [DONE_LIST, TO_DO_LIST]
		do
		end

end
