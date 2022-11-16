note
	description: "[
		Access to shared instance of class [$source EL_BINARY_STRING_CONVERSION].
		Accessible via [$source EL_MODULE_BINARY]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

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