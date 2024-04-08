note
	description: "[
		Injects shared string data into an instance of a string conforming to ${IMMUTABLE_STRING_GENERAL}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-08 9:43:38 GMT (Monday 8th April 2024)"
	revision: "14"

deferred class
	EL_IMMUTABLE_STRING_MANAGER [C, GENERAL -> READABLE_STRING_GENERAL, S -> IMMUTABLE_STRING_GENERAL create make_empty end]

inherit
	EL_OBJECT_MANGER [S]

	STRING_HANDLER
	 	undefine
	 		default_create
	 	end

	EL_STRING_BIT_COUNTABLE [S]

	EL_SIDE_ROUTINES
		export
			{ANY} valid_sides
		end

feature -- Access

	shared_substring (str: GENERAL; start_index, end_index: INTEGER): like new_substring
		local
			l_count: INTEGER
		do
			if attached cursor (str) as c and then attached {SPECIAL [C]} c.area as str_area then
				l_count := end_index - start_index + 1
				Result := new_substring (str_area, c.area_first_index + start_index - 1, l_count)
			end
		end

feature -- Element change

	set_adjusted_item (a_area: SPECIAL [C]; offset, a_count, sides: INTEGER)
		-- set immutable `item' from `a_area' with white space removed from ends specified by `sides'
		-- See class `EL_SIDE'
		require
			valid_count: a_count >= 0
			valid_offset_and_count: a_count > 0 implies a_area.valid_index (offset + a_count - 1)
			valid_sides: valid_sides (sides)
		local
			l_count, l_offset, offset_upper: INTEGER
		do
			l_count := a_count; l_offset := offset
			if has_right_side (sides) then
				from until l_count = 0 or else not is_space (a_area, l_offset + l_count - 1) loop
					l_count := l_count - 1
				end
			end
			if l_count > 0 and has_left_side (sides) then
				offset_upper := l_offset + l_count - 1
				from until l_offset > offset_upper or else not is_space (a_area, l_offset) loop
					l_offset := l_offset + 1
					l_count := l_count - 1
				end
			end
			set_item (a_area, l_offset, l_count)
		ensure
			adjusted_left: has_left_side (sides) implies not item_has_left_padding
			adjusted_right: has_right_side (sides) implies not item_has_right_padding
		end

	set_item (a_area: SPECIAL [C]; offset, a_count: INTEGER)
		require
			valid_count: a_count >= 0
			valid_offset_and_count: a_count > 0 implies a_area.valid_index (offset + a_count - 1)
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
			if str.is_immutable and then attached {like item} str as immutable then
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

	new_item: S
		do
			create Result.make_empty
		end

feature {NONE} -- Deferred

	cursor (str: GENERAL): EL_STRING_ITERATION_CURSOR
		deferred
		end

	is_space (a_area: SPECIAL [C]; i: INTEGER): BOOLEAN
		deferred
		end

	item_has_left_padding: BOOLEAN
		deferred
		end

	item_has_right_padding: BOOLEAN
		deferred
		end

	string_area (str: GENERAL): SPECIAL [C]
		deferred
		end

feature {NONE} -- Constants

	Area: INTEGER = 0

	Area_lower: INTEGER = 1

	Count: INTEGER = 2

	Field_names: STRING = "area, area_lower, count, internal_case_insensitive_hash_code, internal_hash_code"

end