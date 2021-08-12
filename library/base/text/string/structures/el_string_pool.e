note
	description: "[
		Implementation of [$source EL_RECYCLING_POOL [S]] for items conforming to [$source STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-12 14:25:04 GMT (Thursday 12th August 2021)"
	revision: "4"

class
	EL_STRING_POOL [S -> STRING_GENERAL create make_empty end]

inherit
	EL_RECYCLING_POOL [S]
		rename
			make as make_pool
		redefine
			reuse_item
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_pool (agent: S do create Result.make_empty end)
		end

feature {NONE} -- Implementation

	reuse_item: like item
		-- a new or recycled empty string
		do
			Result := Precursor
			Result.keep_head (0)
		ensure then
			empty: Result.is_empty
		end

end