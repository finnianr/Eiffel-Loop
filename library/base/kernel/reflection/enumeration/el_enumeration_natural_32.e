note
	description: "Implementation ${EL_ENUMERATION [NATURAL_32]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-22 9:26:16 GMT (Tuesday 22nd April 2025)"
	revision: "9"

deferred class
	EL_ENUMERATION_NATURAL_32

inherit
	EL_ENUMERATION [NATURAL_32]
		rename
			enum_type as natural_32_type
		end

	EL_32_BIT_IMPLEMENTATION

feature -- Conversion

	to_compatible (a_value: NATURAL_32): NATURAL_32
		do
			Result := a_value
		end

feature -- Basic operations

	write_value (writeable: EL_WRITABLE; a_value: NATURAL_32)
		do
			writeable.write_natural_32 (a_value)
		end

feature {NONE} -- Implementation

	as_hashable (a_value: NATURAL_32): NATURAL_32
		do
			Result := a_value
		end

	as_integer (n: NATURAL_32): INTEGER
		do
			Result := n.to_integer_32
		end

	enum_value (field: EL_REFLECTED_NATURAL_32): NATURAL_32
		do
			Result := field.value (Current)
		end

	enum_max_value: INTEGER
		local
			n: INTEGER
		do
			Result := n.Max_value
		end

	enum_min_value: INTEGER
		local
			n: INTEGER
		do
			Result := n.Min_value
		end

feature -- Type definitions

	ENUM_FIELD: EL_REFLECTED_NATURAL_32
		once ("PROCESS")
			create Result.make (Current, 1, Default_name)
		end

end