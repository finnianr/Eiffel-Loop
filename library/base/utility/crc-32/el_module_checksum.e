note
	description: "Shared access to routines of class [$source EL_CRC_32_CHECKSUM_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-22 12:49:33 GMT (Sunday 22nd December 2019)"
	revision: "2"

deferred class
	EL_MODULE_CHECKSUM

inherit
	EL_MODULE

feature {NONE} -- Constants

	Checksum: EL_CRC_32_CHECKSUM_ROUTINES
		once
			create Result
		end
end
