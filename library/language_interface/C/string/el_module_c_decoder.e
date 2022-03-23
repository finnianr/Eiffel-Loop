note
	description: "Shared access to routines of class [$source EL_C_DECODER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-23 11:06:31 GMT (Wednesday 23rd March 2022)"
	revision: "9"

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