note
	description: "Implementation ${EL_ENUMERATION [NATURAL_32]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-24 17:28:20 GMT (Thursday 24th April 2025)"
	revision: "11"

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

	field_value (field: EL_REFLECTED_NATURAL_32): NATURAL_32
		do
			Result := field.value (Current)
		end

	new_field_by_value_table (table: HASH_TABLE [like ENUM_FIELD, NATURAL_32]): EL_NATURAL_32_SPARSE_ARRAY [like ENUM_FIELD]
		do
			create Result.make (table)
		end

feature -- Type definitions

	ENUM_FIELD: EL_REFLECTED_NATURAL_32
		once ("PROCESS")
			create Result.make (Current, 1, Default_name)
		end

end