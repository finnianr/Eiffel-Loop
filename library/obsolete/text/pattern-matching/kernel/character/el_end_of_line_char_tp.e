note
	description: "Objects that matches new line or EOF"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_END_OF_LINE_CHAR_TP

inherit
	EL_LITERAL_CHAR_TP
		rename
			make as make_with_code,
			make_with_action as make_literal_with_action
		redefine
			actual_try_to_match
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_with_code ({ASCII}.Line_feed.to_natural_32)
		end

feature {NONE} -- Implementation

	actual_try_to_match
			--
		do
			Precursor
			-- Match succeeds if we are trying to match past the end of the target text
			if not match_succeeded and text.count = 0 then
				match_succeeded := true
				count_characters_matched := 0
			end
		end

end -- class EL_END_OF_LINE_CHAR_TP

