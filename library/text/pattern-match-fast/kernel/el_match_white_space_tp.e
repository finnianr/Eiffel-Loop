note
	description: "Match consecutive white space"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-29 15:54:47 GMT (Saturday 29th October 2022)"
	revision: "1"

class
	EL_MATCH_WHITE_SPACE_TP

inherit
	EL_MATCH_CONTINUOUS_PROPERTY_TP
		rename
			i_th_has as is_i_th_space
		end

create
	make

feature -- Access

	name: STRING
		do
			Result := spell_minimum + " or more whitespace"
		end

feature {NONE} -- Implementation

	is_i_th_space (i: INTEGER_32; text: READABLE_STRING_GENERAL): BOOLEAN
			-- `True' if i'th character is white space
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			Result := c.is_space (text [i]) -- Work around for finalization bug
		end

end