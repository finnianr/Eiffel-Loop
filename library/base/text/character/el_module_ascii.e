note
	description: "Shared access to base class [$source ASCII]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-01 11:17:47 GMT (Thursday 1st December 2022)"
	revision: "9"

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