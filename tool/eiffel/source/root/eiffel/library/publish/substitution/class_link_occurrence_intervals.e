note
	description: "List of occurrence intervals of patterns like ${CONTAINER [STRING_GENERAL]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-01 15:34:22 GMT (Monday 1st April 2024)"
	revision: "5"

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

	EL_SHARED_ZSTRING_CURSOR
		rename
			cursor as z_cursor
		end

	EL_EIFFEL_CONSTANTS; PUBLISHER_CONSTANTS

	SHARED_CLASS_PATH_TABLE; SHARED_ISE_CLASS_TABLE

create
	make_sized

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create buffer
			create name_buffer
			create class_link_table.make_size (500)
		end

feature -- Status query

	item_link_type (code_text: EL_READABLE_ZSTRING): NATURAL_8
		-- one of values: `Link_type_normal', `Link_type_abstract', `Link_type_parameterized'
		-- or zero if link is invalid
		local
			name_count, start_index, end_index, bracket_index, offset: INTEGER
		do
			start_index := item_lower; end_index := item_upper
			if code_text.valid_index (start_index) and then code_text.valid_index (end_index)
				and then code_text.same_characters (Dollor_left_brace, 1, 2, start_index)
				and then code_text [end_index] = '}'
			then
				name_count := end_index - start_index - 2
				if 1 <= name_count and name_count <= Max_type_name_count then
					bracket_index := index_of_bracket (code_text, start_index + 2, end_index - 1)
					if bracket_index > 0 then
					-- check [] brackets are evenly balanced and finish just before '}'
						if z_cursor (code_text).matching_bracket_index (bracket_index) = end_index - 1 then
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
									Result := Link_type_normal
							else
								Result := Link_type_abstract
							end
						end
					end
				end
			end
		ensure
			valid_result: Result > 0 implies Link_type_normal <= Result and Result <= Link_type_parameterized
		end

feature -- Access

	item_debug (code_text: ZSTRING): STRING
		do
			if off then
				create Result.make_empty
			else
				Result := code_text.substring (item_lower, item_upper)
			end
		end

	item_class_link (code_text: ZSTRING; link_type: NATURAL_8): CLASS_LINK
		require
			valid_item: not off and link_type > 0
		local
			place_holder, name: ZSTRING; expanded_parameters: detachable ZSTRING
			left_brace_index: INTEGER
		do
			place_holder := buffer.copied_substring (code_text, item_lower, item_upper)
			inspect link_type
				when Link_type_normal then
					name := name_buffer.copied_substring (place_holder, 3, place_holder.count - 1)
				when Link_type_abstract then
					name := name_buffer.copied_substring (place_holder, 3, place_holder.count - 2)
				when Link_type_parameterized then
					expanded_parameters := place_holder.twin
					if attached expanded_parameters as parameters then
						enclose_class_parameters (parameters)
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
			Result.set_start_index (item_lower)
			Result.set_end_index (item_upper)
		end

feature -- Element change

	fill (code_text: EL_READABLE_ZSTRING)
		local
			right_index, next_dollor_index: INTEGER
		do
			fill_by_string (code_text, Dollor_left_brace, 0)
			from start until after loop
				right_index := code_text.index_of ('}', item_upper + 1)
				if index < count then
					next_dollor_index := i_th_lower (index + 1)
				else
					next_dollor_index := code_text.count + 1
				end
				if right_index > 0 and right_index < next_dollor_index then
					put_i_th (item_lower, right_index, index)
					forth
				else
					remove
				end
			end
		end

feature {NONE} -- Implementation

	enclose_class_parameters (class_link: ZSTRING)
		-- change for example: "${CONTAINER* [INTEGER_32]}" to "${CONTAINER*} [${INTEGER_32}]"
		local
			eif: EL_EIFFEL_SOURCE_ROUTINES; bracket_index: INTEGER; break: BOOLEAN
		do
			if attached eif.class_parameter_list (class_link) as list then
				from list.finish until list.before loop
					if list.item_count > 3 then -- Excludes: G, KEY, ANY
						class_link.insert_character ('}', list.item_upper + 1)
						class_link.insert_string (Dollor_left_brace, list.item_lower)
					end
					list.back
				end
			-- Go backwards from '[' until last character of class name is found
				bracket_index := class_link.index_of ('[', 1)
				if bracket_index > 0 then
					from until break or bracket_index = 0 loop
						bracket_index := bracket_index - 1
						if class_link [bracket_index].is_alpha_numeric then
							break := True
						end
					end
					class_link.insert_character ('}', bracket_index + 1)
				end
				class_link.remove_tail (1)
			end
		-- "}*" -> "*}"
			class_link.replace_substring_all (Brace_asterisk, Asterisk_brace)
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
			if Class_path_table.has_class (name) then
				create {DEVELOPER_CLASS_LINK} Result.make (Class_path_table.found_item, name, link_type)

			elseif ISE_class_table.has_class (name) then
				create {ISE_CLASS_LINK} Result.make (ISE_class_table.found_item, name, link_type)
			else
				create Result.make (Invalid_class, name, link_type)
			end
		end

feature {NONE} -- Internal attributes

	buffer: EL_ZSTRING_BUFFER

	name_buffer: EL_ZSTRING_BUFFER

	class_link_table: EL_ZSTRING_HASH_TABLE [CLASS_LINK]

feature {NONE} -- Constants

	Asterisk_brace: ZSTRING
		once
			Result := "}*"
		end

	Brace_asterisk: ZSTRING
		once
			Result := "*}"
		end

	Max_type_name_count: INTEGER
		once
			Result := 80
		end

	Invalid_class: FILE_PATH
		once
			Result := "invalid-class-name"
		end

end