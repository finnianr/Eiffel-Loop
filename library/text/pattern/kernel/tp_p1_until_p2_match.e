note
	description: "Match pattern **p1** repeatedly until **p2** matches"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:56 GMT (Monday 21st November 2022)"
	revision: "2"

class
	TP_P1_UNTIL_P2_MATCH

inherit
	TP_LOOP
		redefine
			name_inserts, match, meets_definition, Name_template
		end

create
	make

feature {NONE} -- Implementation

	match (a_offset: INTEGER; text: READABLE_STRING_GENERAL)
		local
			offset, repeat_count, sum_repeat_count, l_count: INTEGER; done: BOOLEAN
		do
			matched_count := 0; wipe_out
			if attached conditional_pattern as final_pattern then
				from offset := a_offset until done loop
					repeat_count := match_count (offset, text)
					if repeat_count > 0 then
						if repeat_has_action then
							repeated.internal_call_actions (offset + 1, offset + repeat_count, Current)
						end
						matched_count := matched_count + 1
						offset := offset + repeat_count
						sum_repeat_count := sum_repeat_count + repeat_count
						final_pattern.match (offset, text)
						if final_pattern.is_matched then
							done := True
						end
					else
						done := True
					end
				end
				l_count := sum_repeat_count + final_pattern.count
			end
			if l_count = 0 then
				count := Match_fail
			else
				count := l_count
			end
		end

feature {NONE} -- Implementation

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		local
			l_count: INTEGER
		do
			l_count := count
			count := count - conditional_pattern.count
			if matched_count > 0 implies Precursor (a_offset, text) then
				Result := conditional_pattern.meets_definition (a_offset + count, text)
			end
			count := l_count
		end

	name_inserts: TUPLE
		do
			Result := [repeated.name, conditional_pattern.name]
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "repeat (%S) until (%S)"
		end
end
