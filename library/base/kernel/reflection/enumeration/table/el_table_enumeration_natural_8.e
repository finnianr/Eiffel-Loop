note
	description: "${NATURAL_8} enumeration with descriptive text specifing fields"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 17:09:25 GMT (Monday 28th April 2025)"
	revision: "1"

deferred class
	EL_TABLE_ENUMERATION_NATURAL_8

inherit
	EL_TEXT_TABLE_ENUMERATION [NATURAL_8]

feature {NONE} -- Implementation

	as_enum (a_value: INTEGER): NATURAL_8
		do
			Result := a_value.to_natural_8
		end

	as_integer (a_value: NATURAL_8): INTEGER
		do
			Result := a_value.to_integer_32
		end

	new_interval_table (hash_table: HASH_TABLE [INTEGER_64, NATURAL_8]): EL_NATURAL_8_SPARSE_ARRAY [INTEGER_64]
		do
			create Result.make (hash_table)
		end

end