note
	description: "Match any char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_MATCH_ANY_CHAR_TP

inherit
	EL_SINGLE_CHAR_TEXT_PATTERN
		rename
			make_default as make
		end

create
	make

feature -- Access

	name: STRING
		do
			Result := "any_character"
		end

feature {NONE} -- Implementation

	match_count (text: EL_STRING_VIEW): INTEGER
			--
		do
			if text.count > 0 then
				Result := 1
			else
				Result := Match_fail
			end
		end

end