note
	description: "[
		Injects shared string data into an instance of a string conforming to [$source IMMUTABLE_STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-15 11:35:28 GMT (Saturday 15th July 2023)"
	revision: "5"

deferred class
	EL_IMMUTABLE_STRING_MANAGER [C, S -> IMMUTABLE_STRING_GENERAL create make_empty end]

inherit
	REFLECTED_REFERENCE_OBJECT
		rename
			field as i_th_field
	 	export
	 		{NONE} all
	 	redefine
	 		default_create
	 	end

feature {NONE} -- Initialization

	default_create
		do
			create item.make_empty
			make (item)
			field_table := Shared_field_table
		end

feature -- Element change

	set_item (a_area: SPECIAL [C]; offset, a_count: INTEGER)
		local
			item_address: POINTER; field: like field_table
		do
			item_address := object_address; field := field_table
			{ISE_RUNTIME}.set_reference_field (field [Area], item_address, 0, a_area)
			{ISE_RUNTIME}.set_integer_32_field (field [Area_lower], item_address, 0, offset)
			{ISE_RUNTIME}.set_integer_32_field (field [Count], item_address, 0, a_count)
		ensure
			same_substring: same_area_items (a_area, offset, a_count)
		end

feature -- Factory

	new_substring (a_area: SPECIAL [C]; offset, a_count: INTEGER): like item
		do
			set_item (a_area, offset, a_count)
			Result := item.twin
		end

feature {NONE} -- Contract Support

	same_area_items (a_area: SPECIAL [C]; offset, a_count: INTEGER): BOOLEAN
		deferred
		end

feature {NONE} -- Implementation

	new_field_table: SPECIAL [INTEGER]
		require
			item_set: enclosing_object = item
		local
			list: EL_STRING_8_LIST; i, index: INTEGER
		do
			list := Field_names
			create Result.make_filled (0, 3)
			from i := 1 until i > field_count loop
				index := list.index_of (field_name (i), 1)
				if index > 0 then
					Result [index - 1] := i
				end
				i := i + 1
			end
		end

	shared_field_table: SPECIAL [INTEGER]
		deferred
		end

feature {NONE} -- Internal attributes

	field_table: SPECIAL [INTEGER]

feature -- Access

	item: S

feature {NONE} -- Constants

	Area: INTEGER = 0

	Area_lower: INTEGER = 1

	Count: INTEGER = 2

	Field_names: STRING = "area, area_lower, count"

end