note
	description: "${INTEGER_16} enumeration with descriptive text table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 17:09:19 GMT (Monday 28th April 2025)"
	revision: "8"

deferred class
	EL_TABLE_ENUMERATION_INTEGER_16

inherit
	EL_TEXT_TABLE_ENUMERATION [INTEGER_16]

feature {NONE} -- Implementation

	as_enum (a_value: INTEGER): INTEGER_16
		do
			Result := a_value.to_integer_16
		end

	as_integer (a_value: INTEGER_16): INTEGER
		do
			Result := a_value.to_integer
		end

	new_interval_table (hash_table: HASH_TABLE [INTEGER_64, INTEGER_16]): EL_INTEGER_16_SPARSE_ARRAY [INTEGER_64]
		do
			create Result.make (hash_table)
		end

end