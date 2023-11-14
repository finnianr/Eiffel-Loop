note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source NATURAL_16]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-14 17:25:32 GMT (Tuesday 14th November 2023)"
	revision: "6"

class
	EL_STRING_TO_NATURAL_16

inherit
	EL_READABLE_STRING_GENERAL_TO_NUMERIC [NATURAL_16]
		rename
			numeric_type as type_natural_16
		end

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: NATURAL_16; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_natural_16 (value, index)
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): NATURAL_16
		do
			Result := converted (str).parsed_natural_16
		end

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_16
		do
			Result := converted_substring (str, start_index, end_index).parsed_natural_16
		end

end