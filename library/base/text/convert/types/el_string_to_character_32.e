note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source CHARACTER_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-18 13:01:54 GMT (Saturday 18th November 2023)"
	revision: "7"

class
	EL_STRING_TO_CHARACTER_32

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [CHARACTER_32]
		redefine
			is_convertible, is_latin_1
		end

create
	make

feature -- Status query

	is_latin_1: BOOLEAN = False
		-- `True' if type can be always be represented by Latin-1 encoded string

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `CHARACTER_32'
		do
			Result := str.count = 1
		end

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: CHARACTER_32; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_character_32 (value, index)
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): CHARACTER_32
		do
			if str.count >= 1 then
				Result := str.item (1)
			end
		end

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): CHARACTER_32
		require else
			same_indices: start_index = end_index
		do
			if str.valid_index (start_index) then
				Result := str.item (start_index)
			end
		end

end