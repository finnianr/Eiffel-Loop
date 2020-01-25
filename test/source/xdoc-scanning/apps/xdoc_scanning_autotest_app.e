note
	description: "XML document scanning autotest app"
	notes: "Option: `-xdoc_scanning_autotest'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-25 13:26:25 GMT (Saturday 25th January 2020)"
	revision: "2"

class
	XDOC_SCANNING_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [PYXIS_PARSER_TEST_SET]
		do
			create Result
		end

	evaluator_type, evaluator_types_all: TUPLE [REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_EVALUATOR]
		do
			create Result
		end

end
