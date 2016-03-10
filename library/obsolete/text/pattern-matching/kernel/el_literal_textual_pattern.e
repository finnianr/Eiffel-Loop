note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 11:36:03 GMT (Wednesday 16th December 2015)"
	revision: "6"

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


	make_from_string (literal: like literal_text)
			--
		do
			default_create
			set_literal_text (literal)
		end

	make_from_string_with_agent (literal: like literal_text; action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]])
			--
		do
			make_from_string (literal)
			action_on_match := action
		end

feature {NONE} -- Implementation

	actual_try_to_match
			--
		do
			if text.starts_with (literal_text) then
				match_succeeded := true
				count_characters_matched := literal_text.count
			end
		end

feature -- Element change

	set_literal_text (a_literal: like literal_text)
			--
		do
			literal_text := a_literal
		end

feature -- Access

	literal_text: EL_ASTRING

feature {NONE} -- Constant

	Empty_literal_text: EL_ASTRING
			--
		once
			create Result.make_empty
		end

-- Used for specific test
-- invariant valid_action: action_on_match /= Void

end -- class EL_LITERAL_TEXTUAL_PATTERN
