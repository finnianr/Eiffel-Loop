note
	description: "Matches first pattern in list that matches"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:25:00 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_FIRST_MATCH_IN_LIST

inherit
	TP_ALL_IN_LIST
		redefine
			list_action_count, match_count, meets_definition, call_list_actions, Name_template
		end

create
	make

feature {NONE} -- Implementation

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			-- Try to match one pattern
		local
			offset, i, i_final: INTEGER; l_area: like area
			match_found: BOOLEAN
		do
			offset := a_offset
			l_area := area; i_final := list_count
			from until i = i_final or match_found loop
				if attached l_area [i] as sub_pattern then
					sub_pattern.match (offset, text)
					if sub_pattern.is_matched then
						match_found := True
						Result := Result + sub_pattern.count
					end
				end
				i := i + 1
			end
			if match_found then
				match_index := i
			else
				Result := Match_fail
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		do
			if valid_index (match_index) then
				if across 1 |..| (match_index - 1) as n all i_th (n.item).count = Match_fail end then
					Result := i_th (match_index).count = count
				end
			end
		end

feature {NONE} -- Implementation

	call_list_actions (a_start_index, a_end_index: INTEGER; repeated: detachable TP_REPEATED_PATTERN)
		do
			if valid_index (match_index) then
				i_th (match_index).internal_call_actions (a_start_index, a_end_index, repeated)
			end
		end

	list_action_count: INTEGER
		-- maximum count
		local
			l_count: INTEGER
		do
			across Current as pattern loop
				l_count := pattern.item.action_count
				if l_count > Result then
					Result := l_count
				end
			end
		end

feature {NONE} -- Internal attributes

	match_index: INTEGER

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "one_of (%S)"
		end
end

