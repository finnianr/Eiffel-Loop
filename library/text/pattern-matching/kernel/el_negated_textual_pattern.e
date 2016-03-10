note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_NEGATED_TEXTUAL_PATTERN

inherit
	EL_TEXTUAL_PATTERN

create
	make

feature {NONE} -- Initialization

	make (pattern: like Type_negated_pattern)
			--
		do
			default_create
			negated_pattern := pattern
			action_on_match := negated_pattern.action_on_match
		end

feature {NONE} -- Implementation

	actual_try_to_match
			-- Try to match one pattern
		do
			negated_pattern.set_target (target_text)
			negated_pattern.try_to_match

			if not_match_succeeded then
				match_succeeded := true
				count_characters_matched := actual_count_characters_matched
			end
		end

	not_match_succeeded: BOOLEAN
			--
		do
			Result := target_text.count = 0 or else not negated_pattern.match_succeeded
		end

feature {NONE, EL_NEGATED_TEXTUAL_PATTERN} -- Implementation

	negated_pattern: like Type_negated_pattern

	actual_count_characters_matched: INTEGER
			--
		do
			Result := 0
		end

feature {NONE} -- Anchored type

	Type_negated_pattern: EL_TEXTUAL_PATTERN
		do
		end

end -- class EL_NEGATED_TEXTUAL_PATTERN

