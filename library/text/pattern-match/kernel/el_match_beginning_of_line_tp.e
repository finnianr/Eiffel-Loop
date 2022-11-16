note
	description: "Match beginning of line"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-16 15:12:56 GMT (Wednesday 16th November 2022)"
	revision: "7"

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