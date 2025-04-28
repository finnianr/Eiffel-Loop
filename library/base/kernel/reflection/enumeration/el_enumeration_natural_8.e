note
	description: "Implementation ${EL_ENUMERATION [NATURAL_8]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 13:34:52 GMT (Monday 28th April 2025)"
	revision: "12"

deferred class
	EL_ENUMERATION_NATURAL_8

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			enum_type as natural_8_type
		end

	EL_8_BIT_IMPLEMENTATION

feature -- Basic operations

	write_value (writeable: EL_WRITABLE; a_value: NATURAL_8)
		do
			writeable.write_natural_8 (a_value)
		end

feature {NONE} -- Implementation

	as_code (a_value: INTEGER): NATURAL_8
		do
			Result := a_value.to_natural_8
		end

	as_integer (a_value: NATURAL_8): INTEGER
		do
			Result := a_value.to_integer_32
		end

	field_value (field: EL_REFLECTED_NATURAL_8): NATURAL_8
		do
			Result := field.value (Current)
		end

	new_field_by_value_table (table: HASH_TABLE [like ENUM_FIELD, NATURAL_8]): EL_NATURAL_8_SPARSE_ARRAY [like ENUM_FIELD]
		do
			create Result.make (table)
		end

	new_interval_table: like default_interval_table
		do
			create Result.make (new_interval_hash_table (field_list))
		end

feature -- Type definitions

	ENUM_FIELD: EL_REFLECTED_NATURAL_8
		once ("PROCESS")
			create Result.make (Current, 1, Default_name)
		end

feature {NONE} -- Constants

	Default_interval_table: EL_NATURAL_8_SPARSE_ARRAY [INTEGER_64]
		once
			create Result.make_empty
		end

end