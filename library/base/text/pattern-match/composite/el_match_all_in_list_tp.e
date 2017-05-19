note
	description: "Summary description for {EL_MATCH_ALL_IN_LIST_TP2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-17 15:43:37 GMT (Wednesday 17th May 2017)"
	revision: "2"

class
	EL_MATCH_ALL_IN_LIST_TP

inherit
	EL_TEXT_PATTERN
		rename
			set_action as set_action_first
		undefine
			copy, is_equal, default_create
		redefine
			make_default, internal_call_actions, has_action, match, name_list, set_debug_to_depth
		end

	ARRAYED_LIST [EL_TEXT_PATTERN]
		rename
			make as make_list,
			item as sub_pattern,
			count as pattern_count,
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
			l_index: INTEGER
		do
			create Result.make_empty (pattern_count)
			l_index := index
			from start until after loop
				Result.extend (sub_pattern_description)
				forth
			end
			index := l_index
		end

	sub_pattern_description: STRING
		do
			create Result.make (20)
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

feature -- Status query

	has_action: BOOLEAN
		local
			l_index: INTEGER
		do
			Result := Precursor
			if not Result then
				l_index := index
				from start until after or else Result loop
					Result := sub_pattern.has_action
					forth
				end
				index := l_index
			end
		end

feature -- Element change

	set_action_last (action: like actions.item)
			--
		do
			if actions.count < 2 then
				actions := actions.resized_area_with_default (Default_action, 2)
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

	match (text: EL_STRING_VIEW)
		local
			old_interval: like interval
		do
			old_interval := text.interval
			offset := text.offset
			count := match_count (text)
			text.set_interval (old_interval)
		end

	internal_call_actions (text: EL_STRING_VIEW)
		do
			call_i_th_action (1, text)
			call_list_actions (text)
			call_i_th_action (2, text)
		end

feature {NONE} -- Duplication

	copy (other: like Current)
		local
			l_index: INTEGER
		do
			Precursor {ARRAYED_LIST} (other)
			l_index := index
			from start until after loop
				replace (other.i_th (index).twin)
				forth
			end
			index := l_index
		end

feature {NONE} -- Implementation

	match_count (text: EL_STRING_VIEW): INTEGER			--
		do
			from start until after or Result < 0 loop
				sub_pattern.match (text)
				if sub_pattern.is_matched then
					text.prune_leading (sub_pattern.count)
					Result := Result + sub_pattern.count
					forth
				else
					Result := Match_fail
				end
			end
		end

	call_list_actions (text: EL_STRING_VIEW)
		do
			from start until off loop
				sub_pattern.internal_call_actions (text)
				forth
			end
		end

end
