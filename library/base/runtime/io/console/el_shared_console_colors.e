note
	description: "Shared instance of [$source EL_CONSOLE_COLORS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_SHARED_CONSOLE_COLORS

inherit
	EL_ANY_SHARED

feature -- Contract Support

	valid_colors: like Color.Valid_colors
		do
			Result := Color.Valid_colors
		end

feature {NONE} -- Implementation

	Color: EL_CONSOLE_COLORS
		once ("PROCESS")
			create Result
		end
end