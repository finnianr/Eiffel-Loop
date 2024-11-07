note
	description: "Convert ${READABLE_STRING_GENERAL} to type ${BOOLEAN}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-05 15:23:38 GMT (Tuesday 5th November 2024)"
	revision: "8"

class
	EL_STRING_TO_BOOLEAN

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [BOOLEAN]
		redefine
			is_convertible
		end

create
	make

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `BOOLEAN'
		do
			Result := str.is_boolean
		end

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: BOOLEAN; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_boolean (value, index)
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := str.to_boolean
		end

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): BOOLEAN
		local
			buffer: EL_STRING_8_BUFFER
		do
			Result := buffer.copied_substring_general (str, start_index, end_index).to_boolean
		end

end