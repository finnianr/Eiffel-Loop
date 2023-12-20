note
	description: "Generic named item assignable from tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_NAMED [G]

inherit
	EL_NAMEABLE [STRING]

create
	make

convert
	make ({TUPLE [STRING, G]})

feature {NONE} -- Initialization

	make (tuple: TUPLE [name: STRING; named_item: G])
		do
			name := tuple.name
			item := tuple.named_item
		end

feature -- Access

	item: G

	name: STRING

end