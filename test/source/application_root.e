note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:31 GMT (Tuesday 2nd September 2014)"
	revision: "5"

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
				{BENCHMARK_STRINGS_APP},
				{CHARACTER_STATE_MACHINE_TEST_APP},
				{COMPRESSION_TEST_APP},

				{EXPERIMENTS_APP},
				{ENCRYPTION_TEST_APP},
				{EVOLICITY_TEST_APP},

				{DECLARATIVE_XPATH_PROCESSING_TEST_APP},

				{TEST_APP},
				{TEST_OS_COMMANDS_APP},

				{RECURSIVE_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP},

				{STRING_EDITION_HISTORY_TEST_APP},
				{SVG_TO_PNG_CONVERSION_TEST_APP},

				{XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP},

				-- Manual tests
				{CLASS_TEST_APP},

				{EL_EYED3_TAG_TEST_APP},

				{TEST_SETS_APP},
				{TEST_SIMPLE_CLIENT},
				{TEST_SIMPLE_SERVER},
				{TEST_VTD_XML_APP}
			>>
		end

note
	to_do: "[
	]"
end
