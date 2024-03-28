note
	description: "List of occurrence intervals of patterns like ${CONTAINER [STRING_GENERAL]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-28 15:47:22 GMT (Thursday 28th March 2024)"
	revision: "1"

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

	PUBLISHER_CONSTANTS

create
	make_sized

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			item_type := [create {ZSTRING}.make_empty, False, 0, 0]
		end

feature -- Status query

	has_parameter_type (code_text: EL_READABLE_ZSTRING): BOOLEAN
		do
			from start until after or Result loop
				Result := item_has_parameter (code_text)
				forth
			end
		end

	item_has_parameter (code_text: EL_READABLE_ZSTRING): BOOLEAN
		-- `True' if `code_text' has '[' in item interval
		local
			i, end_index: INTEGER
		do
			end_index := item_upper - 1
			from i := item_lower + 2 until i > end_index or Result loop
				if code_text.item_8 (i) = '[' then
					Result := True
				end
				i := i + 1
			end
		end

	valid_item (code_text: EL_READABLE_ZSTRING): BOOLEAN
		do
			if code_text.valid_index (item_lower) and then code_text.valid_index (item_upper)
				and then code_text.same_characters (Dollor_left_brace, 1, 2, item_lower)
			then
				Result := code_text [item_upper] = '}'
			end
		end

feature -- Access

	item_type: TUPLE [name: ZSTRING; is_valid: BOOLEAN; start_index, end_index: INTEGER]

feature -- Element change

	fill (code_text: EL_READABLE_ZSTRING)
		local
			right_index: INTEGER
		do
			fill_by_string (code_text, Dollor_left_brace, 0)
			from start until after loop
				right_index := code_text.index_of ('}', item_upper + 1)
				if right_index > 0 then
					put_i_th (item_lower, right_index, index)
					forth
				else
					remove
				end
			end
		end

	update_item_type (code_text: ZSTRING)
		local
			start_index, end_index, name_count: INTEGER
			type_name: ZSTRING; eif: EL_EIFFEL_SOURCE_ROUTINES
		do
			start_index := item_lower + 2; end_index := item_upper - 1
			if attached item_type as type then
				type_name := type.name; type_name.wipe_out
				type.is_valid := False
				type.start_index := start_index
				type.end_index := end_index
				name_count := end_index - start_index + 1
				if 1 <= name_count and name_count <= Max_type_name_count then
					type_name.append_substring (code_text, start_index, end_index)
					type.is_valid := eif.is_type_name (type_name)
				end
			end
		end

feature -- Basic operations

	edit_class_parameters (code_text: ZSTRING)
		local
			buffer: ZSTRING; start_index, end_index: INTEGER
		do
			create buffer.make_empty
			from finish until before loop
				if item_has_parameter (code_text) then
					start_index := item_lower; end_index := item_upper
					buffer.wipe_out; buffer.append_substring (code_text, start_index, end_index)
					enclose_class_parameters (buffer)
					code_text.replace_substring (buffer, start_index, end_index)
				end
				back
			end
		end

feature {NONE} -- Implementation

	enclose_class_parameters (class_link: ZSTRING)
		-- change for example: "${CONTAINER [INTEGER_32]}" to "${CONTAINER} [${INTEGER_32}]"
		local
			eif: EL_EIFFEL_SOURCE_ROUTINES; bracket_index: INTEGER; break: BOOLEAN
		do
			if attached eif.class_parameter_list (class_link) as list then
				from list.finish until list.before loop
					if list.item_count > 1 then
						class_link.insert_character ('}', list.item_upper + 1)
						class_link.insert_string (Dollor_left_brace, list.item_lower)
					end
					list.back
				end
				bracket_index := class_link.index_of ('[', 1)
				if bracket_index > 0 then
					from until break loop
						bracket_index := bracket_index - 1
						if class_link [bracket_index] /= ' ' then
							break := True
						end
					end
					class_link.insert_character ('}', bracket_index + 1)
				end
				class_link.remove_tail (1)
			end
		end

feature {NONE} -- Constants

	Max_type_name_count: INTEGER
		once
			Result := 80
		end

end