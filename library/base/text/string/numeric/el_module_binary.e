note
	description: "[
		Access to shared instance of class [$source EL_BINARY_STRING_CONVERSION].
		Accessible via [$source EL_MODULE_BINARY]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 9:07:50 GMT (Wednesday   25th   September   2019)"
	revision: "4"

deferred class
	EL_MODULE_BINARY

inherit
	EL_MODULE

feature {NONE} -- Constants

	Binary: EL_BINARY_STRING_CONVERSION
		once
			create Result
		end
end
