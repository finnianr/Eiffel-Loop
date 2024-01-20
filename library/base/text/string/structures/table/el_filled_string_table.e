note
	description: "Table of filled strings of type conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "5"

deferred class
	EL_FILLED_STRING_TABLE [STR -> READABLE_STRING_GENERAL]

inherit
	EL_FUNCTION_CACHE_TABLE [STR, TUPLE [uc: CHARACTER_32; n: INTEGER]]
		rename
			make as make_cache,
			item as result_item
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make
		do
			make_cache (11, agent new_filled)
		end

feature -- Access

	item (uc: CHARACTER_32; n: INTEGER): STR
		do
			if attached argument_key as key then
				key.uc := uc; key.n := n
				Result := result_item (key)
			end
		end

feature {NONE} -- Implementation

	new_filled (uc: CHARACTER_32; n: INTEGER): STR
		deferred
		end

end