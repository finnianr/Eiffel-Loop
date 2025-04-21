note
	description: "List of occurrence intervals of patterns like ${CONTAINER [STRING_GENERAL]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 10:05:36 GMT (Monday 21st April 2025)"
	revision: "17"

class
	CLASS_LINK_OCCURRENCE_INTERVALS

inherit
	EL_ZSTRING_OCCURRENCE_INTERVALS
		rename
			fill as fill_by_character,
			item_type as integer_item_type
		export
			{NONE} all
			{ANY} back, start, forth, after, finish, before, item_lower, item_upper, off
		redefine
			initialize
		end

	EL_EIFFEL_CONSTANTS; PUBLISHER_CONSTANTS

	SHARED_CLASS_TABLE; SHARED_ISE_CLASS_TABLE

create
	make_sized

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create buffer
			create name_buffer
			create class_link_table.make (500)
		end

feature -- Access

	item_class_link (code_text: ZSTRING; link_type: NATURAL_8): CLASS_LINK
		require
			valid_item: not off and link_type > 0
		local
			place_holder, name: ZSTRING; expanded_parameters, routine_name: detachable ZSTRING
			left_brace_index, routine_name_offset: INTEGER; eif: EL_EIFFEL_SOURCE_ROUTINES
		do
			place_holder := buffer.copied_substring (code_text, item_lower, item_upper)
			inspect link_type
				when Link_type_normal then
					name := name_buffer.copied_substring (place_holder, 3, place_holder.count - 1)
				when Link_type_routine then
					name := name_buffer.copied_substring (place_holder, 3, place_holder.count - 1)
					append_routine_name (code_text, place_holder)
					routine_name := place_holder.substring_to_reversed ('.')

				when Link_type_abstract then
					name := name_buffer.copied_substring (place_holder, 3, place_holder.count - 2)
				when Link_type_parameterized then
					expanded_parameters := place_holder.twin
					if attached expanded_parameters as parameters then
						eif.enclose_class_parameters (parameters)
						left_brace_index := parameters.index_of ('}', 3)
						name := name_buffer.copied_substring (parameters, 3, (left_brace_index - 1).max (3))
					end
			else
			end
			if class_link_table.has_key (place_holder) then
			-- need twin possibly different `item_lower' and `item_upper'
				Result := class_link_table.found_item.twin
			else
				Result := new_class_link (name, link_type)
				class_link_table.extend (Result, place_holder.twin)
			end
			if attached expanded_parameters as parameters then
				Result.set_expanded_parameters (parameters)
			end
			if attached routine_name as routine then
				Result.set_routine_name (routine)
				routine_name_offset := routine.count + 1
			end
			Result.set_start_index (item_lower)
			Result.set_end_index (item_upper + routine_name_offset)
		end

	item_debug (code_text: ZSTRING): STRING
		do
			if off then
				create Result.make_empty
			else
				Result := code_text.substring (item_lower, item_upper)
			end
		end

	item_link_type (code_text: ZSTRING): NATURAL_8
		-- one of values: `Link_type_normal', `Link_type_abstract', `Link_type_parameterized'
		-- or zero if link is invalid
		local
			name_count, start_index, end_index, bracket_index, offset: INTEGER
			sg: EL_STRING_GENERAL_ROUTINES
		do
			start_index := item_lower; end_index := item_upper
			if code_text.valid_index (start_index) and then code_text.valid_index (end_index)
				and then code_text.same_characters (Dollor_left_brace, 1, 2, start_index)
				and then code_text [end_index] = '}'
			then
				name_count := end_index - start_index - 2
				if 1 <= name_count and upper_case_count (code_text, start_index, end_index) <= Max_type_name_count then
					bracket_index := index_of_bracket (code_text, start_index + 2, end_index - 1)
					if bracket_index > 0 then
					-- check [] brackets are evenly balanced and finish just before '}'
						if sg.super_z (code_text).matching_bracket_index (bracket_index) = end_index - 1 then
							Result := Link_type_parameterized
						end
					else
						offset := 1
						if code_text [end_index - offset] = '*' then
							offset := 2
						end
						if code_text.is_substring_subset_of_8 (Class_name_character_set, start_index + 2, end_index - offset) then
							inspect offset
								when 1 then
									if code_text.count >= end_index + 2 and then code_text.item_8 (end_index + 1) = '.'
										and then First_letter_character_set.has (code_text.item_8 (end_index + 2))
									then
										Result := Link_type_routine
									else
										Result := Link_type_normal
									end
							else
								Result := Link_type_abstract
							end
						end
					end
				end
			end
		ensure
			valid_result: Result > 0 implies First_link_type <= Result and Result <= Last_link_type
		end

feature -- Element change

	fill (code_text: EL_READABLE_ZSTRING)
		local
			right_index, next_dollor_index: INTEGER
		do
			fill_by_string (code_text, Dollor_left_brace, 0)
			from start until after loop
				right_index := code_text.index_of ('}', item_upper + 1)
				next_dollor_index := if index < count then i_th_lower (index + 1) else code_text.count + 1 end

				if right_index > 0 and right_index < next_dollor_index then
					put_i_th (item_lower, right_index, index)
					forth
				else
					remove
				end
			end
		end

feature {NONE} -- Implementation

	append_routine_name (code_text, place_holder: ZSTRING)
		require
			valid_text: code_text.valid_index (item_upper + 2) and then code_text.item_8 (item_upper + 1) = '.'
		local
			i: INTEGER
		do
			from i := item_upper + 2 until
				i > code_text.count or else not Identifier_character_set.has (code_text.item_8 (i))
			loop
				i := i + 1
			end
			place_holder.append_substring (code_text, item_upper + 1, i - 1)
		end

	index_of_bracket (code_text: EL_READABLE_ZSTRING; start_index, end_index: INTEGER): INTEGER
		local
			i: INTEGER
		do
			from i := start_index until i > end_index or Result > 0 loop
				if code_text.item_8 (i) = '[' then
					Result := i
				else
					i := i + 1
				end
			end
		end

	new_class_link (name: ZSTRING; link_type: NATURAL_8): CLASS_LINK
		do
			if Class_table.has_class (name) then
				create {DEVELOPER_CLASS_LINK} Result.make (Class_table.found_item, name, link_type)

			elseif ISE_class_table.has_class (name) then
				create {ISE_CLASS_LINK} Result.make (ISE_class_table.found_item, name, link_type)
			else
				create {INVALID_CLASS_LINK} Result.make (name, link_type)
			end
		end

	upper_case_count (code_text: EL_READABLE_ZSTRING; start_index, end_index: INTEGER): INTEGER
		local
			i: INTEGER
		do
			from i := start_index until i > end_index loop
				inspect code_text.item_8 (i)
					when 'A' .. 'Z' then
						Result := Result + 1
				else
				end
				i := i + 1
			end
		end

feature {CLASS_LINK_LIST} -- Internal attributes

	buffer: EL_ZSTRING_BUFFER

	class_link_table: EL_ZSTRING_HASH_TABLE [CLASS_LINK]

	name_buffer: EL_ZSTRING_BUFFER

feature {NONE} -- Constants

	Max_type_name_count: INTEGER
		once
			Result := 80
		end

end