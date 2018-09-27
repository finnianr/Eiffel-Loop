note
	description: "End of line char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_END_OF_LINE_CHAR_TP

inherit
	EL_LITERAL_CHAR_TP
		rename
			make as make_with_code,
			make_with_action as make_literal_with_action
		redefine
			match_count
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_with_code (10)
		end

feature {NONE} -- Implementation

	match_count (text: EL_STRING_VIEW): INTEGER
		do
			if text.count = 0 then
				Result := 0
			else
				Result := Precursor (text)
			end
		end

end