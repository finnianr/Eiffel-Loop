note
	description: "Command line interface to [$source EVOLICITY_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 14:52:16 GMT (Saturday 5th February 2022)"
	revision: "19"

class
	EVOLICITY_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [EVOLICITY_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile_also: TUPLE [EVOLICITY_TUPLE_CONTEXT]
		do
			create Result
		end

end