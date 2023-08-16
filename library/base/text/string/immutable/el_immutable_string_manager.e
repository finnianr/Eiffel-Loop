note
	description: "[
		Injects shared string data into an instance of a string conforming to [$source IMMUTABLE_STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-30 16:01:48 GMT (Sunday 30th July 2023)"
	revision: "7"

deferred class
	EL_IMMUTABLE_STRING_MANAGER [C, GENERAL -> READABLE_STRING_GENERAL, S -> IMMUTABLE_STRING_GENERAL create make_empty end]

inherit
	REFLECTED_REFERENCE_OBJECT
		rename
			field as i_th_field
	 	export
	 		{NONE} all
	 	redefine
	 		default_create
	 	end

	 EL_STRING_BIT_COUNTABLE [S]

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
			item_address: POINTER; i, index, value: INTEGER
		do
			item_address := object_address
			if attached field_table as field then
				from until i = field.count loop
					index := field [i]
					if i = Area then
						{ISE_RUNTIME}.set_reference_field (index, item_address, 0, a_area)
					else
						-- set INTEGER values
						inspect i
							when Area_lower then
								value := offset
							when Count then
								value := a_count
						else
						--	hash codes including case insensitive
							value := 0
						end
						{ISE_RUNTIME}.set_integer_32_field (index, item_address, 0, value)
					end
					i := i + 1
				end
			end
		ensure
			same_substring: same_area_items (a_area, offset, a_count)
		end

feature -- Factory

	new_substring (a_area: SPECIAL [C]; offset, a_count: INTEGER): like item
		do
			set_item (a_area, offset, a_count)
			Result := item.twin
		end

feature -- Conversion

	as_shared (str: GENERAL): like item
		do
			if attached {like item} str as immutable then
				Result := immutable
			else
				Result := new_substring (string_area (str), 0, str.count)
			end
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
			create Result.make_filled (0, list.count)
			from i := 1 until i > field_count loop
				index := list.index_of (field_name (i), 1)
				if index > 0 then
					Result [index - 1] := i
				end
				i := i + 1
			end
		end

	string_area (str: GENERAL): SPECIAL [C]
		deferred
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

	Field_names: STRING = "area, area_lower, count, internal_case_insensitive_hash_code, internal_hash_code"

end