note
	description: "Shared access to routines of class [$source EL_C_DECODER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:03:03 GMT (Thursday 6th February 2020)"
	revision: "8"

deferred class
	EL_MODULE_C_DECODER

inherit
	EL_MODULE

feature {NONE} -- Constants

	C_decoder: EL_C_DECODER
			--
		once
			create Result
		end

end
