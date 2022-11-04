note
	description: "Matches if all patterns in list consecutively match"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-04 8:35:17 GMT (Friday 4th November 2022)"
	revision: "5"

class
	EL_MATCH_ALL_IN_LIST_TP

inherit
	EL_TEXT_PATTERN
		rename
			set_action as set_action_first
		undefine
			copy, is_equal, default_create
		redefine
			make_default, internal_call_actions, has_action, name_list, set_debug_to_depth
		end

	ARRAYED_LIST [EL_TEXT_PATTERN]
		rename
			make as make_list,
			count as list_count,
			do_all as do_for_each
		redefine
			copy
		end

create
	make, make_from_other, make_default

feature {NONE} -- Initialization

	make_default
			--
		do
			make_list (0)
			compare_objects
			Precursor {EL_TEXT_PATTERN}
		end

	make (patterns: ARRAY [EL_TEXT_PATTERN])
			--
		do
			make_default
			make_from_array (patterns)
		end

	make_from_other (other: EL_MATCH_ALL_IN_LIST_TP)
			--
		do
			make_from_array (other.to_array)
		end

feature -- Access

	name: STRING
		do
			Result := "all_of"
		end

	name_list: SPECIAL [STRING]
		local
			l_count, i: INTEGER
		do
			create Result.make_empty (list_count)
			l_count := list_count
			from i := 1 until i > l_count loop
				Result.extend (i_th_sub_pattern (i))
				i := i + 1
			end
		end

	i_th_sub_pattern (i: INTEGER): STRING
		-- i'th pattern description
		do
			create Result.make (20)
			if attached i_th (i) as sub_pattern then
				Result.append (sub_pattern.name)
				if not attached {EL_REPEATED_TEXT_PATTERN} sub_pattern
					and then attached {ARRAYED_LIST [EL_TEXT_PATTERN]} sub_pattern as list
				then
					Result.append (" (")
					across list as l_pattern loop
						if l_pattern.cursor_index > 1 then
							Result.append (", ")
						end
						Result.append (l_pattern.item.name)
					end
					Result.append_character (')')
				end
			end
		end

feature -- Status query

	has_action: BOOLEAN
		do
			Result := Precursor or else across Current as list some list.item.has_action end
		end

feature -- Element change

	set_action_last (action: like actions.item)
			--
		do
			if actions.count < 2 then
				actions := actions.resized_area_with_default (EVENT_ACTION, 2)
			end
			actions [1] := action
		end

	set_debug_to_depth (depth: INTEGER)
			-- For debugging purposes
		do
			Precursor (depth)
			do_for_each (agent {EL_TEXT_PATTERN}.set_debug_to_depth (depth - 1))
		end

	set_patterns (patterns: ARRAY [EL_TEXT_PATTERN])
		do
			make_from_array (patterns)
		end

feature -- Basic operations

	internal_call_actions (start_index, end_index: INTEGER)
		do
			call_i_th_action (1, start_index, end_index)
			call_list_actions (start_index, end_index)
			call_i_th_action (2, start_index, end_index)
		end

feature {NONE} -- Duplication

	copy (other: like Current)
		local
			i, i_final: INTEGER; l_area: like area
		do
			Precursor {ARRAYED_LIST} (other)
			count := other.count
			l_area := area; i_final := list_count
			from until i = i_final loop
				l_area [i] := other.i_th (i + 1).twin
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		local
			offset, i, i_final: INTEGER; l_area: like area
		do
			offset := a_offset
			l_area := area; i_final := list_count
			from until i = i_final or Result < 0 loop
				if attached l_area [i] as sub_pattern then
					sub_pattern.match (offset, text)
					if sub_pattern.is_matched then
						offset := offset + sub_pattern.count
						Result := Result + sub_pattern.count
					else
						Result := Match_fail
					end
				end
				i := i + 1
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		local
			sum_count, l_count, offset: INTEGER
		do
			if count <= text.count - a_offset then
				offset := a_offset
				across Current as sub_pattern until l_count = Match_fail loop
					if sub_pattern.item.is_matched then
						l_count := sub_pattern.item.count
						offset := offset + l_count
						sum_count := sum_count + l_count
					end
				end
				Result := count = sum_count
			end
		end

	call_list_actions (a_start_index, a_end_index: INTEGER)
		local
			i, i_final: INTEGER; l_area: like area
			start_index, end_index: INTEGER
		do
			l_area := area; i_final := list_count
			start_index := a_start_index
			from until i = i_final loop
				if attached l_area [i] as sub_pattern then
					end_index := start_index + sub_pattern.count - 1
					sub_pattern.internal_call_actions (start_index, end_index)
					start_index := start_index + sub_pattern.count
				end
				i := i + 1
			end
		end

end