note
	description: "Shared instance of [$source EL_CYCLIC_REDUNDANCY_CHECK_32] for regression testing screen output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 13:19:36 GMT (Friday 31st January 2020)"
	revision: "2"

deferred class
	EL_SHARED_TEST_CRC

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Test_crc: EL_CYCLIC_REDUNDANCY_CHECK_32
		once
			create Result.make
		end
end
