note
	description: "Match character with a defined property"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-28 17:31:46 GMT (Friday 28th October 2022)"
	revision: "1"

deferred class
	EL_CHARACTER_PROPERTY_TP

inherit
	EL_SINGLE_CHAR_TEXT_PATTERN

feature {NONE} -- Implementation

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		local
			index: INTEGER
		do
			index := a_offset + 1
			if index <= text.count and then i_th_matches (index, text) then
				Result := 1
			else
				Result := Match_fail
			end
		end

	i_th_matches (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if i'th character matches pattern
		deferred
		end

end
