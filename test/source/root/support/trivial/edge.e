note
	description: "Edge"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EDGE [C -> NUMERIC]

feature -- Access

	cost: C
			-- Cost for traversing `Current'.
		local
			n: C
		do
			Result := n.one
		end

end