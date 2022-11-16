note
	description: "Command line interface to [$source EVOLICITY_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "20"

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