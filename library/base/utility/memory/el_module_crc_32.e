note
	description: "Module crc 32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_MODULE_CRC_32

feature {NONE} -- Constants

	Crc_32: EL_CRC_32_ROUTINES
		once
			create Result
		end
end
