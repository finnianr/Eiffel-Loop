note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MATCH_CHAR_IN_ASCII_RANGE_TP

inherit
	EL_SINGLE_CHAR_TEXTUAL_PATTERN

create
	make


feature {NONE} -- Initialization

	make (from_code, to_code: NATURAL)
			--
		do
			default_create
			character_range := from_code.to_integer_32 |..| to_code.to_integer_32
		end


feature {NONE} -- Implementation

	actual_try_to_match
			--
		do
			if target_text.count > 0 then
				if character_range.has (target_text.item (1).to_integer_32) then
					match_succeeded := true
					count_characters_matched := 1
				end
			end
		end

	character_range: INTEGER_INTERVAL

end -- class EL_MATCH_CHAR_IN_ASCII_RANGE_TP

