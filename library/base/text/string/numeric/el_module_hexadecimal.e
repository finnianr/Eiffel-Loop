note
	description: "Access to shared instance of class [$source EL_HEXADECIMAL_STRING_CONVERSION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:56:41 GMT (Monday 1st July 2019)"
	revision: "2"

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
