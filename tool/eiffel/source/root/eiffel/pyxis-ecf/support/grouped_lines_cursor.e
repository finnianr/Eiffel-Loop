note
	description: "Line iteration cursor with `tab_count' indentation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-15 16:58:31 GMT (Saturday 15th February 2025)"
	revision: "7"

class
	GROUPED_LINES_CURSOR

inherit
	EL_SPLIT_ON_CHARACTER_8_CURSOR [STRING]
		rename
			make as make_cursor
		redefine
			item
		end

	EL_CHARACTER_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_target: like target; a_tab_count: INTEGER)
		do
			target := a_target; tab_count := a_tab_count
			separator := '%N'
			forth
		end

feature -- Access

	item: STRING
		do
			Result := Buffer.copied (Tab * tab_count)
			Result.append_substring (target, item_lower, item_upper)
		end

feature {NONE} -- Internal attributes

	tab_count: INTEGER

feature {NONE} -- Constants

	Buffer: EL_STRING_8_BUFFER
		once
			create Result
		end
end