note
	description: "Convert ${READABLE_STRING_GENERAL} to type ${REAL_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-18 13:03:02 GMT (Saturday 18th November 2023)"
	revision: "7"

class
	EL_STRING_TO_REAL_32

inherit
	EL_READABLE_STRING_GENERAL_TO_REAL [REAL_32]
		rename
			numeric_type as type_real
		end

create
	make

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: REAL_32; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_real_32 (value, index)
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): REAL_32
		do
			Result := converted (str).parsed_double.truncated_to_real
		end

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): REAL_32
		do
			Result := converted_substring (str, start_index, end_index).parsed_double.truncated_to_real
		end

feature {NONE} -- Implementation

	is_real (a_convertor: like Convertor): BOOLEAN
		do
			Result := a_convertor.is_integral_real
		end

end