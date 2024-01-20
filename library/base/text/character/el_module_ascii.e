note
	description: "Shared access to base class ${ASCII}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "10"

deferred class
	EL_MODULE_ASCII

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Ascii: ASCII
		once
			create Result
		end
end