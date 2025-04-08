note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 18:52:00 GMT (Tuesday 8th April 2025)"
	revision: "5"

class
	EXTENDED_READABLE_STRING_TABLE

inherit
	EL_CONFORMING_INSTANCE_TABLE [EL_EXTENDED_READABLE_STRING_I [COMPARABLE]]
		rename
			make as make_instance_table
		export
			{NONE} all
		end

	EL_STRING_GENERAL_ROUTINES_I

create
	make

feature {NONE} -- Initialization

	make
		do
			make_instance_table (<<
				[{EL_READABLE_ZSTRING}, Shared_super_readable],
				[{READABLE_STRING_8},	Shared_super_readable_8],
				[{READABLE_STRING_32},	Shared_super_readable_32]
			>>)
		end

feature -- Access

	shared (general: READABLE_STRING_GENERAL): EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		do
			if has_related (general) then
				Result := found_item
				Result.set_target (general)
			else
				Result := Shared_super_readable_32
				Result.set_target (general.to_string_32)
			end
		end

end