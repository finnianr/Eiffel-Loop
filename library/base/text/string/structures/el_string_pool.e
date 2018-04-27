note
	description: "String recycling pool"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-18 9:35:22 GMT (Friday 18th August 2017)"
	revision: "1"

class
	EL_STRING_POOL [S -> STRING_GENERAL create make_empty end]

inherit
	ARRAYED_STACK [S]
		export
			{NONE} all
		end

create
	make

feature -- Access

	new_string: like item
		-- a new or recycled empty string
		do
			if is_empty then
				create Result.make_empty
			else
				-- `recycle' has already wiped out the string
				Result := item
				remove
			end
		ensure
			empty: Result.is_empty
		end

feature -- Element change

	recycle (str: like item)
		do
			str.keep_head (0) -- wipe out
			put (str)
		end
end
