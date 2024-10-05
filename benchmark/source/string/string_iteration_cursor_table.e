note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "4"

class
	STRING_ITERATION_CURSOR_TABLE

inherit
	EL_CONFORMING_INSTANCE_TABLE [EL_STRING_ITERATION_CURSOR]
		rename
			make as make_instance_table
		export
			{NONE} all
		end

	EL_SHARED_STRING_8_CURSOR; EL_SHARED_STRING_32_CURSOR; EL_SHARED_ZSTRING_CURSOR

create
	make

feature {NONE} -- Initialization

	make
		do
			make_instance_table (<<
				[{READABLE_STRING_8}, String_8_iteration_cursor],
				[{EL_READABLE_ZSTRING}, String_iteration_cursor],
				[{READABLE_STRING_32}, String_32_iteration_cursor]
			>>)
		end

feature -- Access

	shared (general: READABLE_STRING_GENERAL): EL_STRING_ITERATION_CURSOR
		do
			if has_related (general) then
				Result := found_item
				Result.set_target (general)
			else
				Result := String_32_iteration_cursor
				Result.set_target (general.to_string_32)
			end
		end

end