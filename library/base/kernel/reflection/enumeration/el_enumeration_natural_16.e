note
	description: "Implementation [$source EL_ENUMERATION [EL_REFLECTED_NATURAL_16, NATURAL_16]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-16 12:04:42 GMT (Sunday 16th July 2023)"
	revision: "1"

deferred class
	EL_ENUMERATION_NATURAL_16

inherit
	EL_ENUMERATION [NATURAL_16]
		rename
			enumeration_type as natural_16_type
		end

feature {NONE} -- Implementation

	as_hashable (a_value: NATURAL_16): NATURAL_16
		do
			Result := a_value
		end

	enum_value (field: EL_REFLECTED_NATURAL_16): NATURAL_16
		do
			Result := field.value (Current)
		end

feature -- Type definitions

	ENUM_FIELD: EL_REFLECTED_NATURAL_16
		once
			create Result.make (Current, 0, Empty_string_8)
		end

end