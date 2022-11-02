note
	description: "Matches first pattern in list that matches"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-02 7:47:35 GMT (Wednesday 2nd November 2022)"
	revision: "1"

class
	EL_FIRST_MATCH_IN_LIST_TP

inherit
	EL_MATCH_ALL_IN_LIST_TP
		redefine
			match_count, meets_definition, call_list_actions, name
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
			if count <= text.count - a_offset and then valid_index (match_index) then
				Result := count = i_th (match_index).match_count (a_offset, text)
			end
		end

feature -- Access

	name: STRING
		do
			Result := "one_of"
		end

feature {NONE} -- Implementation

	call_list_actions (a_start_index, a_end_index: INTEGER)
		do
			if valid_index (match_index) then
				i_th (match_index).internal_call_actions (a_start_index, a_end_index)
			end
		end

feature {NONE} -- Internal attributes

	match_index: INTEGER
end