note
	description: "[
		${EL_SPLIT_ON_CHARACTER_CURSOR [IMMUTABLE_STRING_32]} implemented using
		`shared_substring' for `item_copy'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 12:38:52 GMT (Tuesday 20th August 2024)"
	revision: "10"

class
	EL_SPLIT_IMMUTABLE_STRING_32_ON_CHARACTER_CURSOR

inherit
	EL_SPLIT_ON_CHARACTER_32_CURSOR [IMMUTABLE_STRING_32]
		redefine
			item, item_copy
		end

create
	make

feature -- Access

	item: IMMUTABLE_STRING_32
		-- new substring of `target' at current split position with shared rea
		do
			Result := target.shared_substring (item_lower, item_upper)
		end

	item_copy: IMMUTABLE_STRING_32
		-- new substring of `target' at current split position
		do
			Result := target.substring (item_lower, item_upper)
		end

end