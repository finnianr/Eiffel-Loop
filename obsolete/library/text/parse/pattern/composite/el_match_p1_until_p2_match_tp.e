note
	description: "Match pattern **p1** repeatedly until **p2** matches"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-18 17:54:12 GMT (Friday 18th November 2022)"
	revision: "7"

class
	EL_MATCH_P1_UNTIL_P2_MATCH_TP

inherit
	EL_MATCH_LOOP_TP
		redefine
			name, match_count
		end

create
	make

feature -- Access

	name: STRING
		do
			Result := "() until ()"
			Result.insert_string (repeated.name, 2)
			Result.insert_string (conditional_pattern.name, Result.count)
		end

feature {NONE} -- Implementation

	match_count (text: EL_STRING_VIEW): INTEGER
		local
			l_conditional: like conditional_pattern
			done: BOOLEAN; repeat_count, sum_repeat_count: INTEGER
		do
			l_conditional := conditional_pattern
			from until done loop
				repeat_count := repeat_match_count (text)
				if repeat_count > 0 then
					text.prune_leading (repeat_count)
					sum_repeat_count := sum_repeat_count + repeat_count
					l_conditional.match (text)
					if l_conditional.is_matched then
						done := True
					end
				else
					done := True
				end
			end
			Result := sum_repeat_count + l_conditional.count
			if Result = 0 then
				Result := Match_fail
			end
		end

end