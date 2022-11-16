note
	description: "Table of filled strings of type [$source STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_FILLED_STRING_8_TABLE

inherit
	EL_FUNCTION_CACHE_TABLE [STRING, TUPLE [c: CHARACTER; n: INTEGER]]
		rename
			make as make_cache,
			item as result_item
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_cache (11, agent new_filled)
		end

feature -- Access

	item (c: CHARACTER; n: INTEGER): STRING
		do
			if attached argument_key as key then
				key.c := c; key.n := n
				Result := result_item (key)
			end
		end

feature {NONE} -- Implementation

	new_filled (c: CHARACTER; n: INTEGER): STRING
		do
			create Result.make_filled (c, n)
		end
end