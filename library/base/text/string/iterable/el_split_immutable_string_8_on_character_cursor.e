note
	description: "[
		${EL_SPLIT_ON_CHARACTER_CURSOR [IMMUTABLE_STRING_8]} implemented using
		`shared_substring' for `item_copy'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-19 19:58:22 GMT (Wednesday 19th July 2023)"
	revision: "7"

class
	EL_SPLIT_IMMUTABLE_STRING_8_ON_CHARACTER_CURSOR

inherit
	EL_SPLIT_ON_CHARACTER_8_CURSOR [IMMUTABLE_STRING_8]
		redefine
			item, item_copy
		end

create
	make

feature -- Access

	item: IMMUTABLE_STRING_8
		-- new of `target' at current split position with shared area
		do
			Result := target.shared_substring (item_lower, item_upper)
		end

	item_copy: IMMUTABLE_STRING_8
		-- new substring of `target' at current split position
		do
			Result := target.substring (item_lower, item_upper)
		end

end