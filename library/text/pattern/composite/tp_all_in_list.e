note
	description: "Matches if all patterns in list consecutively match"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 5:45:41 GMT (Thursday 17th August 2023)"
	revision: "8"

class
	TP_ALL_IN_LIST

inherit
	TP_PATTERN
		rename
			set_action as set_action_first
		undefine
			copy, is_equal, default_create
		redefine
			first_searchable, internal_call_actions, action_count, name_list, set_debug_to_depth
		end

	EL_ARRAYED_LIST [TP_PATTERN]
		rename
			make as make_list,
			count as list_count,
			do_all as do_for_each
		end

	EL_CHARACTER_8_CONSTANTS

create
	make, make_from_other, make_default, make_separated

feature {NONE} -- Initialization

	make_separated (patterns: ARRAY [TP_PATTERN]; white_space: TP_WHITE_SPACE)
		-- make list of patterns separated by specified `white_space' pattern
		do
			make_list (patterns.count * 2 - 1)
			compare_objects
			across patterns as list loop
--				Make sure a new `white_space' instance is inserted between each pattern.
--				This ensures that the `meets_definition' post condition for `match' will not fail unexpectedly
				inspect list_count
					when 0 then
						do_nothing
					when 1 then
						extend (white_space)
				else
					extend (white_space.twin)
				end
				extend (list.item)
			end
		ensure
			correct_number_inserted: list_count = patterns.count * 2 - 1
		end

	make (patterns: ARRAY [TP_PATTERN])
			--
		do
			make_default
			make_from_array (patterns)
		end

	make_default
			--
		do
			make_list (0)
			compare_objects
		end

	make_from_other (other: TP_ALL_IN_LIST)
			--
		do
			make_from_array (other.to_array)
		end

feature -- Access

	name_list: SPECIAL [STRING]
		do
			Result := new_name_list (False).area
		end

feature -- Measurement

	action_count: INTEGER
		do
			Result := Precursor + list_action_count
		end

feature -- Element change

	set_action_last (action: PROCEDURE [INTEGER, INTEGER])
			--
		do
			set_i_th_action (2, action)
		end

	set_debug_to_depth (depth: INTEGER)
			-- For debugging purposes
		do
			Precursor (depth)
			do_for_each (agent {TP_PATTERN}.set_debug_to_depth (depth - 1))
		end

	set_patterns (patterns: ARRAY [TP_PATTERN])
		do
			make_from_array (patterns)
		end

feature {NONE} -- Implementation

	call_list_actions (a_start_index, a_end_index: INTEGER; repeated: detachable TP_REPEATED_PATTERN)
		local
			i, i_final: INTEGER; l_area: like area
			start_index, end_index: INTEGER
		do
			l_area := area; i_final := list_count
			start_index := a_start_index
			from until i = i_final loop
				if attached l_area [i] as sub_pattern then
					end_index := start_index + sub_pattern.count - 1
					sub_pattern.internal_call_actions (start_index, end_index, repeated)
					start_index := start_index + sub_pattern.count
				end
				i := i + 1
			end
		end

	count_list: EL_STRING_8_LIST
		do
			Result := string_8_list (agent item_count)
		end

	first_searchable: detachable TP_SEARCHABLE
		do
			if list_count > 0 then
				Result := i_th (1).first_searchable
			end
		end

	item_count (p: TP_PATTERN): STRING
		do
			Result := p.count.out
		end

	internal_call_actions (start_index, end_index: INTEGER; repeated: detachable TP_REPEATED_PATTERN)
		do
			if attached actions_array as array then
				call_action (array [0], start_index, end_index, repeated)
				call_list_actions (start_index, end_index, repeated)
				if array.valid_index (1) then
					call_action (array [1], start_index, end_index, repeated)
				end
			else
				call_list_actions (start_index, end_index, repeated)
			end
		end

	list_action_count: INTEGER
		do
			Result := sum_integer (agent {TP_PATTERN}.action_count)
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		local
			offset, i, i_final: INTEGER; l_area: like area
			failed: BOOLEAN
		do
			offset := a_offset
			l_area := area; i_final := list_count
			from until i = i_final or failed loop
				if attached l_area [i] as sub_pattern then
					sub_pattern.match (offset, text)
					if sub_pattern.is_matched then
						offset := offset + sub_pattern.count
					else
						failed := True
					end
				end
				i := i + 1
			end
			if failed then
				Result := Match_fail
			else
				Result := offset - a_offset
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		local
			offset: INTEGER; sub_pattern: TP_PATTERN
			failed: BOOLEAN
		do
			offset := a_offset
			across Current as list until failed loop
				sub_pattern := list.item
				if sub_pattern.is_matched then
					offset := offset + sub_pattern.count
				else
					failed := True
				end
			end
			Result := not failed and then count = offset - a_offset
		end

	name_inserts: TUPLE
		do
			Result := [new_name_list (True).comma_separated]
		end

	new_name_list (curtailed: BOOLEAN): EL_STRING_8_LIST
		local
			done: BOOLEAN
		do
			create Result.make (list_count)
			across Current as list until done loop
				if curtailed then
					Result.extend (list.item.curtailed_name)
				else
					Result.extend (list.item.name)
				end
				if curtailed and then Result.character_count > 200 then
					done := True
					if not list.is_last then
						Result.extend (dot * 2)
					end
				end
			end
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "all_of (%S)"
		end

end