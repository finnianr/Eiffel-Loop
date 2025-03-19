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
	date: "2025-03-18 7:05:50 GMT (Tuesday 18th March 2025)"
	revision: "25"

class
	EVOLICITY_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [EVOLICITY_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EVC_CACHEABLE_SERIALIZEABLE,
		EVC_LOCALIZED_VARIABLES,
		EVC_NUMERIC_EXPRESSION [COMPARABLE],
		EVC_TUPLE_CONTEXT,
		EVC_XML_VALUE
	]
		do
			create Result
		end

end