note
	description: "Shared instance of [$source EL_CYCLIC_REDUNDANCY_CHECK_32] for regression testing screen output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "4"

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