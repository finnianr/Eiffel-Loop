note
	description: "Command line interface to ${EVOLICITY_TEST_SET}"
	notes: "[
		Test sets conforming to ${EL_CRC_32_TESTABLE} (like this one) can only be run
		from a sub-application conforming to ${EL_CRC_32_AUTOTEST_APPLICATION}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-13 13:33:53 GMT (Thursday 13th March 2025)"
	revision: "24"

class
	EVOLICITY_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [EVOLICITY_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EVOLICITY_CACHEABLE_SERIALIZEABLE,
		EVOLICITY_LOCALIZED_VARIABLES,
		EVOLICITY_NUMERIC_EXPRESSION [COMPARABLE],
		EVOLICITY_TUPLE_CONTEXT,
		EVOLICITY_XML_VALUE
	]
		do
			create Result
		end

end