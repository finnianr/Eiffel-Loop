note
	description: "Shared access to routines of class [$source EL_HEXADECIMAL_STRING_CONVERSION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:16:48 GMT (Thursday 6th February 2020)"
	revision: "3"

deferred class
	EL_MODULE_HEXADECIMAL

inherit
	EL_MODULE

feature {NONE} -- Constants

	Hexadecimal: EL_HEXADECIMAL_STRING_CONVERSION
		once
			create Result
		end
end
