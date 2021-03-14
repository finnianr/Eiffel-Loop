note
	description: "Command line interface to [$source EVOLICITY_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-14 14:24:01 GMT (Sunday 14th March 2021)"
	revision: "16"

class
	EVOLICITY_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [EVOLICITY_TEST_SET]
		redefine
			description
		end

create
	make

feature {NONE} -- Implementation

	compile_also: TUPLE [EVOLICITY_TUPLE_CONTEXT]
		do
			create Result
		end

feature {NONE} -- Constants

	Description: STRING = "Test Evolicity template substitution"

end