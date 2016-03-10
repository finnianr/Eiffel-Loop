note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

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
			if text.count > 0 then
				if character_range.has (text.item (1).to_integer_32) then
					match_succeeded := true
					count_characters_matched := 1
				end
			end
		end

	character_range: INTEGER_INTERVAL

end -- class EL_MATCH_CHAR_IN_ASCII_RANGE_TP

