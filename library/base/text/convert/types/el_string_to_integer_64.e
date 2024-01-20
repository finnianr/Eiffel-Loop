note
	description: "Convert ${READABLE_STRING_GENERAL} to type ${INTEGER_64}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "9"

class
	EL_STRING_TO_INTEGER_64

inherit
	EL_READABLE_STRING_GENERAL_TO_NUMERIC [INTEGER_64]
		rename
			numeric_type as type_integer_64
		redefine
			is_integer
		end

create
	make

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: INTEGER_64; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_integer_64 (value, index)
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): INTEGER_64
		do
			Result := converted (str).parsed_integer_64
		end

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER_64
		do
			Result := converted_substring (str, start_index, end_index).parsed_integer_64
		end

feature -- Constants

	is_integer: BOOLEAN = True

end