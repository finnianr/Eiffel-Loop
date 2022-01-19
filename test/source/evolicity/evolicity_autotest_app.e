note
	description: "Command line interface to [$source EVOLICITY_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-19 14:28:34 GMT (Wednesday 19th January 2022)"
	revision: "18"

class
	EVOLICITY_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_SUB_APPLICATION [EVOLICITY_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile_also: TUPLE [EVOLICITY_TUPLE_CONTEXT]
		do
			create Result
		end

end