note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 13:09:50 GMT (Sunday 28th July 2013)"
	revision: "3"

class
	EL_LITERAL_TEXTUAL_PATTERN

inherit
	EL_TEXTUAL_PATTERN
		redefine
			default_create
		end

create
	make_from_string, make_from_string_with_agent, default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			Precursor
			literal_text := Empty_literal_text
		end


	make_from_string (literal: EL_ASTRING)
			--
		do
			default_create
			set_literal_text (literal)
		end

	make_from_string_with_agent (literal: STRING; action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]])
			--
		do
			make_from_string (literal)
			action_on_match := action
		end

feature {NONE} -- Implementation

	actual_try_to_match
			--
		do
			if target_text.starts_with (literal_text) then
				match_succeeded := true
				count_characters_matched := literal_text.count
			end
		end

feature -- Element change

	set_literal_text (a_literal: READABLE_STRING_GENERAL)
			--
		do
			literal_text := a_literal
		end

feature -- Access

	literal_text: READABLE_STRING_GENERAL

feature {NONE} -- Constant

	Empty_literal_text: READABLE_STRING_GENERAL
			--
		once
			Result := create {STRING}.make_empty
		end

-- Used for specific test
-- invariant valid_action: action_on_match /= Void

end -- class EL_LITERAL_TEXTUAL_PATTERN