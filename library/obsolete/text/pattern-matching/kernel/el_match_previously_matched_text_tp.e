note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_MATCH_PREVIOUSLY_MATCHED_TEXT_TP

inherit
	EL_LITERAL_TEXTUAL_PATTERN
		redefine
			actual_try_to_match
		end

create
	make_with_pattern

feature {NONE} -- Initialization

	make_with_pattern (a_pattern: EL_TEXTUAL_PATTERN)
			--
		do
			default_create
			other_pattern := a_pattern
		end

feature {NONE} -- Implementation

	other_pattern: EL_TEXTUAL_PATTERN

	actual_try_to_match
			--
		require else
			pattern_is_matched: other_pattern.match_succeeded
		do
			set_literal_text (other_pattern.text.to_string)
			Precursor
		end
		
end -- class EL_MATCH_PREVIOUSLY_MATCHED_TEXT_TP
