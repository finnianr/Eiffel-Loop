note
	description: "Implementation ${EL_ENUMERATION [NATURAL_16]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-28 18:58:02 GMT (Wednesday 28th August 2024)"
	revision: "7"

deferred class
	EL_ENUMERATION_NATURAL_16

inherit
	EL_ENUMERATION [NATURAL_16]
		rename
			enumeration_type as natural_16_type
		end

	EL_16_BIT_IMPLEMENTATION

feature -- Conversion

	to_compatible (a_value: NATURAL_32): NATURAL_16
		do
			Result := a_value.to_natural_16
		end

feature -- Basic operations

	write_value (writeable: EL_WRITABLE; a_value: NATURAL_16)
		do
			writeable.write_natural_16 (a_value)
		end

feature {NONE} -- Implementation

	as_hashable (a_value: NATURAL_16): NATURAL_16
		do
			Result := a_value
		end

	as_integer (n: NATURAL_16): INTEGER
		do
			Result := n.to_integer_32
		end

	enum_value (field: EL_REFLECTED_NATURAL_16): NATURAL_16
		do
			Result := field.value (Current)
		end

	enum_value_bytes: INTEGER
		do
			Result := {PLATFORM}.Natural_16_bytes
		end

	max_value: INTEGER
		local
			n: NATURAL_16
		do
			Result := n.Max_value
		end

	min_value: INTEGER
		local
			n: NATURAL_16
		do
			Result := n.Min_value
		end

feature -- Type definitions

	ENUM_FIELD: EL_REFLECTED_NATURAL_16
		once ("PROCESS")
			create Result.make (Current, 1, Default_name)
		end

end