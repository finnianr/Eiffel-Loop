note
	description: "Summary description for {EL_MATCH_BEGINNING_OF_LINE_TP2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_MATCH_BEGINNING_OF_LINE_TP

inherit
	EL_TEXT_PATTERN
		rename
			make_default as make
		end

create
	make

feature -- Access

	name: STRING
		do
			Result := "start_of_line"
		end

feature {NONE} -- Implementation

	match_count (text: EL_STRING_VIEW): INTEGER
			--
		do
			if not text.is_start_of_line then
				Result := Match_fail
			end
		end
end