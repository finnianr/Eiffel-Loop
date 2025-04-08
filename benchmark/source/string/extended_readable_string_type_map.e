note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 18:54:39 GMT (Tuesday 8th April 2025)"
	revision: "6"

class
	EXTENDED_READABLE_STRING_TYPE_MAP

inherit
	EL_CONFORMING_INSTANCE_TYPE_MAP [EL_EXTENDED_READABLE_STRING_I [COMPARABLE]]
		rename
			make as make_instance_map
		export
			{NONE} all
		end

	EL_STRING_GENERAL_ROUTINES_I

create
	make

feature {NONE} -- Initialization

	make
		do
			make_instance_map (<<
				[{EL_READABLE_ZSTRING}, Shared_super_readable],
				[{READABLE_STRING_8},	Shared_super_readable_8],
				[{READABLE_STRING_32},	Shared_super_readable_32]
			>>)
		end

feature -- Access

	extended_string (general: READABLE_STRING_GENERAL): EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		do
			if attached type_related_item (general) as related then
				Result := related
				Result.set_target (general)
			else
				Result := Shared_super_readable_32
				Result.set_target (general.to_string_32)
			end
		end

end