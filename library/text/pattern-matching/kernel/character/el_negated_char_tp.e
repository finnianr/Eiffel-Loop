note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_NEGATED_CHAR_TP

inherit
	EL_SINGLE_CHAR_TEXTUAL_PATTERN

	EL_NEGATED_TEXTUAL_PATTERN
		undefine
			logical_not
		redefine
			Type_negated_pattern, actual_count_characters_matched, not_match_succeeded
		end

create
	make

feature {NONE} -- Implementation

	not_match_succeeded: BOOLEAN
			--
		do
			Result := target_text.count >= 1 and then not negated_pattern.match_succeeded
		end

	Actual_count_characters_matched: INTEGER = 1

feature {NONE} -- Anchored type

	Type_negated_pattern: EL_SINGLE_CHAR_TEXTUAL_PATTERN
		do
		end

end -- class EL_NEGATED_CHAR_TP

