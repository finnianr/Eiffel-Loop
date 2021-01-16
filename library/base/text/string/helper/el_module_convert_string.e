note
	description: "Shared access to instance of class [$source EL_STRING_CONVERSION_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-16 11:10:20 GMT (Saturday 16th January 2021)"
	revision: "1"

deferred class
	EL_MODULE_CONVERT_STRING

inherit
	EL_MODULE

feature {NONE} -- Constants

	Convert_string: EL_STRING_CONVERSION_TABLE
		once
			create Result.make
		end
end