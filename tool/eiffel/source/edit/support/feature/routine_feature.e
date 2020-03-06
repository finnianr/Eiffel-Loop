note
	description: "Routine feature"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-06 13:22:35 GMT (Friday 6th March 2020)"
	revision: "1"

class
	ROUTINE_FEATURE

inherit
	CLASS_FEATURE

create
	make, make_with_lines

feature -- Element change

	expand_shorthand
			-- expand shorthand notation
		local
			pos_at_from, tab_count: INTEGER; from_shorthand_found: BOOLEAN
			line: ZSTRING
		do
			line := lines.first
			across body_interval as n until from_shorthand_found loop
				lines.go_i_th (n.item)
				line := lines.item
				pos_at_from := line.substring_index (From_shorthand, 1)
				if pos_at_from > 0 then
					tab_count := line.leading_occurrences ('%T')
					if tab_count + 1 = pos_at_from then
						from_shorthand_found := True
					end
				end
			end
			if from_shorthand_found then
				replace_line (expanded_from_loop (line.substring_end (pos_at_from + From_shorthand.count + 1)), tab_count)
			end
		end

end
