note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source NATURAL_64]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-15 13:39:58 GMT (Wednesday 15th March 2023)"
	revision: "5"

class
	EL_STRING_TO_NATURAL_64

inherit
	EL_READABLE_STRING_GENERAL_TO_NUMERIC [NATURAL_64]
		rename
			numeric_type as type_natural_64
		end

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: NATURAL_64; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_natural_64 (value, index)
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): NATURAL_64
		do
			Result := converted (str).parsed_natural_64
		end

end