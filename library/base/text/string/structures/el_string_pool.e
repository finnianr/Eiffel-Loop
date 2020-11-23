note
	description: "String recycling pool"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-23 13:33:05 GMT (Monday 23rd November 2020)"
	revision: "3"

class
	EL_STRING_POOL [S -> STRING_GENERAL create make_empty end]

inherit
	EL_RECYCLING_POOL [S]
		rename
			make as make_pool
		redefine
			reuseable_item
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_pool (agent: S do create Result.make_empty end)
		end

feature -- Access

	reuseable_item: like item
		-- a new or recycled empty string
		do
			Result := Precursor
			Result.keep_head (0)
		ensure then
			empty: Result.is_empty
		end

end