note
	description: "Shared instance of ${EL_CYCLIC_REDUNDANCY_CHECK_32} for regression testing screen output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "5"

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