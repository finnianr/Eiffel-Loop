note
	description: "XML document scanning autotest app"
	notes: "[
		Command option: `-xdoc_scanning_autotest'
		
		**Tests**
		
		[$source PYXIS_TO_XML_TEST_SET]
		[$source REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-03 11:06:53 GMT (Monday 3rd February 2020)"
	revision: "3"

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

	compile: TUPLE [PYXIS_PARSER_TEST_SET]
		do
			create Result
		end

	evaluator_type, evaluator_types_all: TUPLE [
		PYXIS_TO_XML_TEST_EVALUATOR,
		REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_EVALUATOR
	]
		do
			create Result
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{PYXIS_TO_XML_TEST_SET}, All_routines]
			>>
		end

end
