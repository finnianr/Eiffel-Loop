note
	description: "Match pattern p2 while p1 does not match"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-08 16:58:29 GMT (Tuesday 8th November 2022)"
	revision: "1"

class
	EL_MATCH_P2_WHILE_NOT_P1_MATCH_TP

inherit
	EL_MATCH_LOOP_TP
		rename
			set_action_combined_p1 as set_action_combined_p2
		redefine
			name, make, match_count
		end

create
	make

feature {NONE} -- Initialization

	make (p1, p2: EL_TEXT_PATTERN)
		do
			Precursor (p2, p1)
		end

feature -- Access

	name: STRING
		do
			Result := "while (not " + conditional_pattern.name + "): " + repeated.name
		end

feature {NONE} -- Implementation

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		local
			offset, repeat_count, sum_repeat_count: INTEGER; done: BOOLEAN
		do
			if attached conditional_pattern as final_pattern then
				from offset := a_offset until done loop
					final_pattern.match (offset, text)
					if final_pattern.is_matched then
						done := True
					else
						repeat_count := repeat_match_count (offset, text)
						if repeat_count > 0 then
							offset := offset + repeat_count
							sum_repeat_count := sum_repeat_count + repeat_count
						else
							done := True
						end
					end
				end
				Result := sum_repeat_count + final_pattern.count
			end
			if Result = 0 then
				Result := Match_fail
			end
		end

end