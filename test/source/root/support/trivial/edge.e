note
	description: "Edge"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-08 23:27:33 GMT (Saturday 8th January 2022)"
	revision: "1"

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