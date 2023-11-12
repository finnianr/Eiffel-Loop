note
	description: "[
		Provides access to shared string iteration cursor for string conforming to [$source READABLE_STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-11 7:55:12 GMT (Saturday 11th November 2023)"
	revision: "1"

class
	STRING_ITERATION_CURSOR_TABLE

inherit
	EL_CONFORMING_INSTANCE_TABLE [EL_STRING_ITERATION_CURSOR]
		rename
			make as make_instance_table
		export
			{NONE} all
		end

	EL_SHARED_STRING_8_CURSOR; EL_SHARED_STRING_32_CURSOR

	EL_SHARED_ZSTRING_CURSOR
		rename
			cursor as zstring_cursor
		end

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