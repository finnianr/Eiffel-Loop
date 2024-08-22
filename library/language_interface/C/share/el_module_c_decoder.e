note
	description: "Shared access to routines of class ${EL_C_DECODER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-22 10:43:55 GMT (Thursday 22nd August 2024)"
	revision: "12"

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