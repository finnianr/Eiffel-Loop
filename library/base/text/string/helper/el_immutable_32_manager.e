note
	description: "Manager to inject data into instance of [$source IMMUTABLE_STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-11 11:19:04 GMT (Saturday 11th February 2023)"
	revision: "1"

class
	EL_IMMUTABLE_32_MANAGER

inherit
	REFLECTED_REFERENCE_OBJECT
		rename
			field as i_th_field
	 	export
	 		{NONE} all
	 	redefine
	 		default_create
	 	end

	EL_SHARED_STRING_32_CURSOR

feature {NONE} -- Initialization

	default_create
		do
			create item.make_empty
			make (item)
		end

feature -- Access

	item: IMMUTABLE_STRING_32

feature -- Element change

	set_item (a_item: like item)
		do
			item := a_item
			make (a_item)
		end

	set_item_substring (a_area: SPECIAL [CHARACTER_32]; offset, a_count: INTEGER)
		do
			set_reference_field (Field [Area], a_area)
			set_integer_32_field (Field [Area_lower], offset)
			set_integer_32_field (Field [Count], a_count)
		ensure
			same_substring:
				attached cursor_32 (item) as c and then c.area.same_items (a_area, offset, c.area_first_index, count)
		end

feature {NONE} -- Constants

	Area: INTEGER = 0

	Area_lower: INTEGER = 1

	Count: INTEGER = 2

	Field: SPECIAL [INTEGER]
		local
			list: EL_STRING_8_LIST; i, index: INTEGER
		once
			list := "area, area_lower, count"
			create Result.make_filled (0, 3)
			from i := 1 until i > field_count loop
				index := list.index_of (field_name (i), 1)
				if index > 0 then
					Result [index - 1] := i
				end
				i := i + 1
			end
		end

end