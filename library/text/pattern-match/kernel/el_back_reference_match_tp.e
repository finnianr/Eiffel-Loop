note
	description: "matches text of previously matched pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_BACK_REFERENCE_MATCH_TP

inherit
	EL_TEXT_PATTERN
		redefine
			match_count
		end

create
	make

feature {NONE} -- Initialization

	make (a_pattern: like previous)
			--
		do
			make_default
			previous := a_pattern
		end

feature -- Access

	name: STRING
		do
			Result := "previous ()"
			Result.insert_string (previous.name, Result.count)
		end

feature {NONE} -- Implementation

	match_count (a_text: EL_STRING_VIEW): INTEGER
			--
		do
			if a_text.starts_with_interval (previous) then
				Result := previous.count
			else
				Result := Match_fail
			end
		end

	previous: EL_TEXT_PATTERN

end