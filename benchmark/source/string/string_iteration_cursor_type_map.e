note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "5"

class
	STRING_ITERATION_CURSOR_TYPE_MAP

inherit
	EL_CONFORMING_INSTANCE_TYPE_MAP [EL_STRING_ITERATION_CURSOR]
		rename
			make as make_instance_map
		export
			{NONE} all
		end

	EL_SHARED_STRING_8_CURSOR; EL_SHARED_STRING_32_CURSOR; EL_SHARED_ZSTRING_CURSOR

create
	make

feature {NONE} -- Initialization

	make
		do
			make_instance_map (<<
				[{READABLE_STRING_8}, String_8_iteration_cursor],
				[{EL_READABLE_ZSTRING}, String_iteration_cursor],
				[{READABLE_STRING_32}, String_32_iteration_cursor]
			>>)
		end

feature -- Access

	shared (general: READABLE_STRING_GENERAL): EL_STRING_ITERATION_CURSOR
		do
			if attached type_related_item (general) as related then
				Result := related
				Result.set_target (general)
			else
				Result := String_32_iteration_cursor
				Result.set_target (general.to_string_32)
			end
		end

end