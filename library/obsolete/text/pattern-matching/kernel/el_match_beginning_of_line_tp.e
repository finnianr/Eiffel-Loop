note
	description: "Objects that matches start of new line"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

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
			if text.is_start_of_line then
				match_succeeded := true
				count_characters_matched := 0
			end
		end

end -- class EL_MATCH_BEGINNING_OF_LINE_TP
