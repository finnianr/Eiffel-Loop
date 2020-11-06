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
	date: "2020-11-06 16:46:21 GMT (Friday 6th November 2020)"
	revision: "14"

class
	XDOC_SCANNING_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [
		CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET,
		OBJECT_BUILDER_TEST_SET,
		PYXIS_PARSER_TEST_SET,
		PYXIS_TO_XML_TEST_SET,
		REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_SET
	]
		redefine
			log_filter_list
		end

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [EL_PYXIS_RESOURCE_SET]
		do
			create Result
		end

	log_filter_list: EL_LOG_FILTER_LIST [
		like Current,
		PYXIS_TO_XML_TEST_SET,
		OBJECT_BUILDER_TEST_SET,
		CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET,

		BIOINFORMATIC_COMMANDS,
		BIOINFO_COMMAND,
		CONTAINER_PARAMETER,
		TITLE_PARAMETER,
		URL_PARAMETER,
		RULES_LIST_PARAMETER,
		DATA_PARAMETER,
		BOOLEAN_PARAMETER,
		INTEGER_PARAMETER,
		REAL_PARAMETER,
		CHOICE_PARAMETER,
		INTEGER_RANGE_LIST_PARAMETER,
		REAL_RANGE_LIST_PARAMETER,
		STRING_LIST_PARAMETER
	]
		do
			create Result.make
		end

end