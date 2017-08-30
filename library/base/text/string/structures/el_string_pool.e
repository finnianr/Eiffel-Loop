note
	description: "String recycling pool"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
		do
			if is_empty then
				create Result.make_empty
			else
				Result := item
				remove
			end
		end

feature -- Element change

	recycle (str: like item)
		do
			str.keep_head (0)
			put (str)
		end
end
