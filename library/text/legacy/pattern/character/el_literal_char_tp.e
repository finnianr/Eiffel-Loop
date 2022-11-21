note
	description: "Literal char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_LITERAL_CHAR_TP

inherit
	EL_SINGLE_CHAR_TEXT_PATTERN

create
	make, make_with_action

feature {NONE} -- Initialization

	make (a_code: like code)
			--
		do
			make_default
			code := a_code
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