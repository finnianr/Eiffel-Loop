note
	description: "Summary description for {EL_MATCH_TP1_WHILE_NOT_TP2_MATCH_TP2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-11 12:21:51 GMT (Monday 11th January 2016)"
	revision: "5"

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

	match_count (text: EL_STRING_VIEW): INTEGER
		local
			l_conditional: like conditional_pattern
			done: BOOLEAN; repeat_count, sum_repeat_count: INTEGER
		do
			l_conditional := conditional_pattern
			from until done loop
				l_conditional.match (text)
				if l_conditional.is_matched then
					done := True
				else
					repeat_count := repeat_match_count (text)
					if repeat_count > 0 then
						text.prune_leading (repeat_count)
						sum_repeat_count := sum_repeat_count + repeat_count
					else
						done := True
					end
				end
			end
			Result := sum_repeat_count + l_conditional.count
			if Result = 0 then
				Result := Match_fail
			end
		end

end