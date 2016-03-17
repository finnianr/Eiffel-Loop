﻿note
	description: "Summary description for {EL_MATCH_BEGINNING_OF_LINE_TP2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 14:27:26 GMT (Sunday 20th December 2015)"
	revision: "4"

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
