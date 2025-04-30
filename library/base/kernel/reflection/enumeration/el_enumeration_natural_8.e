note
	description: "Implementation ${EL_ENUMERATION [NATURAL_8]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-30 12:20:15 GMT (Wednesday 30th April 2025)"
	revision: "14"

deferred class
	EL_ENUMERATION_NATURAL_8

inherit
	EL_ENUMERATION [NATURAL_8]

	EL_8_BIT_IMPLEMENTATION

feature -- Basic operations

	write_value (writeable: EL_WRITABLE; a_value: NATURAL_8)
		do
			writeable.write_natural_8 (a_value)
		end

feature {NONE} -- Implementation

	as_enum (a_value: INTEGER): NATURAL_8
		do
			Result := a_value.to_natural_8
		end

	as_integer (a_value: NATURAL_8): INTEGER
		do
			Result := a_value.to_integer_32
		end

	new_field_name_table (table: HASH_TABLE [IMMUTABLE_STRING_8, NATURAL_8]): EL_NATURAL_8_SPARSE_ARRAY [IMMUTABLE_STRING_8]
		do
			create Result.make (table)
		end

	new_interval_table (field_list: EL_FIELD_LIST): like default_interval_table
		do
			create Result.make (new_interval_hash_table (field_list))
		end

feature {NONE} -- Constants

	Default_interval_table: EL_NATURAL_8_SPARSE_ARRAY [INTEGER_64]
		once
			create Result.make_empty
		end

end