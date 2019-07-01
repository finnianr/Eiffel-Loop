note
	description: "Access to shared instance of class [$source EL_BINARY_STRING_CONVERSION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-05 15:19:10 GMT (Thursday 5th April 2018)"
	revision: "2"

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
