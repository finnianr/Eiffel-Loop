note
	description: "[
		[$source EL_SPLIT_ON_CHARACTER_CURSOR [IMMUTABLE_STRING_8]] implemented using
		`shared_substring' for `item_copy'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-29 11:00:26 GMT (Monday 29th November 2021)"
	revision: "3"

class
	EL_SPLIT_IMMUTABLE_STRING_8_ON_CHARACTER_CURSOR

inherit
	EL_SPLIT_ON_CHARACTER_CURSOR [IMMUTABLE_STRING_8]
		redefine
			item_copy
		end

create
	make

feature -- Access

	item_copy: IMMUTABLE_STRING_8
		-- new substring of `target' at current split position
		do
			Result := target.shared_substring (item_lower, item_upper)
		end

end