note
	description: "[
		List of alternative patterns evaluated from left to right until
		a match is found
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_FIRST_MATCH_IN_LIST_TP

inherit
	EL_MATCH_ALL_IN_LIST_TP
		rename
			sub_pattern as alternative,
			pattern_count as alternatives_count
		redefine
			actual_try_to_match,
			collect_middle_events
		end

create
	make, default_create

feature {NONE} -- Implementation

	actual_try_to_match
			-- Try to match one pattern
		do
			from
				start
			until
				off or match_succeeded
			loop
				alternative.set_target (target_text)
				alternative.try_to_match

				if alternative.match_succeeded then
					match_succeeded := true
					count_characters_matched := alternative.count_characters_matched
				else
					forth
				end
			end
		end

	collect_middle_events
		do
--			log.enter_no_header ("collect_middle_events")
--			log.put_integer_field ("Event count",event_list.count)
			if not alternative.event_list.is_empty then
				event_list.collect_from (alternative.event_list)
			end
--			log.put_integer_field (" to",event_list.count)
--			log.put_new_line
--			log.exit_no_trailer
		end

end -- class EL_FIRST_MATCH_IN_LIST_TP

