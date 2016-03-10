note
	description: "Objects that matches start of new line"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MATCH_BEGINNING_OF_LINE_TP

inherit
	EL_TEXTUAL_PATTERN

create
	default_create

feature {NONE} -- Implementation

	actual_try_to_match
			--
		do
			if target_text.is_start_of_line then
				match_succeeded := true
				count_characters_matched := 0
			end
		end

end -- class EL_MATCH_BEGINNING_OF_LINE_TP
