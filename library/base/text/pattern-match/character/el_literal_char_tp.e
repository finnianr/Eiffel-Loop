note
	description: "Literal char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_LITERAL_CHAR_TP

inherit
	EL_SINGLE_CHAR_TEXT_PATTERN

create
	make_from_character, make, make_with_action

feature {NONE} -- Initialization

	make (a_code: like code)
			--
		do
			make_default
			code := a_code
		end

	make_from_character (character: CHARACTER_32)
			--
		do
			make (character.code.to_natural_32)
		end

	make_with_action (a_code: like code; a_action: like actions.item)
			--
		do
			make (a_code); set_action (a_action)
		end

feature -- Access

	name: STRING
		do
			create Result.make (3)
			Result.append_character ('%'')
			if code <= 0xFF then
				Result.append_character (code.to_character_8)
			else
				Result.append_character ('?')
			end
			Result.append_character ('%'')
		end

feature {NONE} -- Implementation

	match_count (text: EL_STRING_VIEW): INTEGER
		do
			if text.count > 0 and then text.code (1) = code then
				Result := 1
			else
				Result := Match_fail
			end
		end

feature -- Access

	code: NATURAL_32

end