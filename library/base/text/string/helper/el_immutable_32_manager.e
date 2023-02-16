note
	description: "Forces shared string data into an instance of [$source IMMUTABLE_STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-16 11:40:34 GMT (Thursday 16th February 2023)"
	revision: "2"

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
			field_table := Shared_field_table
		end

feature -- Access

	item: IMMUTABLE_STRING_32

feature -- Factory

	new_substring (a_area: SPECIAL [CHARACTER_32]; offset, a_count: INTEGER): IMMUTABLE_STRING_32
		do
			set_item (a_area, offset, a_count)
			Result := item.twin
		end

feature -- Element change

	set_item (a_area: SPECIAL [CHARACTER_32]; offset, a_count: INTEGER)
		local
			item_address: POINTER; field: like field_table
		do
			item_address := object_address; field := field_table
			{ISE_RUNTIME}.set_reference_field (field [Area], item_address, 0, a_area)
			{ISE_RUNTIME}.set_integer_32_field (field [Area_lower], item_address, 0, offset)
			{ISE_RUNTIME}.set_integer_32_field (field [Count], item_address, 0, a_count)
		ensure
			same_substring:
				attached cursor_32 (item) as c and then c.area.same_items (a_area, offset, c.area_first_index, count)
		end

feature {NONE} -- Internal attributes

	field_table: SPECIAL [INTEGER]

feature {NONE} -- Constants

	Area: INTEGER = 0

	Area_lower: INTEGER = 1

	Count: INTEGER = 2

	Shared_field_table: SPECIAL [INTEGER]
		require
			item_set: enclosing_object = item
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