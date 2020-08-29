note
	description: "Finalized executable tests for library [./library/xdoc-scanning.html xdoc-scanning.ecf]"
	notes: "[
		Command option: `-xdoc_scanning_autotest'
		
		**Test Sets**
		
			[$source CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET]
			[$source OBJECT_BUILDER_TEST_SET]
			[$source PYXIS_TO_XML_TEST_SET]
			[$source REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-29 13:45:01 GMT (Saturday 29th August 2020)"
	revision: "11"

class
	XDOC_SCANNING_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION
		redefine
			log_filter
		end

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [EL_PYXIS_RESOURCE_SET]
		do
			create Result
		end

	test_type: TUPLE [PYXIS_TO_XML_TEST_SET]
		do
			create Result
		end

	test_types_all: TUPLE [
		CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET,
		OBJECT_BUILDER_TEST_SET,
		PYXIS_PARSER_TEST_SET,
		PYXIS_TO_XML_TEST_SET,
		REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_SET
	]
		do
			create Result
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{PYXIS_TO_XML_TEST_SET}, All_routines],
				[{OBJECT_BUILDER_TEST_SET}, All_routines],
				[{CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET}, All_routines],

				[{BIOINFORMATIC_COMMANDS}, All_routines],
				[{BIOINFO_COMMAND}, All_routines],
				[{CONTAINER_PARAMETER}, All_routines],
				[{TITLE_PARAMETER}, All_routines],
				[{URL_PARAMETER}, All_routines],
				[{RULES_LIST_PARAMETER}, All_routines],
				[{DATA_PARAMETER}, All_routines],
				[{BOOLEAN_PARAMETER}, All_routines],
				[{INTEGER_PARAMETER}, All_routines],
				[{REAL_PARAMETER}, All_routines],
				[{CHOICE_PARAMETER}, All_routines],
				[{INTEGER_RANGE_LIST_PARAMETER}, All_routines],
				[{REAL_RANGE_LIST_PARAMETER}, All_routines],
				[{STRING_LIST_PARAMETER}, All_routines]
			>>
		end

end
