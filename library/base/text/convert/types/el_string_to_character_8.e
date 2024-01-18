note
	description: "Convert ${READABLE_STRING_GENERAL} to type ${CHARACTER_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-18 13:01:51 GMT (Saturday 18th November 2023)"
	revision: "6"

class
	EL_STRING_TO_CHARACTER_8

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [CHARACTER_8]
		redefine
			is_convertible
		end

create
	make

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `CHARACTER_8'
		do
			Result := str.count = 1 and then str.code (1) <= 0xFF
		end

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: CHARACTER_8; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_character (value, index)
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): CHARACTER_8
		do
			if str.count >= 1 then
				Result := str [1].to_character_8
			end
		end

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): CHARACTER_8
		require else
			same_indices: start_index = end_index
		do
			if str.valid_index (start_index) then
				Result := str.item (start_index).to_character_8
			end
		end

end