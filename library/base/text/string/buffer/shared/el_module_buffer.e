note
	description: "Access to routines of [$source EL_ZSTRING_BUFFER_ROUTINES] via `buffer'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "16"

deferred class
	EL_MODULE_BUFFER

inherit
	EL_MODULE

feature {NONE} -- Constants

	Buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

end