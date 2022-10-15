note
	description: "[
		Object to save and restore cursor position or index of a [$source TRAVERSABLE} container
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-15 5:47:18 GMT (Saturday 15th October 2022)"
	revision: "3"

class
	EL_SAVED_CURSOR [G]

inherit
	EL_CONTAINER_STRUCTURE [G]
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (traversable: TRAVERSABLE [G])
		do
			current_container := traversable
			push_cursor
		end

feature -- Basic operations

	restore
		do
			pop_cursor
		end

feature {NONE} -- Implementation

	current_container: TRAVERSABLE [G]

end