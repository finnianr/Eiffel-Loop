note
	description: "Convert ${READABLE_STRING_GENERAL} to type ${REAL_64}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "8"

class
	EL_STRING_TO_REAL_64

inherit
	EL_READABLE_STRING_GENERAL_TO_REAL [REAL_64]
		rename
			numeric_type as type_double
		end

create
	make

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: REAL_64; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_real_64 (value, index)
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): REAL_64
		do
			Result := converted (str).parsed_double
		end

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): REAL_64
		do
			Result := converted_substring (str, start_index, end_index).parsed_double
		end

feature {NONE} -- Implementation

	is_real (a_convertor: like Convertor): BOOLEAN
		do
			Result := a_convertor.is_integral_double
		end

end