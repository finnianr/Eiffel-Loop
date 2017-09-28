note
	description: "Summary description for {EL_MODULE_CRC_32}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-01 11:07:42 GMT (Friday 1st September 2017)"
	revision: "1"

class
	EL_MODULE_CRC_32

feature {NONE} -- Constants

	Crc_32: EL_CRC_32_ROUTINES
		once
			create Result
		end
end
