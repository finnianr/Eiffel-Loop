note
	description: "Summary description for {EL_END_OF_LINE_CHAR_TP2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

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